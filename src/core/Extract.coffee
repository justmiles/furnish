'use strict'

# Description:
#   Extracts, packs, or parses a tar
#
# Options:
#   path: path to tar
#   strip: how many path segments to strip from the root when extracting
#
# Example:
#   furnish.package 'test'
#
# TODO:
#   windows support
#   brew (osx) support

Decompress  = require 'decompress'
Resource    = require '../lib/Resource'
os          = require 'os'

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
class Extract extends Resource
  
  action: 'extract'
  
  destination: os.tmpdir()
  
  strip: 0
    
  constructor: (@emitter, @name, @options, @callback = ->) ->    
    super()
        
  # @todo document this
  extract: ->
    f = @
    done = ->
      f.emit 'extract'
      
    if /tar$/.test @options.path
      new Decompress()
      .src(@options.path)
      .dest('dest')
      .use(Decompress.tar(@options))
      .run(@callback)

    else if /tar.xz$/.test @options.path
      cp = require 'child_process'
      command = "tar xf #{@options.path} --strip-components=#{@options.strip} -C #{@options.destination}"
      console.log command
      cp.exec command, (error, stdout, stderr) ->
        console.log stdout
        console.log stderr
        console.log error if error
        do done

    else if /tar.gz$/.test @options.path
      new Decompress()
        .src(@options.path)
        .dest('dest')
        .use(Decompress.targz(@options))
        .run(done)
        .run(@callback)

    else if /zip$/.test @options.path
      new Decompress()
      .src(@options.path)
      .dest('dest')
      .use(Decompress.zip(@options))
      .run(done)
      .run(@callback)

    else
      @callback("I don't know how to extract #{@options.path}")
        
module.exports = (name, options, callback ) ->
  new Extract @events, name, options, callback
