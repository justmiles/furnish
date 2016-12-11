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
#   yum support

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
      f.log 'attempting to install a remote package'

    f.log "apt-get install #{@install}"

    exec "apt-get install #{@install}", (error, stdout, stderr) ->
      callback error if error
      f.log stdout
      f.log stderr
      f.emit 'create'
  
module.exports = (name, options, callback ) ->
  new Extract @events, name, options, callback
