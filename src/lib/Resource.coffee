class Resource

  constructor: (emitter, resourceName = 'resource', name, options = {}, actions) ->
    
    if options.subscribes
      console.log "Subscribing #{resourceName}:#{options.subscribes[0]}:#{name} to #{options.subscribes[1]}"
      emitter.on options.subscribes[1], ->
        do actions[options.subscribes[0]]
    
    emitter.on "furnishings_loaded", ->
      do actions[options.action]
    
module.exports = Resource
