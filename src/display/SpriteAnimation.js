define(function() {
	"use strict";
	
	function SpriteAnimation(sprite, name, frames, fps) {
		this.sprite = sprite;
		this.name = name;
		this.frames = frames;
		this.fps = fps;
	}
	
	return SpriteAnimation;
});