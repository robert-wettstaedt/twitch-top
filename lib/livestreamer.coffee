shell   = require 'shelljs'

API     = require './twitchAPI'
printer = require './printer'
chat    = require './chat'
config  = require './config'
input   = require './input'

input.on 'selectStream', ( index ) ->
    exports.start index

.on 'selectQuality', ( quality ) ->
    config.write quality : quality
    printer.quality()

.on 'toggleChat', ->
    exports.toggleChat()


exports = module.exports = 

    start : ( index ) ->

        @stream = API.get index

        return if !@stream?

        url = "twitch.tv/#{@stream.channel.name}"

        printer.selectedStream @stream

        if shell.which 'livestreamer'

            shell.exec "livestreamer #{url} #{config.read().quality}", ( code, output ) =>
                console.log output
                @stream = null

                if code is 0
                    chat.disconnect()

        else
            shell.exec "open http://#{url}"

    stream : null

    toggleChat : ->
        chat.toggle @stream?.channel.name
