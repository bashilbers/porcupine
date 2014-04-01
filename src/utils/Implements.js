define(function() {
	"use strict";

    return function(object, constructor) {
        if(object instanceof constructor) {
            return true;
        }
        
        var k, b = true,
            po = object.constructor.prototype,
            pc = constructor.prototype;
            
        for(prop in pc) {
            b = b && prop in po;
        }
        
        return !!k && b;
    }
});