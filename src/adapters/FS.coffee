
# Description:
#   Config adapter for the filesystem
fs = require 'fs'

Adapter = require '../lib/Adapter'

class FS extends Adapter
  
  name: 'FS'
  confFile: 'furnish.json'
  
  constructor: (@events) ->    
    super()
    
  load: ->
    unless fs.existsSync @confFile
      fs.writeFileSync @confFile, JSON.stringify({}, null, 2)
  
  get: (val) ->
    conf = JSON.parse fs.readFileSync @confFile
    
    if val.match /\./
      conf = @_flatten conf

    return conf[val]
  
  watch: (val) ->
    adapter = @
    currentVal = @get val
    setInterval ->
      newVal = adapter.get val
      console.log newVal, currentVal
      if newVal != currentVal
        adapter.events.emit "config:#{val}:changed"
        currentVal = newVal
      else
        adapter.events.emit "config:#{val}:same"
    , 5000
    
module.exports = FS
