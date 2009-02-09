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
	},
	
	currentUrl: function() {
	  return (window.location.protocol + "//" + window.location.host + window.location.pathname).replace(/\/$/, '');
	}
	
});

jQuery.fn.extend({
  
  reverse: function() {
  	return this.pushStack(this.get().reverse(), arguments);
  },
  
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
  },
  
  markdown: function() {
    var converter = new Showdown.converter();
    return this.each(function() {
      $(this).html('<div class="lpl_markdown">' + converter.makeHtml($(this).text()) + '</div>');
    });
  },
  
  unselectable: function() {
    return this.each(function() {
      $(this).attr('unselectable', 'on').css({ MozUserSelect: 'none', KhtmlUserSelect: 'none' });
    });
  },
  
  flashClass: function(className, duration) {
    return this.each(function() {
      var ref = $(this);
      ref.addClass(className);
      setTimeout(function() { ref.removeClass(className); }, duration || 500);
    });
  },
  
  urlify: function() {
    this.filter(':text').each(function() {
      $(this).keyup(function(e) {
        var value = $(this).val();
        if(value.charAt(value.length - 1) != '-') { $(this).val(urlify($(this).val())); }
      });
    });
    return this;
  },
  
  iframed: function(stylesheet) {
  	var documentTemplate = '\
  		<html>\
  			<head>\
  				INSERT:STYLESHEET:END\
  			</head>\
  			<body id="iframeBody" class="content">\
  				INSERT:CONTENT:END\
  			</body>\
  		</html>\
  	';
  	
  	return this.each(function() {
      var container = document.createElement("div");
      var iframe = document.createElement("iframe");
      $(container).attr('class', $(this).attr('class')).addClass('iframed').append(iframe);
      $(this).replaceWith(container);
      
  	  /* Insert dynamic variables/content into document */
    	/* IE needs stylesheet to be written inline */
    	var templateContent = ($.browser.msie) ? 
    		documentTemplate.replace(/INSERT:STYLESHEET:END/, '<link rel="stylesheet" type="text/css" href="' + stylesheet + '"></link>') :
    		documentTemplate.replace(/INSERT:STYLESHEET:END/, "");

    	templateContent = templateContent.replace(/INSERT:CONTENT:END/, $(this).html());
    	iframe.contentWindow.document.open();
    	iframe.contentWindow.document.write(templateContent);
    	iframe.contentWindow.document.close();

    	if (!$.browser.msie) { // possible deprecation issue - see jQuery 1.3
    		$(iframe.contentWindow.document).find('head').append(
    			$(iframe.contentWindow.document.createElement("link")).attr({
    				"rel" : "stylesheet",
    				"type" : "text/css",
    				"href" : stylesheet
    			})
    		);
    	}
    });
  }
  
});

jQuery(function($) {
  
  // Transliterate international characters and create a URL-compatible slug.
  // originally for Drupal - by Nesta Campbell <nesta.campbell@gmail.com>
  // licenced under GPL
    
  var LATIN_MAP = {
    'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A', 'Æ': 'AE', 'Ç':
    'C', 'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E', 'Ì': 'I', 'Í': 'I', 'Î': 'I',
    'Ï': 'I', 'Ð': 'D', 'Ñ': 'N', 'Ò': 'O', 'Ó': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö':
    'O', 'Ő': 'O', 'Ø': 'O', 'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U', 'Ű': 'U',
    'Ý': 'Y', 'Þ': 'TH', 'ß': 'ss', 'à':'a', 'á':'a', 'â': 'a', 'ã': 'a', 'ä':
    'a', 'å': 'a', 'æ': 'ae', 'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ð': 'o', 'ñ': 'n', 'ò': 'o', 'ó':
    'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ő': 'o', 'ø': 'o', 'ù': 'u', 'ú': 'u',
    'û': 'u', 'ü': 'u', 'ű': 'u', 'ý': 'y', 'þ': 'th', 'ÿ': 'y'
  };

  var LATIN_SYMBOLS_MAP = {
    '©':'(c)', '€':'eur'
  };

  // var GREEK_MAP = {
  //   'α':'a', 'β':'b', 'γ':'g', 'δ':'d', 'ε':'e', 'ζ':'z', 'η':'h', 'θ':'8',
  //   'ι':'i', 'κ':'k', 'λ':'l', 'μ':'m', 'ν':'n', 'ξ':'3', 'ο':'o', 'π':'p',
  //   'ρ':'r', 'σ':'s', 'τ':'t', 'υ':'y', 'φ':'f', 'χ':'x', 'ψ':'ps', 'ω':'w',
  //   'ά':'a', 'έ':'e', 'ί':'i', 'ό':'o', 'ύ':'y', 'ή':'h', 'ώ':'w', 'ς':'s',
  //   'ϊ':'i', 'ΰ':'y', 'ϋ':'y', 'ΐ':'i',
  //   'Α':'A', 'Β':'B', 'Γ':'G', 'Δ':'D', 'Ε':'E', 'Ζ':'Z', 'Η':'H', 'Θ':'8',
  //   'Ι':'I', 'Κ':'K', 'Λ':'L', 'Μ':'M', 'Ν':'N', 'Ξ':'3', 'Ο':'O', 'Π':'P',
  //   'Ρ':'R', 'Σ':'S', 'Τ':'T', 'Υ':'Y', 'Φ':'F', 'Χ':'X', 'Ψ':'PS', 'Ω':'W',
  //   'Ά':'A', 'Έ':'E', 'Ί':'I', 'Ό':'O', 'Ύ':'Y', 'Ή':'H', 'Ώ':'W', 'Ϊ':'I',
  //   'Ϋ':'Y'
  // };

  // var TURKISH_MAP = {
  //   'ş':'s', 'Ş':'S', 'ı':'i', 'İ':'I', 'ç':'c', 'Ç':'C', 'ü':'u', 'Ü':'U',
  //   'ö':'o', 'Ö':'O', 'ğ':'g', 'Ğ':'G'
  // };

  // var RUSSIAN_MAP = {
  //   'а':'a', 'б':'b', 'в':'v', 'г':'g', 'д':'d', 'е':'e', 'ё':'yo', 'ж':'zh',
  //   'з':'z', 'и':'i', 'й':'j', 'к':'k', 'л':'l', 'м':'m', 'н':'n', 'о':'o',
  //   'п':'p', 'р':'r', 'с':'s', 'т':'t', 'у':'u', 'ф':'f', 'х':'h', 'ц':'c',
  //   'ч':'ch', 'ш':'sh', 'щ':'sh', 'ъ':'', 'ы':'y', 'ь':'', 'э':'e', 'ю':'yu',
  //   'я':'ya',
  //   'А':'A', 'Б':'B', 'В':'V', 'Г':'G', 'Д':'D', 'Е':'E', 'Ё':'Yo', 'Ж':'Zh',
  //   'З':'Z', 'И':'I', 'Й':'J', 'К':'K', 'Л':'L', 'М':'M', 'Н':'N', 'О':'O',
  //   'П':'P', 'Р':'R', 'С':'S', 'Т':'T', 'У':'U', 'Ф':'F', 'Х':'H', 'Ц':'C',
  //   'Ч':'Ch', 'Ш':'Sh', 'Щ':'Sh', 'Ъ':'', 'Ы':'Y', 'Ь':'', 'Э':'E', 'Ю':'Yu',
  //   'Я':'Ya'
  // };

  // var UKRAINIAN_MAP = {
  //   'Є':'Ye', 'І':'I', 'Ї':'Yi', 'Ґ':'G', 'є':'ye', 'і':'i', 'ї':'yi', 'ґ':'g'
  // };

  // var CZECH_MAP = {
  //   'č':'c', 'ď':'d', 'ě':'e', 'ň': 'n', 'ř':'r', 'š':'s', 'ť':'t', 'ů':'u',
  //   'ž':'z'
  // };
  
  // var POLISH_MAP = {
  //   'ą':'a', 'ć':'c', 'ę':'e', 'ł':'l', 'ń':'n', 'ó':'o', 'ś':'s', 'ź':'z',
  //   'ż':'z', 'Ą':'A', 'Ć':'C', 'Ę':'e', 'Ł':'L', 'Ń':'N', 'Ó':'o', 'Ś':'S',
  //   'Ź':'Z', 'Ż':'Z'
  // };

  var ALL_DOWNCODE_MAPS = new Array();
  ALL_DOWNCODE_MAPS[0] = LATIN_MAP;
  ALL_DOWNCODE_MAPS[1] = LATIN_SYMBOLS_MAP;
  // ALL_DOWNCODE_MAPS[2] = GREEK_MAP;
  // ALL_DOWNCODE_MAPS[3] = TURKISH_MAP;
  // ALL_DOWNCODE_MAPS[4] = RUSSIAN_MAP;
  // ALL_DOWNCODE_MAPS[5] = UKRAINIAN_MAP;
  // ALL_DOWNCODE_MAPS[6] = CZECH_MAP;
  // ALL_DOWNCODE_MAPS[7] = POLISH_MAP;

  var Transliterator = new Object();
  
  Transliterator.Initialize = function() {
    if (Transliterator.map) { return; } // already made
    
    Transliterator.map = {};
    Transliterator.chars = '';
    
    for(var i in ALL_DOWNCODE_MAPS) {
      var lookup = ALL_DOWNCODE_MAPS[i];
      for (var c in lookup) {
        Transliterator.map[c] = lookup[c];
        Transliterator.chars += c;
      }
    }        
    Transliterator.regex = new RegExp('[' + Transliterator.chars + ']|[^' + Transliterator.chars + ']+','g');
  };
  
  Transliterator.translit = function(slug) {
    Transliterator.Initialize();
    var translitd = '';
    var pieces = slug.match(Transliterator.regex);
    if (pieces) {
      for (var i = 0 ; i < pieces.length ; i++) {
        if (pieces[i].length == 1) {
          var mapped = Transliterator.map[pieces[i]] ;
          if (mapped != null) {
            translitd += mapped;
            continue;
          }
        }
        translitd += pieces[i];
      }
    } else {
      translitd = slug;
    }
    return translitd;
  };
  
  Transliterator.removelist = [/*** array of words to strip ***/];
  
  urlify = function(s, num_chars) {
    s = Transliterator.translit(s);
    r = new RegExp('\\b(' + Transliterator.removelist.join('|') + ')\\b', 'gi');
    s = s.replace(r, '');                       // remove unwanted words
    s = s.replace(/[^-\w\s]/g, '');             // remove unneeded chars
    s = s.replace(/^\s+|\s+$/g, '');            // trim leading/trailing spaces
    s = s.replace(/[-_\s]+/g, '-');             // convert spaces to hyphens
    s = s.replace(/^(\d|-)+|(-)+$/g, '');       // trim leading/trailing hyphens and numbers
    s = s.toLowerCase();                        // convert to lowercase
    return s.substring(0, num_chars || 256);    // trim to first num_chars chars
  }
    
});