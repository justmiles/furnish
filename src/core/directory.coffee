# Description:
#   Extracts, packs, or parses a tar
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

mkdirp = require 'mkdirp'

module.exports = (options = {}, callback = ->) ->
  if typeof options == 'string'
    directory = options
    options = {}
    options.directory = directory

  mkdirp options.directory, callback