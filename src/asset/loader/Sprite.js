define(['./Image', '../display/Sprite'], function(ImageLoader, SpriteDisplay) {
    "use strict";
    
    function Sprite(loader) {
        this.imageLoader = loader ? loader : new ImageLoader();
    }
    
    Sprite.prototype.load = function(asset, onLoad, onError) {
        var url  = typeof asset === 'object' ? asset.url : asset,
            self = this;
        
        require(['json!' + url], function(data) {
            self.imageLoader.load(data.src, function(image) {
                var displayData = new SpriteDisplay(image);
	            displayData.width = data.width;
	            displayData.height = data.height;
	            displayData.frameHeight = data.frameHeight;
	            displayData.frameWidth = data.frameWidth;
	            displayData.frames = data.frames;

                onLoad(displayData);
            });
        });
        
        return this;
    }
    
    return Sprite;
});