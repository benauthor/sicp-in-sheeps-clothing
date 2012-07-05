var sicp = require('./sicp.js');

//Exercise 2.21
//(define (square-list items)
//  (map <??> <??>))

var square_list = function (items) {
    return items.map(square);
}

var a = [1, 2, 3, 4];
console.log(square_list(a));
