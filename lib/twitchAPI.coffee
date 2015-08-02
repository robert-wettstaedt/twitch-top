https   = require 'https'
qs      = require 'querystring'

printer = require './printer'
input   = require './input'
config  = require './config'

state  = null
resetState = ->
    state =
        offset  : 0
        limit   : 9
        streams : []

input.on 'loadStreams', ( opts ) ->
    resetState() if opts.refresh
    state.offset += state.limit if opts.more
    exports.fetch()


exports = module.exports =

    startRequest : ( path, params, cb ) ->

        params  = qs.stringify params
        url     = "https://api.twitch.tv/kraken/#{path}?#{params}"

        https.request url, ( res ) ->

            data    = ''

            res.on 'data', ( chunk ) ->
                data += chunk

            res.on 'end', ->
                try
                    cb JSON.parse( data ).streams
                catch error
                    console.log error

        .on 'error', ( err ) ->
            console.log err

        .end()


    fetch : ->

        concatChannels = ->
            if callbacks >= 0
                state.streams = state.streams.concat fChannels, channels
                printer.clear()
                printer.streams fChannels.length, state.streams

        printer.fetching()

        state ?= resetState()

        fChannels       = []
        channels        = []
        getFollowing    = state.offset is 0 and ( token = config.read().token )?
        callbacks       = if getFollowing then -2 else -1

        if getFollowing
            @startRequest '/streams/followed',
                oauth_token : token
            , ( streams ) ->
                ++callbacks
                fChannels = streams
                concatChannels()

        @startRequest '/streams',
            limit : state.limit
            offset : state.offset
        , ( streams ) ->
            ++callbacks
            channels = streams
            concatChannels()


    get : ( index ) ->

        if ( stream = state.streams[ index - 1 ] )?
            stream
        else
            printer.invalidStream()
            null


exports.fetch()