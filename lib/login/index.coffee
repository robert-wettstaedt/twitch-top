shell       = require 'shelljs'
chalk       = require 'chalk'

server      = require './server'
config      = require '../config'

clientID    = '5osa4ys4mwcec07kqyb9i68d8bhl85k'
port        = 7174
url         = "https://\"api.twitch.tv/kraken/oauth2/authorize\
                ?response_type=token\
                &client_id=#{clientID}\
                &redirect_uri=http://localhost:#{port}\
                &scope=user_read\""

server.listen port, ( err, token ) ->

    if err
        console.log chalk.red err
    else
        config.write token : token
        console.log chalk.green 'Login successful!'

    server.close()
    process.exit()


shell.exec "open #{url}"