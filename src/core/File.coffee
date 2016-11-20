# Description:
#   Writes a file
#
# Options:
#   content: the body/contents of the file
#   templatePath: Path to an EJS template
#   teamplate: EJS template string. Not used if templatePath is defined
#
# Example:
#   furnish.file
#     file: '/tmp/file'
#     content: 'Hello!'
#   , callback
#
# TODO:
#   windows support
#   brew (osx) support
#   set owner/group
#   mkdirp to ensure full path exists


mkdirp = require 'mkdirp'
fs = require 'fs'
ejs = require 'ejs'
Resource = require '../lib/Resource'

# @example Extract Node.js
# furnish.extract "Extract Node.js", {
#   path: '/tmp/local/nodejs/node-v4.4.2-linux-x64.tar.xz'
#   destination: '/tmp/local/nodejs'
#   action: 'nothing'
#   subscribes: [ 'extract', "remoteFile:create:Download Node.js" ]
# }
#  
# @option option [String] name Name of the resource
# @option option [String] action extract or nothing. Defaults to 'extract'
class File extends Resource
  
  action: 'create'
    
  constructor: (@emitter, @name, @options, @callback = ->) ->    
    super()
    
  create: ->
      if @typeof options.content == 'object'
          return callback 'no template provided!' unless @options.template
          console.log 'creating object'
          @options.content = ejs.render(@options.template, @options.content, @options)

      fs.writeFile @options.file, @options.content, callback
      @.emit 'create'
  
module.exports = (name, options, callback ) ->
  new Extract @events, name, options, callback
