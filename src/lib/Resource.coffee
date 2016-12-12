
chalk = require 'chalk'
{EventEmitter} = require 'events'

# @option option [String] name Name of the resource
# @option option [String] action create, delete, or nothing. Defaults to 'create'
# @option option [String] path Path to manage
# @option option [String] mode mode of directory
# @option option [String] owner directory owner
# @option option [String] group that owns directory
class Resource extends EventEmitter
  
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
    
    for option,value of @options
      @[option] = value
    
    @action = chalk.cyan @options.action
        
    @name = chalk.blue @name
    if @options.subscribes
      @subscribe @options.subscribes[0], @options.subscribes[1]
    
    unless @[chalk.stripColor(@action)]
      throw new Error "Resource #{@resourceName} has no action #{@action}"
    @_onLoad @options.action
 
 
  finish: (action) ->
    msg = "Furnished #{@resourceName} \"#{@name}\" with action #{chalk.cyan action}"
    unless action == 'nothing'
      for key,option of @options
        msg +=  "\n     #{key}: #{option}"
    console.log chalk.green(msg)
    @furnish.events.emit "#{chalk.stripColor(@resourceName)}:#{action}:#{chalk.stripColor(@name)}"
    @emit chalk.stripColor action
    
  callback: ->
    return null
    
  _onLoad: (action) ->
    resource = @
    @logger.debug "Onload action for '#{@name}' is #{@resourceName}::#{@action}"    
    @furnish.events.on "furnishings_loaded", ->
      resource.startAction action

  startAction: (action) ->
    console.log chalk.green "Furnishing #{@resourceName} \"#{@name}\" with action #{chalk.cyan action}"
    try
      do @[chalk.stripColor(action)]
    catch err
      @error err.message, err.stack
      
  subscribe: (action, subscription) ->
    resource = @
    @logger.info "#{@resourceName} Subscribing [#{@resourceName}:#{chalk.cyan action}:#{@name}] to [#{subscription}]"
    @furnish.events.on subscription, ->
      resource.startAction action
      
  # Action nothing. Called when a resource should not converge
  # @note Emits 'nothing'
  nothing: (reason) ->
    if reason
      @logger.info "Not furnishing #{@name}: #{reason}"
    @finish 'nothing'
    do @callback
    
  error: (reason, stacktrace) ->
    if stacktrace
      stacktrace = stacktrace.split('\n').map((x)-> '\t\t' + x).join('\n')
    if reason
      @logger.error "Error furnishing #{@name}: #{reason}#{'\n' + stacktrace if stacktrace}"
    @finish 'error'
    do @callback
    
  logger:
    info: (msg) ->
      console.log '\t' + chalk.gray msg
    error: (msg) ->
      console.log '\t' + chalk.red msg
    warn: (msg) ->
      console.log '\t' + chalk.dim.yellow msg 
    debug: (msg) ->
      if process.env['DEBUG']?
        console.log msg
      
module.exports = Resource
