#!/usr/bin/env coffee
program = require 'commander'
os      = require 'os'
path    = require 'path'
# pkg     = require path.resolve(__dirname, '..', 'package.json') 
pkg     = version: '1.0.0'
Furnish = require '../index'

furnish = new Furnish

furnish.events.on 'loaded', ->
  furnish.run()

program
  .version pkg.version
  .command '*'
  .description 'Run furnish against the path or file'
  .action (loadPath) ->
    console.log 'furnishing %s with "%s"', os.hostname(), loadPath
    loadPath = path.resolve(process.cwd(), loadPath)
    furnish.load loadPath
    return

program.parse process.argv