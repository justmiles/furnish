# @option option [String] name Name of the resource
# @option option [String] action create, delete, or nothing. Defaults to 'create'
# @option option [String] path Path to manage
# @option option [String] mode mode of directory
# @option option [String] owner directory owner
# @option option [String] group that owns directory
class Resource
  
  # @property [String] the resource name
  name: {}
  
  # @property [String] the resourceName of resource
  resourceName: 'unnamed'
  
  # @property [Hash<String>] A hash of various options
  options: {}
  
  # @property [EventEmitter] The event emitter
  emitter: null
  
  # @property [EventEmitter] The event emitter
  action: 'nothing'
  
      
  # @property [EventEmitter] The event emitter
  constructor: ->
    @resourceName = @.constructor.name
      
    for option in @options
      @[option] = option
    
    if @options.subscribes
      @_subscribe @options.subscribes[0], @options.subscribes[1]

    unless @[@action]
      throw new Error "Resource #{@resourceName} has no action #{@action}"
    do @_onLoad
 
 
  emit: (action = 'nothing') ->
    msg = "[#{@resourceName}]::#{action}  -  #{@name} (Finished)"
    unless action == 'nothing'
      msg += "\nConverged #{@resourceName} with action '#{action}' for '#{@name}'"
      for key,option of @options
        msg +=  "\n     #{key}: #{option}"
    console.log(msg)
    @emitter.emit "#{@resourceName}:#{action}:#{@name}"
    
  callback: ->
    return null
    
  _onLoad: () ->
    resource = @
    console.log "[#{@resourceName}] Onload action for #{@resourceName} is #{@options.action}"    
    @emitter.on "furnishings_loaded", ->
      do resource[resource.action]
  
  _subscribe: (action, subscription) ->
    resource = @
    console.log "[#{@resourceName}] Subscribing #{@resourceName}:#{action}:#{@name} to #{subscription}"
    @emitter.on subscription, ->
      console.log "#{resource.resourceName}::#{action}  -  #{resource.name} (Beginning)"
      do resource[action]

  # Action nothing. Called when a resource should not converge
  # @note Emits 'nothing'
  nothing: ->
    @emit 'nothing'
    do @callback
      
module.exports = Resource
