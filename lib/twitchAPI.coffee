https   = require 'https'


printer = require './printer'

offset  = 0
streams = []


module.exports =


    fetch : ( opts ) ->

        offset = 0 if opts?.refresh

        printer.fetching()

        https.get "https://api.twitch.tv/kraken/streams?limit=10&offset=#{offset}" , ( res ) ->
            data = ''
            offset += 10

            res.on 'data', ( chunk ) ->
                data += chunk

            res.on 'end', ->
                streams = JSON.parse( data ).streams
                printer.streams streams

        .on 'error', ( err ) ->
            console.log err


    get : ( index ) ->

        if streams[ index - 1 ]?
            return streams[ index - 1 ]

        printer.invalidStream()
        null