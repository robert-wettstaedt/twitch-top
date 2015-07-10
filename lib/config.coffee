fs          = require 'fs'
path        = require 'path'

configPath  = path.join __dirname, '../config.json'

defaultConfig =
    quality : 'best'

module.exports =

    normalize : ( config ) ->
        
        for key, value of defaultConfig
            if !config[key]?
                config[key] = value
        config


    read : ->

        if fs.existsSync configPath

            config = JSON.parse fs.readFileSync configPath
            config = @normalize config

            @write config
            config

        else

            @write defaultConfig
            defaultConfig


    write : ( config ) ->

        config = @normalize config
        fs.writeFileSync configPath, JSON.stringify config, null, '\t'