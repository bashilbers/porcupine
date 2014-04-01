define(function() {
	'use strict';
	
	function CanvasRenderer(width, height, view, transparant) {
		this.transparant = transparant;
		
		this.view = view || document.createElement('canvas');
		
		this.context = this.view.getContext('2d');
		
		this.refresh = true;
		
		// set viewport
		this.view.width = this.width = width || 800;
		this.view.height = this.height = height || 600;
	}
	
	var p = CanvasRenderer.prototype;
	
	p.render = function(graphic) {
		this.context.setTransform(1, 0, 0, 1, 0, 0);
		this.context.clearRect(0, 0, this.width, this.height);
		this.renderDisplayObject(graphic.displayObject);
		return this;
	}
	
	p.renderDisplayObject = function(displayObject) {
		console.dir(displayObject);
	
		do {
			var transform = displayObject.transform;
	
			if (displayObject.visible === false || displayObject.renderAble === false) {
				continue;
			}
			
			if (displayObject instanceof Sprite) {
				var frame = displayObject.texture.frame;
			
				if (!!displayObject.alpha) {
		            this.context.globalAlpha = displayObject.alpha;
		        }
		        
		        if (!!displayObject.transform) {
			        this.context.setTransform(
			            transform.scale.horizontal,
			            transform.skew.horizontal,
			            transform.skew.vertical,
			            transform.scale.vertical,
			            transform.move.horizontal,
			            transform.move.vertical
			        );
			    }

		        this.context.drawImage(
		            displayObject.texture.baseTexture.source,
		            frame.x,
		            frame.y,
		            frame.width,
		            frame.height,
		            display.coord.x * -frame.width,
		            display.coord.y * -frame.height,
		            frame.width,
		            frame.height
		        );
			} else if (displayObject instanceof Strip) {
				alert('Strip');
			} else if (displayObject instanceof TilingSprite) {
				alert('Tilingsprite');
			} else if (displayObject instanceof CustomRenderable) {
				alert('customRenderable');
			} else if (displayObject instanceof Graphics) {
				alert('Graphics');
			} else if (displayOBject instanceof FilterBlock) {
				alert('FilterBlock');
			}
			
		} while (displayObject = displayObject.getNext() && !!displayObject);
	}
	
	p.resize = function(width, height) {
		this.width  = this.view.width = width;
		this.height = this.view.height = height;
		return this;
	}
	
	p.recolorFrame = function(displayObject, recolorMap) {
		var imageData = this.context.getImageData(display.coord.x, display.coord.y, display.frame.width, display.frame.height);
		
		recolorings.strategy = recolorings.strategy || 'unanimous';
		
		if (recolorings instanceof Array) {
			for (var r = 0; r < recolorings.length; r += 1) {
				this.recolorFrame(display, recolorings[r]);
				return this;
			}
		}
		
		for (var i = 0; i < imageData.data.length; i += 4) {
			var recolorIt = false;
			
			switch (recolorings.strategy) {
				case 'affirmative':
					recolorIt =
						(imageData.data[i] === recolorings.from.red) ||
						(imageData.data[i+1] === recolorings.from.green) ||
						(imageData.data[i+2] === recolorings.from.blue);
					break;
					
				case 'unanimous':
					recolorIt = 
						(imageData.data[i] === recolorings.from.red) &&
						(imageData.data[i+1] === recolorings.from.green) &&
						(imageData.data[i+2] === recolorings.from.blue);
					break;
			}			
			
			if (!!recolorIt) {
				if (!!recolorings.to.green) {
					imageData.data[i] = recolorings.to.red;
				}
				
				if (!!recolorings.to.green) {
					imageData.data[i+1] = recolorings.to.green;
				}
					
				if (!!recolorings.to.blue) {
					imageData.data[i+2] = recolorings.to.blue;
				}
				
				if (!!recolorings.to.alpha) {
					imageData.data[i+3] = recolorings.to.alpha;
				}
			}
	    }
	    
	    this.context.putImageData(imageData, display.coord.x, display.coord.y);
		
		return this;
	}
	
	return CanvasRenderer;
});