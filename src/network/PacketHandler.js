define(function() {
	"use strict";
	
	function PacketHandler() {
		
	}
	
	var p = PacketHandler.prototype;
	
	p.sendPacket = function(packet) {
		this.netHandler.writeConnection(packet);
		return this;
	}
	
	return PacketHandler;
});