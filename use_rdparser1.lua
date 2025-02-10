#!/usr/bin/env lua
-- use_rdparser1.lua
-- Glenn G. Chappell
-- 2025-02-09
--
-- For CS 331 Spring 2025
-- Simple Main Program for rdparser1 Module
-- Requires rdparser1.lua

rdparser1 = require "rdparser1"


-- Separator string
dashes = ("-"):rep(72)  -- Lots of dashes


-- check
-- Given a "program", check its syntactic correctness using rdparser1.
-- Print results.
function check(program)
    io.write("Program: "..program.."\n")

    -- Parse
    local good = rdparser1.parse(program)
    assert(type(good) == "boolean",
           "Function 'parse' must return a boolean value")

    -- Print results
    if good then
        io.write("Syntactically correct\n")
    else
        io.write("NOT SYNTACTICALLY CORRECT\n")
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

