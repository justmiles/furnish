fs   = require 'fs'
path = require 'path'
async = require 'async'
#TODO: consider adding before/after functions
#TODO: figure out a way to have  the node's attributes available to everything
{EventEmitter}  = require 'events'

corePath = path.resolve __dirname, 'core'

class Furnish
  constructor: ->
    @events = new EventEmitter()
    @ranList = []
    @runList = {}

  _loadFurnisher: (file) ->
    packageName = path.basename(file).replace /\.[^/.]+$/, ''
    @[packageName] = require file unless @[packageName]?
    @events.emit "loaded:#{packageName}"
    @log "Furnish::#{packageName} loaded"

  _loadCoreFurnishers: () ->
    @log 'Loading core methods'
    for file in fs.readdirSync corePath
      @_loadFurnisher path.resolve corePath, file
    @events.emit "core-loaded"

  loadExternalFurnishers: (path) ->
    @log "loading external methods"
    for file in fs.readdirSync path
      @_loadFurnisher path.resolve path, file

  load: (directory) ->
    f = @
    @events.on 'core-loaded', ->
      f.log 'Core loaded successfully'

    @_loadCoreFurnishers()
    @loadRunList(directory)

  loadRunList: (directory) ->
    @log "loading run list"
    for file in fs.readdirSync directory
      packageName = file.replace /\.[^/.]+$/, ''
      @runList[packageName] = require(path.resolve directory, file)
      @log "#{packageName} added to run list"

    @log 'loaded'
    @events.emit 'loaded'

  run: ->
    furnish = @
    @log "Running furnish"

    async.forEachOf @runList, (furnisher, name, cb) ->
      furnish.log "Furnishing #{name}"
      furnish.logspace = name
      furnisher furnish, null, (err) ->
        furnish.logspace = null
        cb(err)
      , (err) ->
        throw new Error(err) if err

#    for name, furnisher of @runList
#      @log "Furnishing #{name}"
#      if typeof furnisher == 'function' && name != 'hosts'
#
#        @logspace = name
#        furnisher @, null, (err) ->
#          if err
#            throw new Error err
#          furnish.ranList.push name
#          @logspace = null

  log: (atr) ->
      console.log "#{@logspace or 'furnish'} - - #{atr}"

module.exports = Furnish