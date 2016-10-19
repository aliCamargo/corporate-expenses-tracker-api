angular
.module('app')
	.filter('humanize', function(){
	  return function(text) {
	    if(text) { 
	      var string = text.split("_").join(" ").toLowerCase();
	      string = string.charAt(0).toUpperCase() + string.slice(1); 
	      return string
	    };
	  };
	})

	.filter('sumByKey', function() {
		return function(data, key, pickDay) {
			if (typeof(data) === 'undefined' || typeof(key) === 'undefined') {
				return 0;
			}

			var sum = 0;
			for (var i = data.length - 1; i >= 0; i--) {
				sum += parseInt(data[i][key]);
			}

			return sum;
		};
	});