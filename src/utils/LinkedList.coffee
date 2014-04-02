define ['./LinkedNode'], (LinkedNode) ->
  _nodes = []

  class LinkedList
    first: null
    last: null
    count: 0

    add: (obj) ->
      node = new LinkedNode obj: obj
      _nodes.push node

      if not @first?
        @first = node
        @last = node
      else
        # current end of the list points to the new end
        @last.nextLinked = node
        # new node's previous points to the previous last
        node.prevLinked = @last
        # new node is last in list
        @last = node

      @count++