define(function() {
    'use strict';

    /* private variables */
    
    /**
     * Hash of event names and arrays of handler functions. Each handler
     * is called whenever that event is emitted.
     *
     * Example:
     * 'ui.channel.toggle': [
     *   function,
     *   function
     * ]
     *
     * @type {Object}
     */
    var events = {};

    function EventEmitter() {
    
    }
    
    /**
     * Triggers an event and sends it to all listeners of that event
     * If data is not an array, it will be wrapped in an array.
     *
     * @param  {String} eventName
     * @param  {Array}  data
	 * @param  {Object} context Will be available as `this` in callback
	 * @return {EventEmitter}
     */
	EventEmitter.prototype.emit = function(event, context, data) {
		var listeners = events[event],
			context   = context || {},
			i;

		// cast data to array if needed
		data = (data instanceof Array) ? data : [data];

		// no listeners found for this event, do not bother
		if (!listeners) {
			return false;
		}

        // send message to each listener
		for (i = 0; i < listeners.length; i += 1) {
			listeners[i].callback.apply(context, data);
		}
		
		// allow method chaining
		return this;
	}

	/**
     * Add a single listener callback for given event or add a hash for multiple events.
     *
     * Example using hash: {
     *   'ui.channel.toggle': function,
     *   'ui.channel.close': function
     * }, 10
     *
     * Example using single: 'ui.channel.toggle', function, 10
     *
     * @param   {String}|{Object}   event
     * @param   {Function}          callback
     * @param   {Number}            priority
     * @return  {EventEmitter}
     */
	EventEmitter.prototype.on = function(event, callback, priority) {
		if (typeof event === 'object') {
			event.every(function(name, cb) {
				this.on(name, cb, callback); // callback is priority here... I know -_-
			});
			return this;
		}

		var listeners = events[event];

		// create a new entry for this event if we don't know it yet
		if (!listeners) {
			listeners = events[event] = [];
		}

		priority = parseInt(priority || 0, 10);
		listeners.push({ callback: callback, priority: priority });

		// re-sort subscribers so highest priority is first
		listeners = listeners.sort(function (a, b) {
			return b.priority - a.priority;
		});
            
		// allow method chaining
		return this;
	}

	/**
	 * Removes listener from given event
     *
     * @param   {String}   event
     * @param   {Function} listener
     * @return  {EventEmitter}
     */
	EventEmitter.prototype.removeListener = function (event, listener) {
		var listeners = events[event],
			index;

		// NOOP
		if (!listeners) {
			return;
		}

		index = listeners.indexOf(listener);

		// not found among existing listeners, don't even worry about removing
		if (index === -1) {
			return;
		}

		// remove from listeners
		listeners.splice(index, 1);

		// allow chaining
		return this;
    }
    
    return EventEmitter;
});