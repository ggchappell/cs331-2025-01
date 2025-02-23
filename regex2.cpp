// regex2.cpp
// Glenn G. Chappell
// 2025-01-16
//
// For CS 331 Spring 2025
// Demo of regular expressions in C++

#include <iostream>
using std::cout;
using std::cin;
#include <string>
using std::string;
using std::getline;
#include <regex>
using std::regex;
using std::smatch;
using std::regex_search;


// Main program
int main()
{
    // ******************************************************
    // * EDIT THE FOLLOWING STRING TO CHANGE THE REGEX USED *
    // ******************************************************
    regex re1("ab*c");  // Our regular expression

    cout << "Demonstration of Regexes in C++\n";
    cout << "Type strings to attempt to match.\n";
    cout << "See the source code to change the regex used.\n";
    cout << "\n";
    // Read stdin & print info on each line matched by above regex.
    while (true)
    {
        string line;
        getline(cin, line);

        if (!cin)
        {
            if (cin.eof())
                break;
            cout << "*** ERROR READING STD INPUT\n";
            break;
        }

        smatch results;
        // Below, if the results are not needed, then we can just do
        //   if (regex_search(line, re1))
        if (regex_search(line, results, re1))  // results is "out" param
        {
            cout << line << ": MATCHED [" << results[0] << "]\n";
        }
    }
}

