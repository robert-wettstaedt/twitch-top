chalk       = require 'chalk'

commands    = require './commands'
config      = require './config'

module.exports =

    log : ( namespace, msg ) ->

        console.log "[#{namespace}] #{msg}"


    clear : ->

        process.stdout.clearLine()
        process.stdout.cursorTo 0


    fetching : ->

        output = ''

        output += '\n'
        output += chalk.green '\tFetching channels..'

        process.stdout.write output


    streams : ( followingCount, streams ) ->

        printStream = ( stream, index ) ->
            indexLength = index.toString().length
            output += "[#{index + 1}] - #{chalk.green stream.channel.display_name} (#{stream.channel.name}) - #{stream.viewers}"
            output += '\n'
            output += " Game : #{stream.channel.game}"
            output += '\n'
            output += " Status : #{stream.channel.status}"

            output += "\n ----- \n"

        output = ''

        if followingCount > 0
            output += '\n'
            output += '\n'
            output += 'Your followed channels:'
            output += '\n'
            output += '\n'
            for index in [0...followingCount]
                printStream streams[index], index

        output += '\n'
        output += '\n'
        output += 'Top channels:'
        output += '\n'
        output += '\n'
        for index in [followingCount...streams.length]
            printStream streams[index], index

        console.log output
        @help()


    quality : ->

        output = ''

        output += '\t'
        output += "Selected quality: #{chalk.yellow config.read().quality}"
        output += '\n'

        console.log output


    help : ->

        @quality()

        output = ''

        for command of commands
            command = commands[command]

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

        setTimeout =>
            @help()
        , 300



