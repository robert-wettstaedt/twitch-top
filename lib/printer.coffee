chalk = require 'chalk'


input = require './input'
livestreamer = require './livestreamer'


module.exports = 


    fetching : ->

        output = ''

        output += '\n'
        output += chalk.green '\tFetching channels..'
        output += '\n'

        console.log output


    streams : ( streams ) ->
        output = ''

        for stream, index in streams
            indexLength = index.toString().length
            output += "[#{index + 1}] - #{chalk.green stream.channel.display_name} (#{stream.channel.name}) - #{stream.viewers}"
            output += "\n"
            output += " Game : #{stream.channel.game}"
            output += "\n"
            output += " Status : #{stream.channel.status}"

            output += "\n ----- \n"

        console.log output#.join()
        @help()


    help : ->

        output = ''

        output += '\t'
        output += "Selected quality: #{livestreamer.quality}"
        output += '\n\n'

        for command of input.commands
            command = input.commands[command]

            output += '\t'

            for cmd, index in command.cmds
                output += "#{chalk.yellow cmd} "

                if index < command.cmds.length - 1
                    output += '/ '

            if command.args?
                output += '<'
                
                for arg, index in command.args
                    output += "#{arg}"

                    if index < command.args.length - 1
                        output += ', '

                output += '> '

            output += "- #{command.description}"
            output += '\n'

        console.log output


    exit : ->

        console.log chalk.red '\n\tSee you next time!'


    selectedStream : ( stream ) ->

        output = ''

        output += '\n'
        output += chalk.yellow "\tStarting #{stream.channel.name}'s stream"
        output += '\n'

        console.log output


    invalidStream : ->

        output = ''

        output += '\n'
        output += chalk.red '\tSeems like this stream does not exist :('
        output += '\n'

        console.log output


    invalidCommand : ->

        output = ''

        output += '\n'
        output += chalk.red '\tInvalid command'
        output += '\n'

        console.log output

        setTimeout @help, 300



