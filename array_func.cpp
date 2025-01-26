// array_func.cpp
// Glenn G. Chappell
// 2025-01-26
//
// For CS 331 Spring 2025
// Demo of Array of Functions in C++

#include <iostream>
using std::cout;
using std::endl;
#include <functional>
using std::function;
#include <vector>
using std::vector;


// userPause
// Wait for user to press ENTER: read all chars through first newline.
void userPause()
{
    std::cout.flush();
    while (std::cin.get() != '\n') ;
}


int main()
{
    // Make vector of "functions"
    vector<function<void()>> funcs {
        []() { cout << "Zero\n"; },
        []() { cout << "One\n"; },
        []() { cout << "Two\n"; },
        []() { cout << "Three\n"; },
        []() { cout << "Four\n"; },
        []() { cout << "Five\n"; },
        []() { cout << "Six\n"; },
        []() { cout << "Seven\n"; },
        []() { cout << "Eight\n"; },
        []() { cout << "Nine\n"; },
        []() { cout << "Ten\n"; }
    };

    // Set our variable
    int n = 7;

    // Call one of the above, using a vector look-up
    cout << "n = " << n << "\n";
    cout << "Result of function call: ";
    funcs[n]();
    cout << endl;

    // Wait for user
    cout << "Press ENTER to quit ";
    userPause();
}

