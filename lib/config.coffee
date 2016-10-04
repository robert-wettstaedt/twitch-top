fs          = require 'fs'
path        = require 'path'

chalk       = require 'chalk'

configPath  = path.join __dirname, '../config.json'

defaultConfig =
    quality : 'best'
    client_id : '5osa4ys4mwcec07kqyb9i68d8bhl85k'

module.exports =

    normalize : ( src, target ) ->

        for key, value of src
            target[key] = value if !target[key]?
        target


    resetConfig : ->

        @write defaultConfig
        defaultConfig


    read : ->

        if fs.existsSync configPath

            file = fs.readFileSync configPath
            try
                return JSON.parse file
            catch
                console.log chalk.red 'Could not parse config file. Writing default config..'
                return @resetConfig()

        else

            console.log chalk.red 'Config does not exist. Writing default config..'
            @resetConfig()


    write : ( newConfig ) ->

        config = @read()
        config = @normalize config, newConfig
        config = @normalize defaultConfig, config

        fs.writeFileSync configPath, JSON.stringify config, null, '\t'

