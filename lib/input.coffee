util = require 'util'

process.stdin.resume()
process.stdin.setEncoding 'utf8'


module.exports =


    start : ->

        process.stdin.on 'data', ( text ) =>

            printer = require './printer'
            API     = require './twitchAPI'
            livestreamer = require './livestreamer'


            text = text.replace '\n', ''

            # console.log 'received data:', util.inspect(text)
            

            if not isNaN index = parseInt text, 10
                livestreamer.start index

            else if -1 < @commands.exit.cmds.indexOf text
                printer.exit()
                process.exit()

            else if -1 < @commands.more.cmds.indexOf text 
                API.fetch()

            else if -1 < @commands.quality.cmds.indexOf ( parts = text.split( ' ' ) )[0]

                if -1 < @commands.quality.args.indexOf parts[1]
                    livestreamer.quality = parts[1]
                    printer.help()

            else
                printer.invalidCommand()


    commands :
        
        stream : 
            cmds : [ '#' ]
            description : 'start livestreamer to stream the selected channel'

        more : 
            cmds : [ 'm', 'more' ]
            description : 'show more results'

        exit : 
            cmds : [ 'quit', 'exit' ]
            description : 'quit twitch-top'

        quality : 
            cmds : [ 'q', 'quality' ]
            args : [ 'best', 'high', 'medium', 'low', 'mobile' ]
            description : 'change the quality'

