# furnish
Furnish your machines with real-time configuration management.

# Examples
```
npm install -g furnish
cd examples
furnish run node.js.coffee
```
# Goals
* Furnish CLI is easy to use. Pass it a directory, node.js script, or git repo to provision the plan
* Package Node.js in the CLI
* Wrap the methods for retreiving configuration in an adapter.
* Adapter should support triggering events 
* Provide the tool as both a CLI and a library for other node.js projects

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