define(function() {
    "use strict";
    
    var map = {};
    
    function Dictionary() {}

    Dictionary.prototype.getAll = function() {
        return map;
    }
    
    Dictionary.prototype.get = function(key) {
        if (key === undefined || key === null) {
            return map;
        }
    
        var value = map[key];
        
        if (value == undefined) {
            return null;
        }
        
        return value;
    }

    Dictionary.prototype.set = function(key, value) {
        map[key] = value;
        return this;
    }

    Dictionary.prototype.remove = function(key) {
        delete map[key];
        return this;
    }

    Dictionary.prototype.has = function(key) {
        return Boolean(map[key] != undefined);
    }

    Dictionary.prototype.clear = function() {
        map = {};
        return this;
    }

    Dictionary.prototype.keys = function() {
        return Object.keys(this.map);
    }
    
    Dictionary.prototype.each = function(callback) {
        for (var key in map) {
            callback(key, map);
        }
        return this;
    }

    return Dictionary;
});