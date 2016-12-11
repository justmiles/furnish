
module.exports = (furnish) ->
    
    # Gather our configs
    install_location  = furnish.config.get('nodejs.install_location')
    
    furnish.config.watch 'nodejs.version'
    
    # Execute the Directory resource to create our Node.js installion directory
    directory = furnish.Directory "Create Node.js Dir Watched", {
        path: install_location
        action: 'create'
    }
    directory.subscribe 'delete', "config:nodejs.version:changed"
    directory.subscribe 'create', "Directory:delete:Create Node.js Dir Watched"
    
    # Download the Node.JS artifact. Note that this resource subscribes to the above Directory resource
    furnish.RemoteFile "Download Node.js Watched", {
        source: "https://nodejs.org/dist/#{furnish.config.get('nodejs.version')}/node-#{furnish.config.get('nodejs.version')}-linux-x64.tar.xz"
        destination: "#{install_location}/node-#{furnish.config.get('nodejs.version')}-linux-x64.tar.xz"
        owner: 'justmiles'
        group: 'justmiles'
        mode: '0755'
        action: 'nothing'
        subscribes: [ 'create', "Directory:create:Create Node.js Dir Watched" ]
    }
    
    # Explode our Node.JS file
    furnish.Extract "Deploy Node.JS Watched", {
        path: "#{install_location}/node-#{furnish.config.get('nodejs.version')}-linux-x64.tar.xz"
        destination: install_location
        strip: 1
        action: 'nothing'
        subscribes: [ 'extract', "RemoteFile:create:Download Node.js Watched" ]
    }
    
    # Clean up!
    furnish.File "Delete Node.js targ.xz Watched", {
      path: "#{install_location}/node-#{furnish.config.get('nodejs.version')}-linux-x64.tar.xz"
      action: 'nothing'
      subscribes: [ 'delete', "Extract:extract:Deploy Node.JS Watched" ]
    }
