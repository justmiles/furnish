
#!/usr/bin/env coffee
# vim:ft=coffee ts=2 sw=2 et :
# -*- mode:coffee -*-

Furnish         = require '..'
fs              = require 'fs'
#OptParse       = require 'optparse'
#Path           = require 'path'

Switches = [
  [ "-a", "--adapter ADAPTER", "The Adapter to use" ]
  [ "-c", "--create PATH",     "Create a deployable hubot" ]
  [ "-d", "--disable-httpd",   "Disable the HTTP server" ]
  [ "-h", "--help",            "Display the help information" ]
  [ "-l", "--alias ALIAS",     "Enable replacing the robot's name with alias" ]
  [ "-n", "--name NAME",       "The name of the robot in chat" ]
  [ "-r", "--require PATH",    "Alternative scripts path" ]
  [ "-t", "--config-check",    "Test hubot's config to make sure it won't fail at startup"]
  [ "-v", "--version",         "Displays the version of hubot installed" ]
]


furnish = new Furnish()

furnish.events.on 'loaded', ->
  furnish.run()

furnish.load('/Users/miles.maddox/workspace/furnish-workstation/src/furnishings')

console.log Object.keys furnish.runList

