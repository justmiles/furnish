furnish = require 'furnish'
async   = require 'async'


async.waterfall [

  (cb) ->
    furnish.directory '/usr/local/nodejs', cb

  (path, cb) ->
    furnish.remoteFile
      source: 'https://nodejs.org/dist/v4.4.2/node-v4.4.2-linux-x64.tar.xz'
      owner: 'justmiles'
      group: 'justmiles'
      mode: '0755'
    , cb

  (path, cb) ->
    furnish.tar
      path: path
      destination: '/usr/local/nodejs'
    , cb

], (err, res) ->
  console.log err if err
  console.log res if res

console.log Object.keys furnish

