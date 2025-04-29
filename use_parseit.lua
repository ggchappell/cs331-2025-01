#!/usr/bin/env lua
-- use_parseit.lua
-- Glenn G. Chappell
-- Started: 2025-02-18
-- Updated: 2025-02-19
--
-- For CS 331 Spring 2025
-- Simple Main Program for parseit Module
-- Requires parseit.lua

parseit = require "parseit"


-- String forms of symbolic constants
-- Used by printAST
symbolNames = {
  [1]="PROGRAM",
  [2]="PRINT_STMT",
  [3]="PRINTLN_STMT",
  [4]="RETURN_STMT",
  [5]="ASSN_STMT",
  [6]="FUNC_CALL",
  [7]="FUNC_DEF",
  [8]="IF_STMT",
  [9]="WHILE_LOOP",
  [10]="STRLIT_OUT",
  [11]="CHR_CALL",
  [12]="BIN_OP",
  [13]="UN_OP",
  [14]="NUMLIT_VAL",
  [15]="READNUM_CALL",
  [16]="RND_CALL",
  [17]="SIMPLE_VAR",
  [18]="ARRAY_VAR",
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
equals = ("="):rep(72)  -- Lots of dashes


-- check
-- Given a "program", check its syntactic correctness using parseit.
-- Print results.
function check(program)
    io.write("Program: "..program.."\n")

    local good, done, ast = parseit.parse(program)
    assert(type(good) == "boolean")
    assert(type(done) == "boolean")
    if good then
        assert(type(ast) == "table")
    end

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
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: Fulmar\n")
io.write("\n")

io.write(equals.."\n")
io.write("### The following 6 programs will parse correcly with\n")
io.write("### parseit.lua as posted in the Git repository.\n")
io.write(dashes.."\n")
check("")
io.write(dashes.."\n")
check("print()")
io.write(dashes.."\n")
check("println('Yo!')")
io.write(dashes.."\n")
check("print('abc','def')print('xyz')println()")
io.write(dashes.."\n")
check("func f()end")
io.write(dashes.."\n")
check("func g()func h()end println()println()end println('y')")
io.write(equals.."\n")
io.write("\n")

io.write(equals.."\n")
io.write("### The following 6 programs parse correcly.\n")
io.write("### However, parseit.lua from the Git repository may give")
io.write(" incorrect results.\n")
io.write(dashes.."\n")
check("a=3")
io.write(dashes.."\n")
check("a=a+1")
io.write(dashes.."\n")
check("a=readnum();")
io.write(dashes.."\n")
check("print(a+1)")
io.write(dashes.."\n")
check("a=3println(a+b)")
io.write(dashes.."\n")
check("a[e*2+1]=2")
io.write(equals.."\n")
io.write("\n")

io.write(equals.."\n")
io.write("### The program below must have the AST from")
io.write(" the Assignment 4 description.\n")
io.write(dashes.."\n")
check("# Fulmar Example #1\n# Glenn G. Chappell\n"..
      "# 2025-02-18\nnn = 3\nprintln(nn+4)\n")
io.write(equals.."\n")
io.write("\n")

io.write(equals.."\n")
io.write("### The program below must get the result:")
io.write(" \"BAD - extra characters at end\"\n")
io.write(dashes.."\n")
check("println()elif")
io.write(equals.."\n")
io.write("\n")

io.write(equals.."\n")
io.write("### The program below must get the result:")
io.write(" \"UNFINISHED - more is needed\"\n")
io.write(dashes.."\n")
check("func foo()println(")
io.write(equals.."\n")
io.write("\n")

io.write(equals.."\n")
io.write("### The program below must get the result:")
io.write(" \"BAD - syntax error\"\n")
io.write(dashes.."\n")
check("if a) b")
io.write(equals.."\n")

