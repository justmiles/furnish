# furnish
Furnish your machines with real-time configuration management.

# Examples
```
npm install -g furnish
cd examples
furnish node.js.coffee
```

# Goals and TODOs
* Furnish CLI should be easy to use. Pass it a directory, path to a script, or git repo to provision the plan
* Build an all inclusive CLI with Node.js baked in (nexe?)
* Wrap configuration methods in a class that is extended by various adapters. Default adapter could be a JSON file on the filesystem, while more advanced ones use Consul, FireBase, or MongoDB as the key/value store.
* Adapters should support triggering events (ie, resources can subscribe to a configuration key)
* Separate the CLI from the main Furnish library
* Documentation. Document all the things with a doc generator.

## Example CLI Goals
```
# Provision machine based on scripts in directory
furnish /path/to/directory

# Execute provisioning by calling script(s) directly 
furnish /path/to/file.js /path/to/file.coffee
```


## Example Furnish scripts
```
# coffee

module.exports = (machine) ->

  machine.furnish 'file'
    path: '/tmp/file'
    content: 'letest'
    
  furnish 'directory'
    path: '/letest'

```

## Configuration Schema
```
{ 
  "resources" : {
    # Resource specific defaults
  },
  "environments" : {
    "development" : {
      # Environment specific overrides
    }
  },
  "machines" : {
    "hello-machine.local" : {
      # Machine specific overrides
    }
  }
}
```

When furnish accesses keys from the config data store resources are loaded first, followed by environment and then machine configs. In others words, resource configs are trumped by environment configs. Environment configs are trumped by machine specific configs. Example:
```
{ 
  "resources" : {
    "node.js" : {
      "version" : "v4.2.2"
    },
    "myApp" : {
      "version" : "latest"
    }
  },
  "environments" : {
    "development" : {
      "myApp" : {
        "version" : "1.0.0"
      }
    }
  },
  "machines" : {
    "hello-machine.local" : {},
    "hello-machine-two.local" : {
      "myApp" : {
        "version" : "1.0.1"
      }
    }
  }
}
```
hello-machine's configs would look like this:
```
{ 
  "node.js" : {
    "version" : "v4.2.2"
  },
  "myApp" : {
    "version" : "1.0.0"
  }
}
```

hello-machine-two's configs would look like this:
```
{ 
  "node.js" : {
    "version" : "v4.2.2"
  },
  "myApp" : {
    "version" : "1.0.1"
  }
}
```

