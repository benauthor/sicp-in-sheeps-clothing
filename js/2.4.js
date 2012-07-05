//2.4.js
//Exercise 2.4
//Alternative procedural implementation of pairs
//given:

//(define (cons x y)
//  (lambda (m) (m x y)))

//(define (car z)
//  (z (lambda (p q) p)))

//to answer the question, implement cdr. that's easy enough.

//(define (cdr z)
//  (z (lambda (p q) q)))

//now in javascript
var cons = function (x,y) {
    return function (func) {
        return func(x, y);
    }
}

var car = function (z) {
    return z(function (p, q) {
        return p;
    });
}

var cdr = function (z) {
    return z(function (p, q) {
        return q;
    });
}

var apair = cons(1,2);
console.log(car(apair));
console.log(cdr(apair));
