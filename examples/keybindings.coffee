cp = require 'child_process'

arrayUnique = (array) ->
  a = array.concat()
  i = 0
  while i < a.length
    j = i + 1
    while j < a.length
      if a[i] == a[j]
        a.splice j--, 1
      ++j
    ++i
  a

namespace = 'org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings'

shortcuts =
  
  terminator: 
    name: "terminator"
    binding: "['F12']"
    command: "/home/justmiles/.bin/minMax.sh terminator"
    
  lock:
    name: "lock"
    binding: "['<Primary><Alt>l']"
    command: "lock"
    
customList = JSON.parse cp.execSync('gsettings get org.cinnamon.desktop.keybindings custom-list').toString().replace(/'/g,'"')
  
for key,properties of shortcuts
  cp.execSync "gsettings set #{namespace}/#{key}/ name \"#{properties.name}\""
  cp.execSync "gsettings set #{namespace}/#{key}/ binding \"#{properties.binding}\""
  cp.execSync "gsettings set #{namespace}/#{key}/ command \"#{properties.command}\""

keys = arrayUnique(customList.concat(Object.keys(shortcuts)))
cp.execSync "gsettings set org.cinnamon.desktop.keybindings custom-list '#{JSON.stringify keys}'"

module.exports = (furnish) ->

  # furnish.CinnamonShortcut 'terminator', {
  #   binding: ['F12']
  #   command: '/home/justmiles/.bin/minMax.sh terminator'
  # }
  # 
  
  # Lock screen functionality
  furnish.RemoteFile 'i3lock', {
    source: 'https://raw.githubusercontent.com/justmiles/i3lock/master/i3lock'
    destination: '/usr/bin/i3lock'
    mode: '0755'
    action: 'create'
  }
  
  furnish.File 'lock', {
    content: """#!/bin/bash
scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x7 /tmp/screenshotblur.png
i3lock -i /tmp/screenshotblur.png -l '#00ffff' -e
"""
    file: '/usr/bin/lock'
    action: 'create'
  }
  
  # furnish.CinnamonShortcut 'lock', {
  #   binding: ['<Primary><Alt>l']
  #   command: 'lock'
  # }
