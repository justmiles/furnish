#!/usr/bin/env node
var program = require('commander');
var os      = require('os');
var path    = require('path');
var pkg = require( path.resolve(__dirname, '..', 'package.json') )
var Furnish = require('..');

var furnish = new Furnish();

furnish.events.on('loaded', function() {
  return furnish.run();
});

program
  .version(pkg.version)
  .command('*')
  .description('Run furnish against the path or file')
  .action(function(loadPath){
    console.log('Furnishing %s with "%s"', os.hostname(), loadPath);
    var loadPath = path.resolve( process.cwd(), loadPath )
    furnish.load(loadPath)
  });

program.parse(process.argv);