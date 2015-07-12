https   = require 'https'

printer = require './printer'
input   = require './input'

config  = null
resetConfig = ->
    config = 
        offset  : 0
        limit   : 9
        streams : []

input.on 'loadStreams', ( opts ) ->
    resetConfig() if opts.refresh
    config.offset += config.limit if opts.more
    exports.fetch()


exports = module.exports =

    fetch : ->

        config ?= resetConfig()
        
        printer.fetching()
        url = "https://api.twitch.tv/kraken/streams?limit=#{config.limit}&offset=#{config.offset}"

        https.request url , ( res ) ->

            data = ''

            res.on 'data', ( chunk ) ->
                data += chunk

            res.on 'end', ->
                try
                    for stream in JSON.parse( data ).streams
                        config.streams.push stream
                catch error
                    console.log error
                
                printer.clear()
                printer.streams config.streams

        .on 'error', ( err ) ->
            console.log err

        .end()


    get : ( index ) ->

        if config.streams[ index - 1 ]?
            config.streams[ index - 1 ]
        else
            printer.invalidStream()
            null


exports.fetch()