fs = require 'fs'

for dir in fs.readdirSync __dirname
    if -1 < dir.indexOf '.'
        require "./#{dir}"
