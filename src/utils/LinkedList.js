define(['./LinkedNode'], function(LinkedNode) {
	"use strict";
	
	var _nodes = [];
    
    function LinkedList() {
        this.first = null;
        this.last = null;
        this.count = 0;
    }
    
    var p = LinkedList.prototype;
    
    p.add = function(obj) {
        var node = new LinkedNode({
            obj: obj
        });
        
        _nodes.push(node);
        
        if (this.first == null) {
            this.first = node;
            this.last = node;   
        } else {
            this.last.nextLinked = node; // current end of the list points to the new end
            node.prevLinked = this.last; // new node's previous points to the previous last
            this.last = node; // new node is last in list
        }
        
        this.count++;
        
        return node;
    }
    
    return LinkedList;
});