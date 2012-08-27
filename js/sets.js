// basic unordered set representation, based on SICP 2.3.3 (exercise 2.59)

var Set = function (things) {

    'use strict';

    this.items = [];

    this.init = function (things) {

        // add all 'things' to the new set
        if (things !== undefined) {

            var i = things.length;

            while (i--) {
                this.adjoin(things[i]);
            }

        }
    };

    this.has_element = function (thing) {
        //is element in the set?

        var i = this.items.length;

        while (i--) {
            if (this.items[i] === thing) {
                return true;
            }
        }
        return false;
    };


    this.adjoin = function (thing) {

        // adjoin an item to the set

        if (this.has_element(thing)) {
            return this;
        } else {
            this.items.push(thing);
            return this;
        }
    };

    this.intersection = function (set) {

        //return the intersection of two sets

        var result = [],
            i = set.length;

        while (i--) {
            if (this.has_element(set[i])) {
                result.push(set[i]);
            }
        }

        return result;
    };

    this.union = function (set) {

        //return the union of two sets

        var result = this.items,
            i = set.length;

        while (i--) {
            if (!this.has_element(set[i])) {
                result.push(set[i]);
            }
        }

        return result;
    };

    this.init(things);

};

var s = new Set([1, 2, 3]);
s.adjoin(4);
s.adjoin(4);

var p = new Set();
p.adjoin(3);
p.adjoin(5);

console.log(s.items);
console.log(p.items);

console.log(s.intersection(p.items));
console.log(s.union(p.items));