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

Decompress      = require 'decompress'
#decompressTarxz = require 'decompress-tarxz'

module.exports = (options = {}, callback = ->) ->
  # Required options


  # Default options
  options.strip or= 0
  options.destination or= '/tmp'

  if /tar$/.test options.path
    new Decompress()
    .src(options.path)
    .dest('dest')
    .use(Decompress.tar(options))
    .run(callback)

  else if /tar.xz$/.test options.path
    #tar xf archive.tar.xz
    cp = require 'child_process'
    command = "tar xf #{options.path} --strip-components=#{options.strip} -C #{options.destination}"
    console.log command
    cp.exec command, (error, stdout, stderr) ->
      console.log stdout
      console.log stderr
      console.log error if error
      callback()

  else if /tar.gz$/.test options.path
    new Decompress()
      .src(options.path)
      .dest('dest')
      .use(Decompress.targz(options))
      .run(callback)

  else if /zip$/.test options.path
    new Decompress()
    .src(options.path)
    .dest('dest')
    .use(Decompress.zip(options))
    .run(callback)

  else
    callback("I don't know how to extract #{options.path}")