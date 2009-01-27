Array.prototype.index = function(val) {
  for(var i = 0, l = this.length; i < l; i++) {
    if(this[i] == val) return i;
  }
  return null;
}

jQuery.extend({
	
	postJSON: function( url, data, callback) {
		if ( jQuery.isFunction( data ) ) {
			callback = data;
			data = {};
		}

		return jQuery.ajax({
			type: "POST",
			url: url,
			data: data,
			success: callback,
			dataType: "json",
			contentType: 'application/json'
		});
	}
	
});

jQuery.fn.extend({
  
  sort: function() { 
    return this.pushStack(jQuery.makeArray([].sort.apply(this, arguments))); 
  },

  sortById: function(order) { 
    return this.children().sort(function(a, b) {
      var idx_a = (order.index($(a).attr('id')) || 0)
      var idx_b = (order.index($(b).attr('id')) || 0) 
      if(idx_a == idx_b) return 0;
      return (idx_a > idx_b ? 1 : -1);
    }).appendTo(this).end();
  }
  
});