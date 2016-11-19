fs    = require 'fs'
path  = require 'path'
async = require 'async'
{EventEmitter2} = require 'eventemitter2'
{EventEmitter}  = require 'events'

corePath = path.resolve __dirname, 'core'

class Furnish
  constructor: ->
    @events = new EventEmitter2
      wildcard: true,
      delimiter: ':', 
      newListener: false,
      maxListeners: 2000,
      verboseMemoryLeak: true

    @ranList = []
    @runList = {}
    @events.onAny (event) ->
      console.log "EVENT   - - #{this.event}"
      
  _loadFurnisher: (file) ->
    packageName = path.basename(file).replace /\.[^/.]+$/, ''
    @[packageName] = require file unless @[packageName]?
    @events.emit "loaded:furnisher:#{packageName}"
    @log "Furnish::#{packageName} loaded"

  _loadCoreFurnishers: () ->
    @log 'Loading core methods'
    @events.emit "event.test"
    for file in fs.readdirSync corePath
      @_loadFurnisher path.resolve corePath, file

  loadExternalFurnishers: (path) ->
    @log "loading external methods"
    for file in fs.readdirSync path
      @_loadFurnisher path.resolve path, file

  load: (directory) ->
    f = @
    @_loadCoreFurnishers()
    @loadRunList(directory)

  loadFile: (file) ->
    packageName = file.replace /\.[^/.]+$/, ''
    @runList[packageName] = require(file)
    @log "#{packageName} added to run list"

  loadRunList: (loadPath) ->
    @log "loading run list"
    
    if fs.lstatSync(loadPath).isDirectory()
      for file in fs.readdirSync loadPath
        @loadFile(path.resolve loadPath, file)
    else
      @loadFile(path.resolve loadPath)

    @log 'loaded'
    @events.emit 'loaded'

  run: ->
    furnish = @
    @log "Running furnish"

    async.forEachOf @runList, (furnisher, name, cb) ->
      furnish.log "Furnishing #{name}"
      furnish.logspace = name
      try
        furnisher furnish
      catch err
        console.log ("Failed to furnish '#{name}'.\n" + err.stack)
        process.exit(1)
      furnish.events.emit 'furnishings_loaded'
      
  log: (atr) ->
      console.log "#{@logspace or 'furnish'} - - #{atr}"

module.exports = Furnish