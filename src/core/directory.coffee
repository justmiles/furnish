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

module.exports = (name, options = {}, callback = ->) ->
  furnish = @
  options.path   or= name
  options.action or= 'create'

  actions =
    create: ->
      if fs.existsSync(options.path)
        return furnish.events.emit "directory:nothing:#{name}"
      mkdirp options.path, callback
      furnish.events.emit "directory:create:#{name}"
    
    delete: ->
      console.log "Deleting directory #{options.path}"
      mkdirp options.path, callback
      
    nothing: ->
      callback()

  new Resource @events, 'directory', name, options, actions
  