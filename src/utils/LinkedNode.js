define(function() {
    "use strict";
    
    function LinkedNode(opt) {
        opt = opt || {};
        this.obj = opt.obj || null;
        this.nextLinked = opt.next || null;
        this.prevLinked = opt.prev || null;
    }
    
    var p = LinkedNode.prototype;
    
    p.next = function() {
        return this.nextLinked;
    }
    
    p.object = function() {
        return this.obj;
    }
    
    p.prev = function() {
        return this.prevLinked;
    }
    
    return LinkedNode;
});