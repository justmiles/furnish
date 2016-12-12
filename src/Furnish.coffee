'use strict'

fs    = require 'fs'
path  = require 'path'
async = require 'async'
chalk = require 'chalk'

{EventEmitter2} = require 'eventemitter2'

class Furnish
  
  runList: {}
  
  constructor: ->
    @events = new EventEmitter2
      wildcard: true,
      delimiter: ':', 
      newListener: false,
      maxListeners: 2000,
      verboseMemoryLeak: true
    
    if process.env['DEBUG']?
      @events.onAny (event) ->
        console.log "EVENT   - - #{this.event}"
     
  _loadCoreFurnishers: () ->
    @log 'Loading core methods'
    
    coreModules = 
      Directory:  require './core/Directory'
      Extract:    require './core/Extract'
      File:       require './core/File'
      Package:    require './core/Package'
      RemoteFile: require './core/RemoteFile'
      
    for coreModule, theFunction of coreModules
      @[coreModule] = theFunction unless @[coreModule]?
      @events.emit "loaded:furnisher:#{coreModule}"
      @log "Furnish::#{coreModule} loaded"

  loadExternalFurnishers: (path) ->
    @log "loading external methods"
    for file in fs.readdirSync path
      @_loadFurnisher path.resolve path, file

  load: (loadPath) ->
    @_loadCoreFurnishers()
    @loadRunList loadPath

  loadFile: (file) ->
    @log "loading file #{file}"
    packageName = file.replace /\.[^/.]+$/, ''
    unless @runList[packageName]?
      @runList[packageName] = require file
    @log "#{packageName} added to run list"

  loadRunList: (loadPath) ->
    @log "loading run list"
    
    if fs.lstatSync(loadPath).isDirectory()
      for file in fs.readdirSync loadPath
        @loadFile(path.resolve loadPath, file) if file.match /(\.coffee$|\.js$)/
    else
      @loadFile loadPath

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
        console.log chalk.bold.red ("Failed to furnish '#{name}'.\n" + err.stack)
        process.exit(1)
      furnish.events.emit 'furnishings_loaded'
      
  log: (atr) ->
    console.log chalk.gray "#{@logspace or 'furnish'} - - #{atr}" if process.env['DEBUG']?

module.exports = Furnish