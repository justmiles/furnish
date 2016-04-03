

module.exports = (install) ->

  exec = require('child_process').exec

  if /^http/.test install
    console.log 'attempting to install a remote package'

  child = exec "apt-get install #{install}", (error, stdout, stderr) ->
    console.log stdout
    console.log stderr
    # if error
    #   console.log error
