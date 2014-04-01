define(function() {
	"use strict";
	
	function InputManager(sources) {
		this.sources = sources;
	}
	
	InputManager.prototype.get = function(name) {
		return this.sources[name];
	}
	
	return InputManager;
});