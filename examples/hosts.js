// Generated by CoffeeScript 1.11.1
(function() {
  var os;

  os = require('os');

  module.exports = function(furnish) {
    furnish.Directory('/tmp/etc');
    return furnish.File('/tmp/etc/hosts', {
      content: ["127.0.0.1		localhost", "127.0.1.1		" + (os.hostname())].join('\n') + '\n',
      action: 'nothing',
      subscribes: ['create', 'Directory:*:/tmp/etc']
    });
  };

}).call(this);