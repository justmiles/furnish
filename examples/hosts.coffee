os = require 'os'

module.exports = (furnish) ->
  
  furnish.Directory '/tmp/etc'
  
  furnish.File '/tmp/etc/hosts', {
    content: [
      "127.0.0.1		localhost"
      "127.0.1.1		#{os.hostname()}"
    ].join('\n') + '\n'
    action: 'nothing'
    subscribes: [ 'create', 'Directory:*:/tmp/etc' ]
  }
