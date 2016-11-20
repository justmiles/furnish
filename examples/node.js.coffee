
module.exports = (furnish) ->
  
    furnish.Directory "Create Node.js Dir", {
        path: '/tmp/local/nodejs'
        action: 'create'
    }
    
    furnish.RemoteFile "Download Node.js", {
        source: 'https://nodejs.org/dist/v4.4.2/node-v4.4.2-linux-x64.tar.xz'
        destination: '/tmp/local/nodejs/node-v4.4.2-linux-x64.tar.xz'
        owner: 'justmiles'
        group: 'justmiles'
        mode: '0755'
        action: 'nothing'
        subscribes: [ 'create', "Directory:create:Create Node.js Dir" ]
    }
    
    furnish.Extract "Extract Node.js", {
        path: '/tmp/local/nodejs/node-v4.4.2-linux-x64.tar.xz'
        destination: '/tmp/local/nodejs'
        action: 'nothing'
        subscribes: [ 'extract', "RemoteFile:create:Download Node.js" ]
    }
