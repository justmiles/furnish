# Description:
#   Extracts, packs, or parses a tar
#
# Options:
#   path: path to tar
#   strip: how many path segments to strip from the root when extracting
#
# Example:
#   furnish.directory 'test'
#
# TODO:
#   windows support
#   brew (osx) support

mkdirp = require 'mkdirp'
fs     = require 'fs'
Resource = require '../lib/Resource'

# @example Create a directory
# furnish.directory "Node.JS Install Directory", {
#   path: '/tmp/local/nodejs'
#   action: 'create'
# } 
#  
# @option option [String] name Name of the resource
# @option option [String] action create, delete, or nothing. Defaults to 'create'
# @option option [String] path Path to manage
# @option option [String] mode mode of directory
# @option option [String] owner directory owner
# @option option [String] group that owns directory
class Directory extends Resource
  
  name: null
  
  emitter: null
  
  constructor: (@emitter, @name, @options = {}, @callback = ->) ->
    @options.action or= 'create'
    @actions  = [
      'create'
      'delete'
      'nothing'
    ]
    super()
    
  # @todo document this
  create: ->
    f = @
    if fs.existsSync(@options.path)
      return @emit 'nothing'
    mkdirp @options.path, ->
      f.emit 'create'
      do f.callback
  
  # @todo document this
  delete: ->
    console.log "Deleting directory #{@options.path}"
    deleteFolderRecursive @options.path
    @emit 'delete'
    
# Utilities
deleteFolderRecursive = (path) ->
  if fs.existsSync(path)
    fs.readdirSync(path).forEach (file, index) ->
      curPath = path + '/' + file
      if fs.lstatSync(curPath).isDirectory()
        # recurse
        deleteFolderRecursive curPath
      else
        # delete file
        fs.unlinkSync curPath
      return
    fs.rmdirSync path
  return
    
module.exports = (name, options, callback ) ->
  new Directory @events, name, options, callback
  