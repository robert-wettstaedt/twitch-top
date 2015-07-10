fs = require 'fs'

for dir in fs.readdirSync __dirname
    require "./#{dir}"
