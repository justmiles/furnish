
chalk = require 'chalk'

class Adapter
  
  # @property [String] the adapter name
  name: ''
  
  constructor: ->
    
  # Thanks @beilharz - https://gist.github.com/beilharz/245110e4ef8e5b208957
  _flatten: (object) ->
    res = {}
    for own key, value of object
      if (typeof value) is "object"
        flat = @_flatten(value)
        for own flatKey, flatValue of flat
          res[key + "." + flatKey] = flatValue
      else
        res[key] = value
    res
    
module.exports = Adapter
