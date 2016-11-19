
module.exports = (furnish) ->
  
    furnish.directory "Create Node.js Dir", {
        path: '/tmp/local/nodejs'
        action: 'create'
    }
    
    furnish.remoteFile "Download Node.js", {
        source: 'https://nodejs.org/dist/v4.4.2/node-v4.4.2-linux-x64.tar.xz'
        destination: '/tmp/local/nodejs/node-v4.4.2-linux-x64.tar.xz'
        owner: 'justmiles'
        group: 'justmiles'
        mode: '0755'
        action: 'nothing'
        subscribes: [ 'create', "directory:create:Create Node.js Dir" ]
    }
    
    furnish.extract "Extract Node.js", {
        path: '/tmp/local/nodejs/node-v4.4.2-linux-x64.tar.xz'
        destination: '/tmp/local/nodejs'
        action: 'nothing'
        subscribes: [ 'extract', "remoteFile:create:Download Node.js" ]
    }
