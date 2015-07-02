shell   = require 'shelljs'


module.exports = 


    start : ( index ) ->

        API     = require './twitchAPI'
        printer = require './printer'

        stream  = API.get index

        return if !stream?

        url     = "twitch.tv/#{stream.channel.name}"

        printer.selectedStream stream

        if shell.which 'livestreamer'
            shell.exec "livestreamer #{url} #{@quality}"
        else
            shell.exec "open http://#{url}"

    quality : 'best'