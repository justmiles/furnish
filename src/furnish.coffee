fs   = require 'fs'
path = require 'path'
packageModule = require path.resolve 'src', 'core', 'package'

box = {
  package: packageModule
}






















for file in fs.readdirSync path.resolve 'furnishings'
  console.log "loading #{file}"
  furnishing = require path.resolve 'furnishings', file

  if typeof furnishing == 'function'
    furnishing(box)
    break

  furnishing.before() if furnishing.before?
  furnishing.after() if furnishing.after?

console.log box
