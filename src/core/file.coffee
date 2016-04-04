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

module.exports = (options = {}, callback = ->) ->

  if typeof  options.content == 'object'
    return callback 'no template provided!' unless options.template
    console.log 'creating object'
    options.content = ejs.render(options.template, options.content, options)

  fs.writeFile options.file, options.content, callback
