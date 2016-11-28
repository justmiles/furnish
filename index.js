global.rootRequire = function(name) {
    return require(__dirname + '/' + name);
}
module.exports = require('./src/Furnish');
