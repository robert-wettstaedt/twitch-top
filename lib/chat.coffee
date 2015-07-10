irc         = require 'tmi.js'
moment      = require 'moment'
chalk       = require 'chalk'

printer     = require './printer'

specials    = ['staff', 'admin', 'broadcaster', 'global_mod', 'mod']
currentChannel = null


exports = module.exports = 

    client : null

    connect : ( channel ) ->

        printer.log 'chat', "Connecting to #{currentChannel}.."

        currentChannel = channel

        @client = new irc.client channels : [ currentChannel ]

        @client.addListener 'connected', =>
            printer.log 'chat', "Connected to #{currentChannel}"

        @client.addListener 'connectfail', =>
            printer.log 'chat', "Failed to connect to #{currentChannel}"

        @client.connect()
        @client.addListener 'chat', ( channel, user, message ) ->

            output = "#{moment().format 'hh:mm:ss'}  -  "

            if -1 < specials.indexOf user['user-type']
                output += chalk.green "#{user['user-type']} #{user.username}"
            else
                output += chalk.yellow user['display-name'] or user.username

            output += ": #{chalk.magenta message}"
            printer.log 'chat', output


    disconnect : -> 

        @client?.addListener 'disconnected', =>
            printer.log 'chat', "Disconnected from #{currentChannel}\n"
            @client = null
            printer.help()

        @client?.disconnect()


    toggle : ( channel ) ->

        if !channel?
            return printer.log 'chat', chalk.red 'Select a channel first'

        currentChannel = channel

        if @client
            @disconnect()
        else
            @connect currentChannel
