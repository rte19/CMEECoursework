#Author: Ryan Ellis
#Date made: 09/10/19

#Exercise 1
print("Exercise 1")
_a_global = 10 # a global variable

if _a_global >=5:
    _b_global = _a_global + 5 # also a global variable

def a_function():
    _a_global = 5 # a local variable

    if _a_global >= 5:
        _b_global = _a_global + 5 # also a local variable

    _a_local = 4

    print("Inside the function, the variable of _a_global is ", _a_global)
    print("Inside the function, the variable of _b_global is ", _b_global)
    print("Inside the function, the variable of _a_global is ", _a_local)

    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)
print("\n")

#Thus,though _a_global was overwritten inside the function, what
#happened inside the function remained inside the function (What 
#happens in Vegas...) . Note that _a_global is just a naming 
#convention – nothing special about this variable as such.

#Exercise 2
print("Exercise 2")
_a_global = 10

def a_function():
    _a_local = 4

    print("Inside the function, the value _a_local is ", _a_local)
    print("Inside the function, the value of _a_local is ", _a_global)

    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("\n")

#Exercise 3
print("Exercise 3")
_a_global = 10

print("Outside the function, the value of _a_global is ", _a_global)

def a_function():
    global _a_global
    _a_global = 5
    _a_local = 4

    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _a_local is ", _a_local)

    return None

a_function()

print("Outside the fuction, the value of _a_global now is ", _a_global)
print("\n")

#So, using the global specification converted _a_global to a truly 
#global variable that became available outside that function 
#(overwriting the original _a_global).

#Exercise 4
print("Exercise 4")
def a_function():
    _a_global = 10

    def a_function2():
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    a_function2()

    print("After calling a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)
print("\n")

#That is, using the global keyword inside the inner function
# _a_function2 resulted in changing the value of _a_global in
# the main worspace / namespace to 20, but within the scope of 
#_a_function, remained 10!

#Exercise 5
print("Exercise 5")
_a_global = 10

def a_function():

    def _a_function2():
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()

    print("After calling a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)