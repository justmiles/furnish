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
chalk = require 'chalk'
cp = require 'child_process'

# @option option [String] name Name of the resource
# @option option [String] action extract or nothing. Defaults to 'extract'
class Package extends Resource

  action: 'install'
    
  constructor: (@furnish, @name, @options, @callback = ->) ->
    super()
        
  install: ->
    resource = @
    source = chalk.stripColor(@name)
    
    if /^http/.test source        
      file = @furnish.RemoteFile 'Download Slack', {
          source: source
      }
      file.create()
      file.on 'create', ->
        resource.logger.info cp.execSync "dpkg -i #{file.destination}"
    
    else
      cp.exec "apt-get install #{@name}", (error, stdout, stderr) ->
        resource.logger.info stdout
        resource.logger.warn stderr
        if error
          return resource.error error 
        resource.finish 'create'
  
module.exports = (name, options, callback ) ->
  new Package @, name, options, callback
