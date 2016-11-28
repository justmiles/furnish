'use strict'

# Description:
#   Installs a package.
#
# Parameters:
#   install: Package name
#
# Example:
#   furnish.package 'test'
#
# TODO:
#   windows support
#   brew (osx) support

Resource    = require '../lib/Resource'
  
# @option option [String] name Name of the resource
# @option option [String] action extract or nothing. Defaults to 'extract'
class Package extends Resource

  action: 'create'
    
  constructor: (@emitter, @name, @options, @callback = ->) ->
    @install = options if typeof options == 'string'
    super()
        
  create: ->
    f = @
    exec = require('child_process').exec
    
    if /^http/.test install
      console.log 'attempting to install a remote package'

    console.log "apt-get install #{@install}"

    exec "apt-get install #{@install}", (error, stdout, stderr) ->
      callback error if error
      console.log stdout
      console.log stderr
      f.emit 'create'
  
module.exports = (name, options, callback ) ->
  new Extract @events, name, options, callback

# 
# module.exports = (options = {}, callback = ->) ->
#   furnish = @
# 
#   install = options if typeof options == 'string'
# 
#   actions =  
#       nothing: ->
#         do callback
#         furnish.events.emit "package:nothing:#{name}"
#         
#       create: ->
#         exec = require('child_process').exec
# 
#         if /^http/.test install
#           console.log 'attempting to install a remote package'
# 
#         console.log "apt-get install #{install}"
# 
#         exec "apt-get install #{install}", (error, stdout, stderr) ->
#           callback error if error
#           console.log stdout
#           console.log stderr
#           furnish.events.emit "package:nothing:#{name}"
# 
#   new Resource @events, 'package', name, options, actions