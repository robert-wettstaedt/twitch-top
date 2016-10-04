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
                    data = JSON.parse data
                    if data.streams?
                        return cb data.streams

                    throw new Error data

                catch error
                    printer.error null, 'There is an error with the Twitch API, please try again'

        .on 'error', ( err ) ->
            printer.error null, err.message

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
                client_id : config.read().client_id
            , ( streams ) ->
                ++callbacks
                fChannels = streams
                concatChannels()

        @startRequest '/streams',
            limit : state.limit
            offset : state.offset
            client_id : config.read().client_id
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
