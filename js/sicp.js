global.square = function (x) {
    return x * x;
}

global.cons = function (x, y) {
    return [x,y];
}

global.car = function (p) {
    var result = p[0];
    if ( result === undefined ) {
		return [];
	} else {
		return result;
	}
}

global.cdr = function (p) {
    var result = p[1];
    if ( result === undefined ) {
		return [];
	} else {
		return result;
	}
}

global.expt = function (b, p) {
    return Math.pow(b, p);
}

global.puts = function (x) {
    process.stdout.write(x + '\n');
}
