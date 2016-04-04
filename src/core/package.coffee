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


module.exports = (options = {}, callback = ->) ->

  install = options if typeof options == 'string'
  exec = require('child_process').exec

  if /^http/.test install
    console.log 'attempting to install a remote package'

  console.log "apt-get install #{install}"

  exec "apt-get install #{install}", (error, stdout, stderr) ->
    callback error if error
    console.log stdout
    console.log stderr
    # if error
    #   console.log error
