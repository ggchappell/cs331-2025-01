// curry.cpp
// Glenn G. Chappell
// 2025-02-23
//
// For CS 331 Spring 2025
// Currying in C++
// Based on closure.cpp

#include <iostream>
using std::cout;
using std::cin;
#include <functional>
using std::function;


// Function multiply copied from file closure.cpp

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
    // should be captured. Replace with "[&k]" to capture k by reference
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
// Demonstrate multiply without and with currying.
int main()
{
    cout << "Demonstration of Currying in C++\n";
    cout << "See the source code for details.\n";
    cout << "\n";

    auto times2 = multiply(2);

    cout << "Without currying:\n";
    cout << "300 times 2 is " << times2(300) << ".\n";
    cout << "\n";

    cout << "Currying:\n";
    cout << "300 times 2 is " << multiply(300)(2) << ".\n";
    cout << "\n";

    // Wait for user
    cout << "Press ENTER to quit ";
    userPause();
}

