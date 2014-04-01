define(function() {
	"use strict";
	
	var FilterBlock = function(mask) {
        this.graphics = mask
        this.visible = true;
        this.renderable = true;
	}
	
	return FilterBlock;
});