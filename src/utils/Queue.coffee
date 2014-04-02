define ->
  # private variables
  items  = []
  offset = 0

  ###*
   *  Queue constructor.
  ###
  class Queue
    
    ###*
     * Gets current queue length.
     *
     * @return {Number}
    ###
    getLength: ->
      items.length - offset

    ###*
     * Gets current offset.
     *
     * @return {Number}
    ###
    getOffset: ->
      offset

    ###*
     * Is the queue empty?
     *
     * @return {Boolean}
    ###
    isEmpty: ->
      items.length is 0
    
    ###*
     * Enqueues a new item.
     *
     * @param   {Object}    item    The item to enqueue
     * @return  Queue
    ###
    enqueue: (item) ->
      items.push item
    
    ###*
     * Dequeues an item and returns it. If the queue is empty then undefined is
     * returned.
     *
     * @return {undefined|Object}
    ###
    dequeue: ->
      # if the queue is empty, return undefined
      return undefined if @isEmpty()

      # store the item at the front of the queue
      item = items[offset]

      # increment the offset and remove the free space if necessary
      if (offset += 1) * 2 >= @getLength()
        items  = items.slice offset
        offset = 0

      item

    ###*
     * Returns the item at the front of the queue (without dequeuing it). If the
     * queue is empty then undefined is returned.
     *
     * @return  {undefined|Object}
    ###
    peek: ->
      items[offset] if @getLength() > 0 else undefined