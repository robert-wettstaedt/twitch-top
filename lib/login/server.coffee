http    = require 'http'
fs      = require 'fs'
path    = require 'path'
url     = require 'url'
qs      = require 'querystring'

server  = null

module.exports =

    listen : ( port, cb ) ->

        server = http.createServer ( req, res ) ->

            resError = ( error ) ->
                res.writeHead 500
                res.end 'Error'
                cb error if error?


            parsedUrl = url.parse req.url

            if parsedUrl.path is '/'

                fs.readFile path.resolve( __dirname, 'index.html' ), ( err, data ) ->
                    return resError err if err

                    res.writeHead 200,
                        'Content-Type' : 'text/html'
                        'Content-Length' : data.length
                    res.write data
                    res.end 'Success'

            else if parsedUrl.query?

                queries = qs.parse parsedUrl.query
                return resError new Error 'Unexpected parameter' if !queries.access_token?

                res.writeHead 200
                res.end 'Success'
                cb null, queries.access_token

            else

                resError()

        .listen port


    close : ->

        server?.close()