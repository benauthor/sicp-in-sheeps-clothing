/**
 * The SICP metacircular evaluator
 * (in javascript -- so it's no longer really metacircular at all.)
 */

/*jslint evil: true, nomen: true*/
"use strict";

var scheme = scheme || {};
scheme.VERSION = '0.0.1';

/**
 * Scheme's environment needs someplace to live.
 */
scheme.env = {};

/**
 * Take a string of scheme and turn it into a JS list.
 * 
 * Since almost all scheme syntax is nested lists, we can pretty easily
 * transform it to Javascript native arrays.
 *
 * (+ 1 2 (* 3 4)) becomes ['+', '1', '2', ['*', '3', '4']]
 *
 * TODO is this the place to transform `(1 2 3) into (quote 1 2 3)
 */
scheme.to_list = function (exp) {
    var tokens, helper;
    //First, explode the string (add all allowed chars here TODO!)
    tokens = exp.match(/[\(\)]|[0-9+a-z+A-Z\+\-\\\']+/g);

    //Then recurse through
    helper = function () {
        var token,
            p = [],
            i = 0;
        while (token != ')'){
            token = tokens.shift();
            if (token === '('){
                p.push(helper());
            } else if (token !== ')'){
                p.push(token);
            }
            //avoid infinite loops
            if (i>100){
                throw new scheme.ParseException("Mismatched Parens!", exp);
            }
            i++;
        }
        return p;
    };
    if (tokens[0] === '(') {
        tokens.shift()
        return helper();
    } else {
        //TODO self-evaluating should be allowed, tight?
        return tokens;
        // throw new this.ParseException("Unable to parse string", exp);
    }
};

/**
 * Eval a string containing a scheme expression
 */
scheme.evals = function (exp) {
    return this._eval(this.to_list(exp));
};

/**
 * Evaluates a Scheme expression
 *
 * From here on out we're assuming we'll get scheme expressions in the form
 * of native javascript arrays, i.e. ['+', '2', '4'] is equivalent to (+ 2 4).
 */

// (define (eval exp env)
//   (cond ((self-evaluating? exp) exp)
//         ((variable? exp) (lookup-variable-value exp env))
//         ((quoted? exp) (text-of-quotation exp))
//         ((assignment? exp) (eval-assignment exp env))
//         ((definition? exp) (eval-definition exp env))
//         ((if? exp) (eval-if exp env))
//         ((lambda? exp)
//          (make-procedure (lambda-parameters exp)
//                          (lambda-body exp)
//                          env))
//         ((begin? exp) 
//          (eval-sequence (begin-actions exp) env))
//         ((cond? exp) (eval (cond->if exp) env))
//         ((application? exp)
//          (apply (eval (operator exp) env)
//                 (list-of-values (operands exp) env)))
//         (else
//          (error "Unknown expression type -- EVAL" exp))))
scheme._eval = function (exp, env) {
    if (this.is_self_evaluating(exp)) {
        return exp;
    } else if (this.is_variable(exp)) {
        this.lookup_variable(exp, env);
    } else if (this.is_quoted(exp)) {
        this.text_of_quotation(exp);
    } else if (this.is_assignment(exp)) {
        this.eval_assignment(exp, env);
    } else if (this.is_definition(exp)) {
        this.eval_definition(exp, env);
    } else if (this.is_if(exp)) {
        this.eval_if(exp, env);
    } else if (this.is_lambda(exp)) {
        this.make_proc(lambda_params(exp),
                  lambda_body(exp),
                  env);
    } else if (this.is_begin(exp)) {
        this.eval_sequence(begin_actions(exp), env);
    } else if (this.is_cond(exp)) {
        this._eval(cond_to_if(exp), env);
    } else if (this.is_application(exp)) {
        this.apply(this._eval(operator(exp), env),
              this.list_of_values(operands(exp), env));
    } else {
        throw new this.EvalException("Unknown expression type", exp);
    }
};

/**
 * Is it a tagged list?
 * 
 * The tagged list is how we're going to identify many special forms.
 * A quote is tagged with 'quote', a string with 'string', and so on.
 */
// (define (tagged-list? exp tag)
//   (if (pair? exp)
//       (eq? (car exp) tag)
//       false))
scheme.is_tagged_list = function (exp, tag) {
    if (exp[0] === tag) {
        return true;
    } else {
        return false;
    }
};

/**
 * CAR and CDR are useful scheme idioms.
 */
scheme.car = function (a_list) {
    return a_list[0]
}
scheme.cdr = function (a_list) {
    return a_list[1]
}

/**
 * Is it self evaluating?
 *
 * Certain Scheme constructs evaluate themselves; numbers, strings.
 */
// (define (self-evaluating? exp)
//   (cond ((number? exp) true)
//         ((string? exp) true)
//         (else false)))
scheme.is_self_evaluating = function (exp) {
    if (typeof exp === "number") {
        return true;
    } else if (this.is_tagged_list(exp, 'string')) {
        return true;
    } else {
        return false;
    }
};

/**
 * Is it a variable?
 *
 * Look and see if the name is on the environment.
 */
//(define (variable? exp) (symbol? exp))
scheme.is_variable = function (exp) {
    if (this.env.hasOwnProperty(exp)) {
        return true;
    } else {
        return false;
    }
};

/**
 * Is it quoted?
 *
 * This may need work an my understanding evolves... TODO.
 */
// (define (quoted? exp)
//   (tagged-list? exp 'quote))
scheme.is_quoted = function (exp) {
    return this.is_tagged_list(exp, 'quote');
};

/**
 * Return the text of a quotation.
 */
// (define (text-of-quotation exp) (cadr exp))
scheme.text_of_quotation = function (exp) {
    return exp[1]
}




// (define (assignment? exp)
//   (tagged-list? exp 'set!))
// (define (assignment-variable exp) (cadr exp))
// (define (assignment-value exp) (caddr exp))
scheme.is_assignment = function (exp) {
    return this.is_tagged_list(exp, 'set!')
}
scheme.assignment_variable = function (exp) {
    return exp.split(" ").slice(1,2).toString()
}
scheme.assignment_value = function (exp) {
    return exp.split(" ").slice(2).join(" ").slice(0, -1)
}

// ¤ Definitions have the form

// (define <var> <value>)

// or the form

// (define (<var> <parameter1> ... <parametern>)
//   <body>)

// The latter form (standard procedure definition) is syntactic sugar for

// (define <var>
//   (lambda (<parameter1> ... <parametern>)
//     <body>))

// (define (definition? exp)
//   (tagged-list? exp 'define))
// (define (definition-variable exp)
//   (if (symbol? (cadr exp))
//       (cadr exp)
//       (caadr exp)))
// (define (definition-value exp)
//   (if (symbol? (cadr exp))
//       (caddr exp)
//       (make-lambda (cdadr exp)   ; formal parameters
//                    (cddr exp)))) ; body

//\([\w\W]*?\([\w\W]*?\)
//gah
scheme.is_definition = function (exp) {
    return this.is_tagged_list(exp, "define")
}
scheme.definition_variable = function (exp) {
    var second = exp.split(" ").slice(1,2).toString();
    if (second.slice(0,1) === "(") {
        return second.slice(1)
    } else {
        //(define <var> <body>)
        return second
    }
}
scheme.definition_value = function (exp) {
    var second = exp.split(" ").slice(1,2).toString();
    console.log(second);
    if (second === "(lambda") {
        return scheme.cdr(scheme.cdr(exp))
    } else if (second.slice(0,1) === "(") {
        return this.make_lambda(
            //two difficult regexes here to do cdadr and cddr
            );
    } else {
        //(define <var> <body>)
        return exp.split(" ").slice(2).join(" ").slice(0, -1)
    }  
}

// ¤ Lambda expressions are lists that begin with the symbol lambda:

// (define (lambda? exp) (tagged-list? exp 'lambda))
// (define (lambda-parameters exp) (cadr exp))
// (define (lambda-body exp) (cddr exp))

// We also provide a constructor for lambda expressions, which is used by definition-value, above:

// (define (make-lambda parameters body)
//   (cons 'lambda (cons parameters body)))

// ¤ Conditionals begin with if and have a predicate, a consequent, and an (optional) alternative. If the expression has no alternative part, we provide false as the alternative.10

// (define (if? exp) (tagged-list? exp 'if))
// (define (if-predicate exp) (cadr exp))
// (define (if-consequent exp) (caddr exp))
// (define (if-alternative exp)
//   (if (not (null? (cdddr exp)))
//       (cadddr exp)
//       'false))

// We also provide a constructor for if expressions, to be used by cond->if to transform cond expressions into if expressions:

// (define (make-if predicate consequent alternative)
//   (list 'if predicate consequent alternative))







// (define (apply procedure arguments)
//   (cond ((primitive-procedure? procedure)
//          (apply-primitive-procedure procedure arguments))
//         ((compound-procedure? procedure)
//          (eval-sequence
//            (procedure-body procedure)
//            (extend-environment
//              (procedure-parameters procedure)
//              arguments
//              (procedure-environment procedure))))
//         (else
//          (error
//           "Unknown procedure type -- APPLY" procedure))))

scheme.apply = function (proc, args) {
    if (this.is_primitive(proc)) {
        this.apply_primitive(proc, args);
    } else if (this.is_compound(proc)) {
        this.eval_sequence(this.proc_body(proc),
                           this.extend_env(this.proc_params(proc),
                                             args,
                                             this.proc_env(proc)));
    } else {
        throw new this.ApplyException("Unknown procedure type", proc);
    }
};





// (define (list-of-values exps env)
//   (if (no-operands? exps)
//       '()
//       (cons (eval (first-operand exps) env)
//             (list-of-values (rest-operands exps) env))))

// (define (eval-if exp env)
//   (if (true? (eval (if-predicate exp) env))
//       (eval (if-consequent exp) env)
//       (eval (if-alternative exp) env)))

// (define (eval-sequence exps env)
//   (cond ((last-exp? exps) (eval (first-exp exps) env))
//         (else (eval (first-exp exps) env)
//               (eval-sequence (rest-exps exps) env))))

// (define (eval-assignment exp env)
//   (set-variable-value! (assignment-variable exp)
//                        (eval (assignment-value exp) env)
//                        env)
//   'ok)

// (define (eval-definition exp env)
//   (define-variable! (definition-variable exp)
//                     (eval (definition-value exp) env)
//                     env)
//   'ok)





// Exception machinery

scheme.Exception = function() {}

scheme.Exception.prototype.toString = function() {
/**
 *  Form a string of relevant information.
 * 
 *  When providing this method, tools like Firebug show the returned 
 *  string instead of [object Object] for uncaught exceptions.
 * 
 *  @return {String} information about the exception
 **/
   var name = this.name || 'unknown';
    var message = this.message || 'no description';
    return '[' + name + '] ' + message;
};


scheme.EvalException = function (msg, exp) {
    this.name = 'EvalException';
    this.message = msg;
    this.expression = exp;
};
scheme.EvalException.prototype = new scheme.Exception();

scheme.ApplyException = function (msg, proc) {
    this.name = 'EvalException';
    this.message = msg;
    this.procedure = proc;
};
scheme.ApplyException.prototype = new scheme.Exception();

scheme.ParseException = function (msg, exp) {
    this.name = 'ParseException';
    this.message = msg;
    this.expression = exp;
};
scheme.EvalException.prototype = new scheme.Exception();