module.exports =
    
    stream : 
        cmds : [ '#' ]
        description : 'start livestreamer to stream the selected channel'

    refresh :
        cmds : [ 'r', 'refresh' ]
        description : 'refresh list'

    more : 
        cmds : [ 'm', 'more' ]
        description : 'show more results'

    quality : 
        cmds : [ 'y', 'quality' ]
        args : [ 'best', 'high', 'medium', 'low', 'mobile', 'worst', 'audio' ]
        description : 'change the quality'

    chat :
        cmds : [ 'c', 'chat' ]
        description : 'toggle chat'

    exit : 
        cmds : [ 'q', 'quit', 'exit' ]
        description : 'quit twitch-top'