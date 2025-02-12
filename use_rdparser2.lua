#!/usr/bin/env lua
-- use_rdparser2.lua
-- Glenn G. Chappell
-- 2025-02-11
--
-- For CS 331 Spring 2025
-- Simple Main Program for rdparser2 Module
-- Requires rdparser2.lua

rdparser2 = require "rdparser2"


-- Separator string
dashes = ("-"):rep(72)  -- Lots of dashes


-- check
-- Given a "program", check its syntactic correctness using rdparser2.
-- Print results.
function check(program)
    io.write("Program: "..program.."\n")

    -- Parse
    local good, done = rdparser2.parse(program)
    assert(type(good) == "boolean",
           "Function 'parse' must return 2 boolean values")
    assert(type(done) == "boolean",
           "Function 'parse' must return 2 boolean values")

    -- Print results
    if good then
        io.write("Syntactically correct; ")
    else
        io.write("NOT SYNTACTICALLY CORRECT; ")
    end

    if done then
        io.write("all input parsed\n")
    else
        io.write("NOT ALL INPUT PARSED\n")
    end

    io.write("Conclusion: ")
    if good and done then
        io.write("Good!\n")
    elseif good and not done then
        io.write("BAD - extra characters at end\n")
    elseif not good and done then
        io.write("UNFINISHED - more is needed\n")
    else  -- not good and not done
        io.write("BAD - syntax error\n")
    end

    io.write(dashes.."\n")
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: More Complex\n")
io.write(dashes.."\n")

check("")
check("123")
check("xyz")
check("*-*")
check("((+12.34))")
check("( (((( * - * )) )))")
check("(1,2,3)")
check("(((42))")
check("((42)))")
check("1,2,3")
check("1;2,3;4;5")
check("ab[12[3]]")
check("ab[*-*]")
check("cd[x]")
check("((ef[(((1,2;3;4)))]))")
check("((gh[(((1,2;3;4)))]))&")
check("(ij[((2;3,4))")

