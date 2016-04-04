fs   = require 'fs'
path = require 'path'
#TODO: consider adding before/after functions
#TODO: figure out a way to have  the node's attributes available to everything

corePath = path.resolve __dirname, 'core'

process.furnish or= {}

for file in fs.readdirSync corePath
  packageName = file.replace /\.[^/.]+$/, ''
  console.log "Adding #{file} to Furnish as #{packageName}"
  process.furnish[packageName] = require path.resolve corePath, file unless process.furnish[packageName]?

  #  if typeof furnishing == 'function'
  #    furnishing(box)
  #    break

  #  furnishing.before() if furnishing.before?
  #  furnishing.after() if furnishing.after?


module.exports = process.furnish