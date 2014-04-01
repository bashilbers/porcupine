define(function() {
    "use strict";
    
    function GamepadManager() {
        // The canonical list of attached gamepads, without “holes” (always
        // starting at [0]) and unified between Firefox and Chrome
        this.gamepads = [];
    
        window.addEventListener('gamepadConnected', this.onGamepadConnect.bind(this), false);
		window.addEventListener('gamepadDisconnected', this.onGamepadDisconnect.bind(this), false);
    }
    
    var p = Gamepad.prototype;
    
    p.onGamepadConnect = function(event) {
        this.gamepads.push(event.gamepad);
    }
    
    p.onGamepadDisconnect = function(event) {
        // Remove the gamepad from the list of gamepads to monitor.
        for (var i in this.gamepads) {
            if (this.gamepads[i].index == event.gamepad.index) {
                this.gamepads.splice(i, 1);
                break;
            }
		}
    }

    
    return Gamepad;
});