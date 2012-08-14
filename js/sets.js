var Set = function(things) {

    this.items = [];

    this.init = function(things){

        // add all 'things' to the new set
        if (things !== undefined){
            
            var i = things.length;

            while (i--) {
                this.adjoin(things[i]);
            }

        }
    }

    this.has_element = function(thing){
        //is element in the set?

        var i = this.items.length;

        while (i--) {
            if (this.items[i] === thing) {
                return true;
            }
        }
        return false;

    }


    this.adjoin = function(thing){

        // adjoin an item to the set

        if (this.has_element(thing)) {
            return this;
        } else {
            this.items.push(thing)
            return this
        }

    }

    this.intersection = function(set){
        //return a set that's intersected
    }

    this.union = function(set){
        //return a union of two sets
    }

    this.init(things);

}

var s = new Set([1,2,3]);
s.adjoin(4);
s.adjoin(4);
var p = new Set();
p.adjoin(3);
p.adjoin(5);

console.log(s.items);

console.log(p.items);
