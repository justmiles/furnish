'use strict'

buildDir = 'build'

module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    
    copy: 
      package: 
        src: 'package.json',
        dest: "#{buildDir}/package.json"
      index: 
        src: 'index.js',
        dest: "#{buildDir}/index.js"

    coffee:
      main:
        files:
          "#{buildDir}/src/Furnish.js": 'src/Furnish.coffee'
          "#{buildDir}/bin/furnish-cli.js": 'bin/furnish-cli.coffee'
        options:
          bare: true
      
      lib:
        expand: true
        flatten: true
        src: ['src/core/*.coffee']
        dest: "#{buildDir}/src/core"
        ext: '.js'
      
      core:
        expand: true
        flatten: true
        src: ['src/lib/*.coffee']
        dest: "#{buildDir}/src/lib"
        ext: '.js'

    nexe:
      input: "#{buildDir}/bin/furnish-cli.js"
      output: "#{buildDir}/furnish"
      framework: 'node'
      version: '4.2.2'
      'js-flags': '--use_strict'
      ignoreFlags: true
      flags: true
      
    # Load the plugin that provides the "coffee" task.
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    
    # Load the plugin that provides the "nexe" task.
    grunt.loadNpmTasks 'grunt-nexe'  
    
    # Load the plugin that provides the "copy" task.
    grunt.loadNpmTasks 'grunt-contrib-copy'
    
  # Register "build" task
  grunt.registerTask 'build', ['coffee', 'copy', 'nexe']
  
  # Register "prebuild" task
  grunt.registerTask 'prebuild', ['coffee', 'copy']

