ee          = new ( require( 'events' ).EventEmitter )()

commands    = require './commands'
printer     = require './printer'

process.stdin.resume()
process.stdin.setEncoding 'utf8'

process.stdin.on 'data', ( text ) ->

    text = text.replace '\n', ''

    if not isNaN index = parseInt text, 10
        ee.emit 'selectStream', index

    else if -1 < commands.refresh.cmds.indexOf text
        ee.emit 'loadStreams', refresh : true

    else if -1 < commands.more.cmds.indexOf text 
        ee.emit 'loadStreams', more : true

    else if -1 < commands.quality.cmds.indexOf ( parts = text.split( ' ' ) )[0]

        if -1 < commands.quality.args.indexOf parts[1]
            ee.emit 'selectQuality', parts[1]


    else if -1 < commands.exit.cmds.indexOf text
        printer.exit()
        process.exit()

    else
        printer.invalidCommand()


module.exports = ee