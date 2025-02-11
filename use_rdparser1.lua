#!/usr/bin/env lua
-- use_rdparser1.lua
-- VERSION 2
-- Glenn G. Chappell
-- Started: 2025-02-09
-- Updated: 2025-02-10
--
-- For CS 331 Spring 2025
-- Simple Main Program for rdparser1 Module
-- Requires rdparser1.lua

-- History:
-- - v1:
--   - Written for parser with single boolean return value.
-- - v2:
--   - Revised for parser with 2 boolean return values.


rdparser1 = require "rdparser1"


-- Separator string
dashes = ("-"):rep(72)  -- Lots of dashes


-- check
-- Given a "program", check its syntactic correctness using rdparser1.
-- Print results.
function check(program)
    io.write("Program: "..program.."\n")

    -- Parse
    local good, done = rdparser1.parse(program)
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
io.write("Recursive-Descent Parser: Simple\n")
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

