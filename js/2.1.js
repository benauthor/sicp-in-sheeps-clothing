function cons(x, y) {
    return [x,y];
}

function car(x){
    return x[0];
}

function cdr(y){
    return x[1];
}

var guh = cons(1,2);

var sum = function (x,y) {
    return x + y;
}

var proc_cons = function (x,y) {
    return function (func) {
        return func(x, y);
    }
}

var proc_car = function (pair_func) {
    return pair_func(function (p, q) {
        return p;
    });
}

var proc_cdr = function (pair_func) {
    return pair_func(function (p, q) {
        return q;
    });
}

var hi = proc_cons("hello ", "world");
console.log(proc_car(hi));
console.log(proc_cdr(hi));
