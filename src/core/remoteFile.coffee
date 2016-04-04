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

mkdirp = require 'mkdirp'
path   = require 'path'
cp     = require 'child_process'
url    = require 'url'
os     = require 'os'

module.exports = (options = {}, callback = ->) ->

  throw new Error ('ensure `source` is defined') unless options.source

  options.directory or= path.resolve os.tmpdir(), 'remoteFiles'
  options.saveAs or= path.basename url.parse(options.source).pathname
  finalForm = path.resolve options.directory, options.saveAs
  mkdirp options.directory, ->

    command = "wget #{options.source} --output-document=#{finalForm}"
    console.log command
    cp.exec command, (error, stdout, stderr) ->
      console.log stdout
      console.log stderr
      console.log error if error
      callback(null, finalForm)
