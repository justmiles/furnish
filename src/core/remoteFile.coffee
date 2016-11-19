# Description:
#   Downloads a remote file.
#
# Parameters:
#   source: String - remote uri
#   owner: String - owner of the downloaded file
#   group: String - group of the downloaded file
#   mode: String - File's mode
#
# Example:
#   furnish.remoteFile
#     source: 'https://nodejs.org/dist/v4.4.2/node-v4.4.2-linux-x64.tar.xz'
#     owner: 'justmiles'
#     group: 'justmiles'
#     mode: '0755'
#
# TODO:
#   windows support
#   osx support
#   Set owner/group if defined

mkdirp    = require 'mkdirp'
path      = require 'path'
cp        = require 'child_process'
url       = require 'url'
os        = require 'os'
fs        = require 'fs'
Resource  = require '../lib/Resource'

module.exports = (name, options = {}, callback = ->) ->
  furnish = @
  
  throw new Error ('ensure `source` is defined') unless options.source

  options.directory or= path.resolve os.tmpdir(), 'remoteFiles'
  options.saveAs or= path.basename url.parse(options.source).pathname
  options.destination or= path.resolve options.directory, options.saveAs
  options.action or= 'create'

  actions =
    create: ->
      console.log 'creating'
      return callback() if fs.existsSync(options.destination)

      mkdirp options.directory, ->

        command = "wget #{options.source} --output-document=#{options.destination}"
        console.log command
        cp.exec command, (error, stdout, stderr) ->
          console.log stdout
          console.log stderr
          console.log error if error
          furnish.events.emit "remoteFile:create:#{name}"
          callback(null, options.destination)
    
    delete: ->
      console.log "TODO: Deleting remote file #{options.destination}"
      furnish.events.emit "remoteFile:delete:#{name}"
      
    nothing: ->
      furnish.events.emit "remoteFile:nothing:#{name}"
      callback()

  new Resource @events, 'remoteFile', name, options, actions
