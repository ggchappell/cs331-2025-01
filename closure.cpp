// closure.cpp
// Glenn G. Chappell
// 2025-01-30
//
// For CS 331 Spring 2025
// C++11 Closures

#include <iostream>
using std::cout;
using std::cin;
#include <functional>
using std::function;


// multiply
// Return a function object (a closure) that multiplies by the given k.
function<int(int)> multiply(int k)
{
    auto doit = [=](int x)
    {
        return k * x;
    };

    // Return value is a function object, which wraps the lambda
    // function defined above. This object is a closure; it *captures* a
    // portion of the environment in which it is defined. The "[=]"
    // above means that the closure captures a copy of every variable it
    // uses. Replace this with "[k]" to specify that only a copy of k
    // is to be captured. Replace with "[&k]" to capture k by reference
    // -- a VERY BAD IDEA in this particular case, as k is a local
    // variable of function multiply.

    return doit;
}


// userPause
// Wait for user to press ENTER: read all chars through first newline.
void userPause()
{
    std::cout.flush();
    while (std::cin.get() != '\n') ;
}


// Main program
// Demonstrate multiply by creating some closures and using them.
int main()
{
    cout << "Demonstration of Closures in C++ "
         << "(2011 Standard and later)\n";
    cout << "See the source code for details.\n";
    cout << "\n";

    auto times2 = multiply(2);
    auto triple = multiply(3);
    auto times7 = multiply(7);

    cout << "300 times 2 is " << times2(300) << ".\n";
    cout << "25 tripled is " << triple(25) << ".\n";
    cout << "10 times 7 is " << times7(10) << ".\n";
    cout << "\n";

    // Wait for user
    cout << "Press ENTER to quit ";
    userPause();
}

