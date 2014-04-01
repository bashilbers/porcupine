define(function() {
	"use strict";
	
	function Pointer(container = document.body) {
		this.isLocked = false;
	
		/**
		 * The time that must pass between a down (touchstart/mousedown) and up (touchend/mouseup)
         * event for it to be considered a "click" event, in milliseconds
		 */
		this.clickDelay = 300;
		
		/**
		 * The max time that can pass between two click events for it to be considered a
         * "doubleclick" event, in milliseconds
		 */
		this.doubleClickDelay = 300;
		
		/**
		 * The time that must pass after a down event for it to be considered a "hold" event, in milliseconds
		 */
		this.holdDelay = 2000;
		
		/**
		 * Timer in ms value for pointer up event
		 */
		this.timeUp = 0;
		
		/**
		 * Timer in ms value for hold
		 */
		this.timeHold = 0;
		
		/**
		 * Have we emitted the hold event already?
		 */
		this.holdSent = false;
		
		/**
		 * Last known click time
		 */
		this.previousClickTime = 0;

		/**
		 * The containing domElement
		 */
		this.container = container;
		
		/**
		 * Last known pointer event
		 */
		this.event = null;
		
		this.container.addEventListener('pointerdown', this.onPointerEvent.bind(this, 'onPointerDown'), false);
		this.container.addEventListener('pointerup', this.onPointerEvent.bind(this, 'onPointerUp'), false);
		this.container.addEventListener('pointermove', this.onPointerEvent.bind(this, 'onPointerMove'), false);
		this.container.addEventListener('pointerout', this.onPointerEvent.bind(this, 'onPointerOut'), false);
		this.container.addEventListener('pointercancel', this.onPointerEvent.bind(this, 'onPointerCancel'), false);
		this.container.addEventListener('pointerenter', this.onPointerEvent.bind(this, 'onPointerEnter'), false);
		this.container.addEventListener('pointerleave', this.onPointerEvent.bind(this, 'onPointerLeave'), false);
		this.container.addEventListener('pointerlockchange', this.onPointerEvent.bind(this, 'onPointerLockChange'), false);
		this.container.addEventListener('pointerlockerror', this.onPointerEvent.bind(this, 'onPointerLockError'), false);
	}
	
	var p = Pointer.prototype;
	
	p.onPointerEvent = function(handlerName, event) {
		this.event = event;
		this[handlerName](event);
	}
	
	p.move = function(x, y) {
		this.position.x = x;
		this.position.y = y;
		return this;
	}
	
	p.onPointerDown = function(event) {
		//this.timeDown = this.timer.now();
		this.timeHold = 0;
		this.holdSent = false;
		this.move(event.pageX, event.Y);
	}
	
	p.onPointerUp = function(event) {
		//this.timeUp = this.timer.now();
		var emit;
		
		if(this.timeHold >= 0 && this.timeHold <= this.clickDelay) {
            //is this a double click?
            if((this.timeUp - this.previousClickTime) <= this.doubleClickDelay) {
                emit = Pointer.Event.DOUBLECLICK;
            }
            //only a single click
            else {
                emit = Pointer.Event.CLICK;
            }

            this.previousClickTime = this.timeUp;
        }
        
        if (!!emit) {
            // emit event
        }
	}
	
	p.onPointerMove = function(event) {
		this.move(event.pageX, event.pageY);
	}
	
	p.onPointerOut = function(event) {
		alert('what now?');
	}
	
	p.onPointerCancel = function(event) {
		alert('what now?');
	}
	
	p.onPointerEnter = function(event) {
		this.move(event.pageX, event.pageY);
	}
	
	p.onPointerLeave = function(event) {
		this.move(event.pageX, event.pageY);
	}
	
	p.onPointerLockChange = function(event) {
		var element = document.pointerLockElement || document.mozPointerLockElement || document.webkitPointerLockElement || null;
		this.isLocked = !!element;
	}
	
	p.onPointerLockError = function(event) {
		alert('what now?');
	}
	
	p.is = function(type) {
		return this.type === type;
	}
	
	Object.defineProperty(p, 'timeHold', {
		get: function() {
			if (this.timeUp === 0) {
				return 0;
			}
			return this.timeUp - this.timeDown;
		}
	});
	
	Object.defineProperty(p, 'type', {
		get: function() {
			return this.event.pointerType;
		}
	});
	
	Pointer.Event = {
		CLICK: 'click',
		DOUBLECLICK: 'doubleclick'
	}
	
	Pointer.Type = {
		TOUCH: 'touch',
		PEN: 'pen',
		MOUSE: 'mouse'
	}
	
	return Pointer;
});