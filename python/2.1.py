# sicp in python??
def cons(x, y):
	""" create a pair """
	return (x, y)

def car(p):
	""" return first value in a pair """
	return p[0]

def cdr(p):
	""" return the second value in a pair """
	return p[1]

def makerat(x, y):
	return cons(x, y)

def consp(x, y):
	return lambda m: m(x, y)

def carp(p):
	return p( lambda p, q: p)
