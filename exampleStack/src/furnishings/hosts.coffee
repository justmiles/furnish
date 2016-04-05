request = require 'request'
fs      = require 'fs'

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

hostsFile = '/etc/hosts'

errhandler = (err) ->
  if err
    throw new Error(err)

module.exports = (furnish, node, callback) ->
  return callback()
  fs.readFile hostsFile, (err, content) ->

    request 'https://devops.goandbewell.com/host-entries.txt', (err, response, body) ->
      errhandler(err)

      furnish.file
        file: hostsFile
        content: content.toString().replace /##DEVOPS-START##(.|\n)*##DEVOPS-END##/, '##DEVOPS-START##\n' + body + '\n##DEVOPS-END##\n'
      , errhandler