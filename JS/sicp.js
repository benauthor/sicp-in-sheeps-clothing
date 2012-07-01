global.square = function (x) {
    return x * x;
}

global.cons = function (x, y) {
    return [x,y];
}

global.car = function (p) {
    return p[0];
}

global.cdr = function (p) {
    return p[1];
}

global.expt = function (b, p) {
    return Math.pow(b, p);
}

global.puts = function (x) {
    process.stdout.write(x + '\n');
}
