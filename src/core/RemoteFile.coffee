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
http      = require 'http'
https     = require 'https'
url       = require 'url'
Resource  = require '../lib/Resource'


# @example Download a remote file
# furnish.remoteFile "Download Node.js", {
#   source: 'https://nodejs.org/dist/v4.4.2/node-v4.4.2-linux-x64.tar.xz'
#   destination: '/tmp/local/nodejs/node-v4.4.2-linux-x64.tar.xz'
#   owner: 'justmiles'
#   group: 'justmiles'
#   mode: '0755'
#   action: 'nothing'
#   subscribes: [ 'create', "directory:create:Create Node.js Dir" ]
# }
#  
# @option option [String] name Name of the resource
# @option option [String] action create, delete, or nothing. Defaults to 'create'
# @option option [String] directory Path to manage
# @option option [String] saveAs mode of directory
# @option option [String] destination directory owner
# @option option [String] owner directory owner
# @option option [String] group that owns directory
class RemoteFile extends Resource
  
  name: null
  
  emitter: null
  
  constructor: (@emitter, @name, @options = {}, @callback = ->) ->
        
    throw new Error ('ensure `source` is defined') unless @options.source
    
    unless @options.destination?
      @options.directory or= path.resolve os.tmpdir(), 'remoteFiles'
      @options.saveAs or= path.basename url.parse(@options.source).pathname
      @options.destination or= path.resolve @options.directory, @options.saveAs
    
    @options.action or= 'create'
    super()
    
  # @todo document this
  create: ->
    f = @
    return @callback() if fs.existsSync(@options.destination)
    source = url.parse(@options.source)
    file = fs.createWriteStream @options.destination
    
    if source.protocol == 'http:'
      httpProto = http 
    else if source.protocol == 'https:'
      httpProto = https 
    
    request = httpProto.get source.href, (response) ->
      response.pipe file
    
    request.on 'close', ->
      f.callback(null, f.options.destination)
      f.emit 'create'
      
  # @todo document this
  delete: ->
    @logger.error "TODO: Deleting remote file #{@options.destination}"
    @emit 'delete'
  
module.exports = (name, options, callback ) ->
  new RemoteFile @events, name, options, callback

