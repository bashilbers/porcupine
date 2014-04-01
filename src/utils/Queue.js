define(function() {
    "use strict";

    /* private variables */
    var items  = [],
        offset = 0;

    /**
     *  Queue constructor.
     */
    function Queue() {}
    
    var p = Queue.prototype;

    /**
     * Gets current queue length.
     * 
     * @return {Number}
     */
    p.getLength = function () {
        return (items.length - offset);
    };

    /**
     * Gets current offset.
     *
     * @return {Number}
     */
    p.getOffset = function () {
        return offset;
    };

    /**
     * Is the queue empty?
     *
     * @return {Boolean}
     */
    p.isEmpty = function () {
        return items.length === 0;
    };

    /**
     * Enqueues a new item.
     *
     * @param   {Object}    item    The item to enqueue
     * @return  Queue
     */
    p.enqueue = function (item) {
        items.push(item);
        return this;
    };

    /**
     * Dequeues an item and returns it. If the queue is empty then undefined is
     * returned.
     * 
     * @return {undefined|Object}
     */
    p.dequeue = function () {
        // if the queue is empty, return undefined
        if (this.isEmpty()) {
            return undefined;
        }

        // store the item at the front of the queue
        var item = items[offset];

        // increment the offset and remove the free space if necessary
        if ((offset += 1) * 2 >= this.getLength()) {
            items  = items.slice(offset);
            offset = 0;
        }

        // return the dequeued item
        return item;
    };

    /* 
     * Returns the item at the front of the queue (without dequeuing it). If the
     * queue is empty then undefined is returned.
     *
     * @return  {undefined|Object}
     */
    p.peek = function () {
        return this.getLength() > 0 ? items[offset] : undefined;
    };

    // attach public interface to window
    return Queue;
});