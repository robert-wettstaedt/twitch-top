https   = require 'https'

printer = require './printer'
input   = require './input'

offset  = 0
limit   = 9
streams = []

input.on 'loadStreams', ( opts ) ->
    offset = 0 if opts.refresh
    offset += limit if opts.more
    exports.fetch()


exports = module.exports =

    fetch : ->
        
        printer.fetching()
        url = "https://api.twitch.tv/kraken/streams?limit=#{limit}&offset=#{offset}"

        https.request url , ( res ) ->

            data = ''

            res.on 'data', ( chunk ) ->
                data += chunk

            res.on 'end', ->
                try
                    streams = JSON.parse( data ).streams
                catch error
                    console.log error
                
                printer.clear()
                printer.streams streams

        .on 'error', ( err ) ->
            console.log err

        .end()


    get : ( index ) ->

        if streams[ index - 1 ]?
            streams[ index - 1 ]
        else
            printer.invalidStream()
            null


exports.fetch()