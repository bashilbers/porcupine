define([
	'porcupine/display/DisplayObjectContainer',
	'porcupine/geometry/Point'
], function(DisplayObjectContainer, Point) {
    "use strict";
    
	/**
	 * The SPrite object is the base for all textured objects that are rendered to the screen
	 *
	 * @class Sprite
	 * @extends DisplayObjectContainer
	 * @constructor
	 * @param texture {Texture} The texture for this sprite
	 * @type String
	 */
	var Sprite = DisplayObjectContainer.extend({
		init: function(texture) {
			this.texture = texture;
			if(texture.baseTexture.hasLoaded) {
                this.updateFrame = true;
            } else {
                this.onTextureUpdateBind = this.onTextureUpdate.bind(this);
                this.texture.addEventListener('update', this.onTextureUpdateBind);
            }
		},
	
		/**
         * The anchor sets the origin point of the texture.
         * The default is 0,0 this means the textures origin is the top left 
         * Setting than anchor to 0.5,0.5 means the textures origin is centered
         * Setting the anchor to 1,1 would mean the textures origin points will be the bottom right
         *
	     * @property anchor
	     * @type Point
	     */
        anchor: new Point(),

        /**
         * The texture that the sprite is using
         *
         * @property texture
         * @type Texture
         */
        texture: null,

        /**
         * The blend mode of sprite.
         * currently supports Sprite.blendModes.NORMAL and Sprite.blendModes.SCREEN
         *
         * @property blendMode
         * @type Number
         */
        blendMode: null, //Sprite.blendModes.NORMAL,

        /**
         * The width of the sprite (this is initially set by the texture)
         *
         * @property _width
         * @type Number
         * @private
         */
        _width: 0,

        /**
         * The height of the sprite (this is initially set by the texture)
         *
         * @property _height
         * @type Number
         * @private
         */
        _height: 0,

        renderable: true
	});
	
	var p = Sprite.prototype;
	
	/**
	 * The width of the sprite, setting this will actually modify the scale to acheive the value set
	 *
	 * @property width
	 * @type Number
	 */
	Object.defineProperty(p, 'width', {
	    get: function() {
	        return this.scale.x * this.texture.frame.width;
	    },
	    set: function(value) {
	            this.scale.x = value / this.texture.frame.width
	        this._width = value;
	    }
	});
	
	/**
	 * The height of the sprite, setting this will actually modify the scale to acheive the value set
	 *
	 * @property height
	 * @type Number
	 */
	Object.defineProperty(p, 'height', {
	    get: function() {
	        return  this.scale.y * this.texture.frame.height;
	    },
	    set: function(value) {
	            this.scale.y = value / this.texture.frame.height
	        this._height = value;
	    }
	});
	
	/**
	 * Sets the texture of the sprite
	 *
	 * @method setTexture
	 * @param texture {Texture} The PIXI texture that is displayed by the sprite
	 */
	p.setTexture = function(texture) {
        // stop current texture;
        if(this.texture.baseTexture != texture.baseTexture) {
			this.textureChange = true;        
			this.texture = texture;
                
			if(this.__renderGroup) {
				this.__renderGroup.updateTexture(this);
			}
        } else {
			this.texture = texture;
        }
        
        this.updateFrame = true;
	}
	
	/**
	 * When the texture is updated, this event will fire to update the scale and frame
	 *
	 * @method onTextureUpdate
	 * @param event
	 * @private
	 */
	p.onTextureUpdate = function(event) {   
        // so if _width is 0 then width was not set..
        if(this._width)this.scale.x = this._width / this.texture.frame.width;
        if(this._height)this.scale.y = this._height / this.texture.frame.height;
        
        this.updateFrame = true;
	}
	
	// some static helper functions..
	
	/**
	 * 
	 * Helper function that creates a sprite that will contain a texture from the TextureCache based on the frameId
	 * The frame ids are created when a Texture packer file has been loaded
	 *
	 * @method fromFrame
	 * @static
	 * @param frameId {String} The frame Id of the texture in the cache
	 * @return {Sprite} A new Sprite using a texture from the texture cache matching the frameId
	 */
	Sprite.fromFrame = function(frameId) {
		/*
        var texture = PIXI.TextureCache[frameId];
        if(!texture)throw new Error("The frameId '"+ frameId +"' does not exist in the texture cache" + this);
        return new Sprite(texture);
        */
	}
	
	/**
	 * 
	 * Helper function that creates a sprite that will contain a texture based on an image url
	 * If the image is not in the texture cache it will be loaded
	 *
	 * @method fromImage
	 * @static
	 * @param imageId {String} The image url of the texture
	 * @return {Sprite} A new Sprite using a texture from the texture cache matching the image id
	 */
	Sprite.fromImage = function(imageId) {
		/*
        var texture = PIXI.Texture.fromImage(imageId);
        return new Sprite(texture);
        */
	}
	
	// static properties
	Sprite.blendModes = {
		NORMAL: 0,
		SCREEN: 1
	};
	
	return Sprite;
});