#!/usr/bin/env lua
-- use_rdparser3.lua
-- Glenn G. Chappell
-- 2025-02-13
--
-- For CS 331 Spring 2025
-- Simple Main Program for rdparser3 Module
-- Requires rdparser3.lua

rdparser3 = require "rdparser3"


-- String forms of symbolic constants
-- Used by printAST
symbolNames = {
  [1]="BIN_OP",
  [2]="NUMLIT_VAL",
  [3]="SIMPLE_VAR",
}


-- printAST
-- Print an AST, in (roughly) Lua form, with numbers replaced by strings
-- in symbolNames, where possible.
function printAST(...)
    if select("#", ...) ~= 1 then
        error("printAST: must pass exactly 1 argument")
    end
    local x = select(1, ...)  -- Get argument (which may be nil)

    local bracespace = ""     -- Space, if any, inside braces

    if type(x) == "nil" then
        io.write("nil")
    elseif type(x) == "number" then
        if symbolNames[x] then
            io.write(symbolNames[x])
        else
            io.write("<ERROR: Unknown constant: "..x..">")
        end
    elseif type(x) == "string" then
        if string.sub(x, 1, 1) == '"' then
            io.write("'"..x.."'")
        else
            io.write('"'..x..'"')
        end
    elseif type(x) == "boolean" then
        if x then
            io.write("true")
        else
            io.write("false")
        end
    elseif type(x) ~= "table" then
        io.write('<'..type(x)..'>')
    else  -- type is "table"
        io.write("{", bracespace)
        local first = true  -- First iteration of loop?
        local maxk = 0
        for k, v in ipairs(x) do
            if first then
                first = false
            else
                io.write(", ")
            end
            maxk = k
            printAST(v)
        end
        for k, v in pairs(x) do
            if type(k) ~= "number"
              or k ~= math.floor(k)
              or (k < 1 and k > maxk) then
                if first then
                    first = false
                else
                    io.write(", ")
                end
                io.write("[")
                printAST(k)
                io.write("]=")
                printAST(v)
            end
        end
        if not first then
            io.write(bracespace)
        end
        io.write("}")
    end
end


-- Separator string
dashes = ("-"):rep(72)  -- Lots of dashes


-- check
-- Given a "program", check its syntactic correctness using rdparser3.
-- Print results.
function check(program)
    io.write("Program: "..program.."\n")

    -- Parse
    local good, done, ast = rdparser3.parse(program)
    assert(type(good) == "boolean",
           "Function 'parse' must return 2 boolean values")
    assert(type(done) == "boolean",
           "Function 'parse' must return 2 boolean values")
    if good then
        assert(type(ast) == "table",
           "AST returned by function 'parse' must be a table")
    end

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
        io.write("Good! - AST: ")
        printAST(ast)
        io.write("\n")
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
io.write("Recursive-Descent Parser: Expressions\n")
io.write(dashes.."\n")

check("")
check("123")
check("xyz")
check("a b")
check("3a")
check("a +")
check("a + * b")
check("a + b (* c)")
check("a + 2")
check("(a + 2) * b")
check("a * -3")
check("a + +3 - c")
check("a + b - c + d - e")
check("a + (b - (c + (d - e)))")
check("a * +3 + c")
check("(a * +3) + c")
check("a * (+3 + c)")
check("a + +3 * c")
check("(a + +3) * c")

