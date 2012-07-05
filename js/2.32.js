var sicp = require('./sicp.js');

var subsets = function (s) {
	if (s.length === 0) {
		return s
	} else {
		return (function(){ //equivalent of let
			var rest = subsets(s.slice(1));
	console.log(rest);

			rest.push(
				rest.map(
					function(x) {
						return [ s[0], x ];
					}
				)
			);
			return rest;
		})();
	}
}



var alist = [1, 2, 3];
console.log(subsets(alist));
