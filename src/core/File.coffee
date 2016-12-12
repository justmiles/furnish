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
cp = require 'child_process'
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
      unless @options.content? 
        throw new Error "Resource #{@resourceName} requires the 'content' option."
      
      if typeof @options.content == 'object'
          return @error 'no template provided!' unless @options.template
          @options.content = ejs.render(@options.template, @options.content, @options)
      
      if fs.existsSync @options.file
        currentSize = fs.statSync(@options.file).size
        desiredSize = Buffer.byteLength(@options.content, 'utf8')
        if currentSize == desiredSize
          return @nothing 'file size matches'
      fs.writeFile @options.file, @options.content, @callback
      
            
      if @options.mode?
        cp.execSync "chmod #{@options.mode} #{@options.destination}"
        
      @.emit 'create'
    
  delete: ->
      fs.unlink @options.path, @callback
  
module.exports = (name, options, callback ) ->
  new File @events, name, options, callback
