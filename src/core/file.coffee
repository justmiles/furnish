# Description:
#   Writes a file
#
# Options:
#   path: path to tar
#   strip: how many path segments to strip from the root when extracting
#
# Example:
#   furnish.directory 'test'
#
# TODO:
#   windows support
#   brew (osx) support
#   set owner/group
#   mkdirp to ensure full path exists


mkdirp = require 'mkdirp'
fs = require 'fs'
ejs = require 'ejs'
module.exports = (options = {}, callback = ->) ->

  if typeof options == 'string'
    content = options
    options = {}
    options.content = content


  if typeof  options.content == 'object'
    return callback 'no template provided!' unless options.template
    console.log 'creating object'
    options.content = ejs.render(options.template, options.content, options)

  fs.writeFile options.file, options.content, callback
