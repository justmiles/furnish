
config = 
  nodejs:
    version: process.env['NODE_VERSION'] or 'v4.4.2'
    
config.nodejs.install_location = "/tmp/nodejs/#{config.nodejs.version}"

module.exports = (furnish) ->
  
    furnish.Directory "Create Node.js Dir", {
        path: config.nodejs.install_location
        action: 'create'
    }
    
    furnish.RemoteFile "Download Node.js", {
        source: "https://nodejs.org/dist/#{config.nodejs.version}/node-#{config.nodejs.version}-linux-x64.tar.xz"
        destination: "#{config.nodejs.install_location}/node-#{config.nodejs.version}-linux-x64.tar.xz"
        owner: 'justmiles'
        group: 'justmiles'
        mode: '0755'
        action: 'nothing'
        subscribes: [ 'create', "Directory:create:Create Node.js Dir" ]
    }
    
    furnish.Extract "Deploy Node.JS", {
        path: "#{config.nodejs.install_location}/node-#{config.nodejs.version}-linux-x64.tar.xz"
        destination: config.nodejs.install_location
        strip: 1
        action: 'nothing'
        subscribes: [ 'extract', "RemoteFile:create:Download Node.js" ]
    }
    
    furnish.File "Delete Node.js targ.xz", {
      path: "#{config.nodejs.install_location}/node-#{config.nodejs.version}-linux-x64.tar.xz"
      action: 'nothing'
      subscribes: [ 'delete', "Extract:extract:Deploy Node.JS" ]
    }
