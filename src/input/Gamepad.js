define(function() {
	"use strict";
	
	function Gamepad(params = {}) {
		this.id = params.id;
		//this.isConnected = params.isConnected || false;
		this.deadZone = params.deadZone || 0.03;
		this.maximizeThreshold = param.maximizeThreshold || 0.97;
	};
	
	var p = Gamepad.prototype;
	
	p.onDisconnect = function(event) {
		
	}
	
	/**
	 * List of events that an gamepad controller instance can dispatch.
	 *
     * CONNECTED, DISCONNECTED and UNSUPPORTED events include the gamepad in
     * question and tick provides the list of all connected gamepads.
     *
     * BUTTON_DOWN and BUTTON_UP events provide an alternative to polling button states at each tick.
     *
     * AXIS_CHANGED is called if a value of some specific axis changes.
	 */
	Gamepad.Event = {
		/**
		 * Triggered when a new controller connects.
         *
         * @event connected
         * @param {Object} device
         */
         CONNECTED: 'connected',

		/**
         * Triggered when a controller disconnects.
		 *
		 * @event disconnected
		 * @param {Object} device
		 */
		DISCONNECTED: 'disconnected',

		/**
		 * Called regularly with the latest controllers info.
		 *
		 * @event tick
		 * @param {Array} gamepads
		 */
		TICK: 'tick',

		/**
		 * Called when a gamepad button is pressed down.
		 *
		 * @event button-down
		 * @param {Object} event
		 * @param {Object} event.gamepad The gamepad object
		 * @param {String} event.control Control name
		 */
		BUTTON_DOWN: 'button-down',

		/**
		 * Called when a gamepad button is released.
		 *
		 * @event button-up
		 * @param {Object} event
		 * @param {Object} event.gamepad The gamepad object
		 * @param {String} event.control Control name
		 */
		BUTTON_UP: 'button-up',

		/**
		 * Called when gamepad axis value changed.
		 *
		 * @event axis-changed
		 * @param {Object} event
		 * @param {Object} event.gamepad The gamepad object
		 * @param {String} event.axis Axis name
		 * @param {Number} event.value New axis value
		 */
		AXIS_CHANGED: 'axis-changed'
	}
	
    Gamepad.buttons = {
        // main buttons
        FACE_1: 'FACE_1',
        FACE_2: 'FACE_2',
        FACE_3: 'FACE_3',
        FACE_4: 'FACE_4',
        
        // shoulder buttons
        LEFT_SHOULDER: 'LEFT_SHOULDER',
        RIGHT_SHOULDER: 'RIGHT_SHOULDER',
        LEFT_SHOULDER_BOTTOM: 'LEFT_SHOULDER_BOTTOM',
        RIGHT_SHOULDER_BOTTOM: 'RIGHT_SHOULDER_BOTTOM',
        
        // special buttons
        SELECT: 'SELECT',
        START: 'START',
        HOME: 'HOME',
        
        // analogue sticks
        LEFT_ANALOGUE_STICK: 'LEFT_ANALOGUE_STICK',
        RIGHT_ANALOGUE_STICK: 'RIGHT_ANALOGUE_STICK',
        
        // directional pad
        PAD_TOP: 'PAD_TOP',
        PAD_BOTTOM: 'PAD_BOTTOM',
        PAD_LEFT: 'PAD_LEFT',
        PAD_RIGHT: 'PAD_RIGHT'
    };
    
    Gamepad.Axe = {
        LEFT_ANALOGUE_HOR: 0,
        LEFT_ANALOGUE_VERT: 1,
        RIGHT_ANALOGUE_HOR: 2,
        RIGHT_ANALOGUE_VERT: 3
    };
	
	Gamepad.Type = {
		PLAYSTATION: 'playstation',
		LOGITECH: 'logitech',
		XBOX: 'xbox',
		UNKNOWN: undefined
	};
	
	Gamepad.Mappings = {
		undefined: {
			buttons: {
				Gamepad.Button.FACE_1: 0,
		        Gamepad.Button.FACE_2: 1,
		        Gamepad.Button.FACE_3: 2,
		        Gamepad.Button.FACE_4: 3,
		        
		        Gamepad.Button.LEFT_SHOULDER: 4, 
		        Gamepad.Button.RIGHT_SHOULDER: 5,
		        
		        Gamepad.Button.LEFT_SHOULDER_BOTTOM: 6, 
		        Gamepad.Button.RIGHT_SHOULDER_BOTTOM: 7,
		        
		        Gamepad.Button.SELECT: 8, 
		        Gamepad.Button.START: 9,
		        Gamepad.Button.HOME: 16,
		        
		        Gamepad.Button.LEFT_ANALOGUE_STICK: 10, 
		        Gamepad.Button.RIGHT_ANALOGUE_STICK: 11,
		        
		        Gamepad.Button.PAD_TOP: 12, 
		        Gamepad.Button.PAD_BOTTOM: 13,
		        Gamepad.Button.PAD_LEFT: 14,
		        Gamepad.Button.PAD_RIGHT: 15
		    },
		    axes: {
		        Gamepad.Axe.LEFT_ANALOGUE_HOR: 0,
		        Gamepad.Axe.LEFT_ANALOGUE_VERT: 1,
		        Gamepad.Axe.RIGHT_ANALOGUE_HOR: 2,
		        Gamepad.Axe.RIGHT_ANALOGUE_VERT: 3
		    }
		},
		Gamepad.Type.PLAYSTATION: {
			buttons: {
				Gamepad.Button.FACE_1: 14,
		        Gamepad.Button.FACE_2: 13,
		        Gamepad.Button.FACE_3: 15,
		        Gamepad.Button.FACE_4: 12,
		        
		        Gamepad.Button.LEFT_SHOULDER: 10, 
		        Gamepad.Button.RIGHT_SHOULDER: 11,
		        
		        Gamepad.Button.LEFT_SHOULDER_BOTTOM: 8, 
		        Gamepad.Button.RIGHT_SHOULDER_BOTTOM: 9,
		        
		        Gamepad.Button.SELECT: 0, 
		        Gamepad.Button.START: 3,
		        Gamepad.Button.HOME: 16,
		        
		        Gamepad.Button.LEFT_ANALOGUE_STICK: 1, 
		        Gamepad.Button.RIGHT_ANALOGUE_STICK: 2,
		        
		        Gamepad.Button.PAD_TOP: 4, 
		        Gamepad.Button.PAD_BOTTOM: 6,
		        Gamepad.Button.PAD_LEFT: 7,
		        Gamepad.Button.PAD_RIGHT: 5
			},
			axes: {
				Gamepad.Axe.LEFT_ANALOGUE_HOR: 0,
		        Gamepad.Axe.LEFT_ANALOGUE_VERT: 1,
		        Gamepad.Axe.RIGHT_ANALOGUE_HOR: 2,
		        Gamepad.Axe.RIGHT_ANALOGUE_VERT: 3
			}
		},
		Gamepad.Type.LOGITECH: {
			buttons: {},
			axes: {}
		},
		Gamepad.Type.XBOX: {
			buttons: {},
			axes: {}
		}
	}
	
	return Gamepad;
});