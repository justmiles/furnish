
chalk = require 'chalk'

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
    @resourceName = chalk.blue @.constructor.name
    for option in @options
      @[option] = option
    
    @action = chalk.cyan @options.action
        
    @name = chalk.blue @name
    if @options.subscribes
      @subscribe @options.subscribes[0], @options.subscribes[1]
    
    unless @[chalk.stripColor(@action)]
      throw new Error "Resource #{@resourceName} has no action #{@action}"
    @_onLoad @options.action
 
 
  emit: (action) ->
    msg = "#{@name} Finished #{@resourceName}::#{chalk.cyan action}"
    unless action == 'nothing'
      for key,option of @options
        msg +=  "\n     #{key}: #{option}"
    console.log chalk.green(msg)
    @emitter.emit "#{chalk.stripColor(@resourceName)}:#{action}:#{chalk.stripColor(@name)}"
    
  callback: ->
    return null
    
  _onLoad: (action) ->
    resource = @
    @logger.debug "Onload action for '#{@name}' is #{@resourceName}::#{@action}"    
    @emitter.on "furnishings_loaded", ->
      console.log chalk.green "#{resource.name} Beginning #{resource.resourceName}::#{chalk.cyan action}" unless action == 'nothing'
      do resource[chalk.stripColor(action)]
  
  subscribe: (action, subscription) ->
    resource = @
    @logger.info "#{@resourceName} Subscribing [#{@resourceName}:#{chalk.cyan action}:#{@name}] to [#{subscription}]"
    @emitter.on subscription, ->
      console.log chalk.green "#{resource.name} Beginning #{resource.resourceName}::#{chalk.cyan action}"
      do resource[chalk.stripColor(action)]

  # Action nothing. Called when a resource should not converge
  # @note Emits 'nothing'
  nothing: ->
    @emit 'nothing'
    do @callback
    
  logger:
    info: (msg) ->
      console.log chalk.gray msg
    error: (msg) ->
      console.log chalk.red msg
    warn: (msg) ->
      console.log chalk.dim.yellow msg 
    debug: (msg) ->
      if process.env['DEBUG']?
        console.log msg
      
module.exports = Resource
