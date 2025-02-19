#!/usr/bin/env lua
-- parseit_test.lua
-- Glenn G. Chappell
-- 2025-02-18
--
-- For CS 331 Spring 2025
-- Test Program for Module parseit
-- Used in Assignment 4, Exercise A

parseit = require "parseit"  -- Import parseit module


-- *********************************************
-- * YOU MAY WISH TO CHANGE THE FOLLOWING LINE *
-- *********************************************

EXIT_ON_FIRST_FAILURE = true
-- If EXIT_ON_FIRST_FAILURE is true, then this program exits after the
-- first failing test. If it is false, then this program executes all
-- tests, reporting success/failure for each.


-- *********************************************************************
-- Testing Package
-- *********************************************************************


tester = {}
tester.countTests = 0
tester.countPasses = 0

function tester.test(self, success, testName)
    self.countTests = self.countTests+1
    io.write("    Test: " .. testName .. " - ")
    if success then
        self.countPasses = self.countPasses+1
        io.write("passed")
    else
        io.write("********** FAILED **********")
    end
    io.write("\n")
end

function tester.allPassed(self)
    return self.countPasses == self.countTests
end


-- *********************************************************************
-- Utility Functions
-- *********************************************************************


-- terminate
-- Called to end the program. Currently simply ends. To make the program
-- prompt the user and wait for the user to press ENTER, uncomment the
-- commented-out lines in the function body. The parameter is the
-- program's return value.
function terminate(status)
    -- Uncomment to following to wait for the user before terminating.
    --io.write("\nPress ENTER to quit ")
    --io.read("*l")

    os.exit(status)
end


function failExit()
    if EXIT_ON_FIRST_FAILURE then
        io.write("**************************************************\n")
        io.write("* This test program is configured to exit after  *\n")
        io.write("* the first failing test. To make it execute all *\n")
        io.write("* tests, reporting success/failure for each, set *\n")
        io.write("* variable                                       *\n")
        io.write("*                                                *\n")
        io.write("*   EXIT_ON_FIRST_FAILURE                        *\n")
        io.write("*                                                *\n")
        io.write("* to false, near the start of the test program.  *\n")
        io.write("**************************************************\n")

        -- Terminate program, signaling error
        terminate(1)
    end
end


function endMessage(passed)
    if passed then
        io.write("All tests successful\n")
    else
        io.write("Tests ********** UNSUCCESSFUL **********\n")
        io.write("\n")
        io.write("**************************************************\n")
        io.write("* This test program is configured to execute all *\n")
        io.write("* tests, reporting success/failure for each. To  *\n")
        io.write("* make it exit after the first failing test, set *\n")
        io.write("* variable                                       *\n")
        io.write("*                                                *\n")
        io.write("*   EXIT_ON_FIRST_FAILURE                        *\n")
        io.write("*                                                *\n")
        io.write("* to true, near the start of the test program.   *\n")
        io.write("**************************************************\n")
    end
end


-- printValue
-- Given a value, print it in (roughly) Lua literal notation if it is
-- nil, number, string, boolean, or table -- calling this function
-- recursively for table keys and values. For other types, print an
-- indication of the type. The second argument, if passed, is max_items:
-- the maximum number of items in a table to print.
function printValue(...)
    assert(select("#", ...) == 1 or select("#", ...) == 2,
           "printValue: must pass 1 or 2 arguments")
    local x, max_items = select(1, ...)  -- Get args (may be nil)
    if type(max_items) ~= "nil" and type(max_items) ~= "number" then
        error("printValue: max_items must be a number")
    end

    if type(x) == "nil" then
        io.write("nil")
    elseif type(x) == "number" then
        io.write(x)
    elseif type(x) == "string" then
        io.write(string.format('%q', x))
    elseif type(x) == "boolean" then
        if x then
            io.write("true")
        else
            io.write("false")
        end
    elseif type(x) ~= "table" then
        io.write('<'..type(x)..'>')
    else  -- type is "table"
        io.write("{")
        local first = true  -- First iteration of loop?
        local key_count, unprinted_count = 0, 0
        for k, v in pairs(x) do
            key_count = key_count + 1
            if max_items ~= nil and key_count > max_items then
                unprinted_count = unprinted_count + 1
            else
                if first then
                    first = false
                else
                    io.write(",")
                end
                io.write(" [")
                printValue(k, max_items)
                io.write("]=")
                printValue(v, max_items)
            end
        end
        if unprinted_count > 0 then
            if first then
                first = false
            else
                io.write(",")
            end
            io.write(" <<"..unprinted_count)
            if key_count - unprinted_count > 0 then
                io.write(" more")
            end
            if unprinted_count == 1 then
                io.write(" item>>")
            else
                io.write(" items>>")
            end
        end
        io.write(" }")
    end
end


-- printArray
-- Like printValue, but prints top-level tables as arrays.
-- Uses printValue.
-- The second argument, if passed, is max_items: the maximum number of
-- items in a table to print.
function printArray(...)
    assert(select("#", ...) == 1 or select("#", ...) == 2,
           "printArray: must pass 1 or 2 arguments")
    local x, max_items = select(1, ...)  -- Get args (may be nil)
    if type(max_items) ~= "nil" and type(max_items) ~= "number" then
        error("printArray: max_items must be a number")
    end

    if type(x) ~= "table" then
        printValue(x, max_items)
    else
        io.write("{")
        local first = true  -- First iteration of loop?
        local key_count, unprinted_count = 0, 0
        for k, v in ipairs(x) do
            key_count = key_count + 1
            if max_items ~= nil and key_count > max_items then
                unprinted_count = unprinted_count + 1
            else
                if first then
                    first = false
                else
                    io.write(",")
                end
                io.write(" ")
                printValue(v, max_items)
            end
        end
        if unprinted_count > 0 then
            if first then
                first = false
            else
                io.write(",")
            end
            io.write(" <<"..unprinted_count)
            if key_count - unprinted_count > 0 then
                io.write(" more")
            end
            if unprinted_count == 1 then
                io.write(" item>>")
            else
                io.write(" items>>")
            end
        end
        io.write(" }")
    end
end


-- equal
-- Compare equality of two values. Returns false if types are different.
-- Uses "==" on non-table values. For tables, recurses for the value
-- associated with each key.
function equal(...)
    assert(select("#", ...) == 2,
           "equal: must pass exactly 2 arguments")
    local x1, x2 = select(1, ...)  -- Get args (may be nil)

    local type1 = type(x1)
    if type1 ~= type(x2) then
        return false
    end

    if type1 ~= "table" then
       return x1 == x2
    end

    -- Get number of keys in x1 & check values in x1, x2 are equal
    local x1numkeys = 0
    for k, v in pairs(x1) do
        x1numkeys = x1numkeys + 1
        if not equal(v, x2[k]) then
            return false
        end
    end

    -- Check number of keys in x1, x2 same
    local x2numkeys = 0
    for k, v in pairs(x2) do
        x2numkeys = x2numkeys + 1
    end
    return x1numkeys == x2numkeys
end


-- *********************************************************************
-- Definitions for This Test Program
-- *********************************************************************


-- Symbolic Constants for AST
-- Names differ from those in assignment, to avoid interference.
local PROGRAMx      = 1
local PRINTxSTMT    = 2
local PRINTLNxSTMT  = 3
local RETURNxSTMT   = 4
local ASSNxSTMT     = 5
local FUNCxCALL     = 6
local FUNCxDEF      = 7
local IFxSTMT       = 8
local WHILExLOOP    = 9
local STRLITxOUT    = 10
local CHRxCALL      = 11
local BINxOP        = 12
local UNxOP         = 13
local NUMLITxVAL    = 14
local READNUMxCALL  = 15
local RNDxCALL      = 16
local SIMPLExVAR    = 17
local ARRAYxVAR     = 18


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


-- bool2Str
-- Given boolean, return string representing it: "true" or "false".
function bool2Str(b)
    if b then
        return "true"
    else
        return "false"
    end
end


-- checkParse
-- Given tester object, input string ("program"), expected output values
-- from parser (good, AST), and string giving the name of the test. Do
-- test & print result. If test fails and EXIT_ON_FIRST_FAILURE is true,
-- then print detailed results and exit program.
function checkParse(t, prog,
                    expectedGood, expectedDone, expectedAST,
                    testName)
    local actualGood, actualDone, actualAST = parseit.parse(prog)
    local sameGood = (expectedGood == actualGood)
    local sameDone = (expectedDone == actualDone)
    local sameAST = true
    if sameGood and expectedGood and sameDone and expectedDone then
        sameAST = equal(expectedAST, actualAST)
    end
    local success = sameGood and sameDone and sameAST
    t:test(success, testName)

    if success or not EXIT_ON_FIRST_FAILURE then
        return
    end

    io.write("\n")
    io.write("Input for the last test above:\n")
    io.write('"'..prog..'"\n')
    io.write("\n")
    io.write("Expected parser 'good' return value: ")
    io.write(bool2Str(expectedGood).."\n")
    io.write("Actual parser 'good' return value: ")
    io.write(bool2Str(actualGood).."\n")
    io.write("Expected parser 'done' return value: ")
    io.write(bool2Str(expectedDone).."\n")
    io.write("Actual parser 'done' return value: ")
    io.write(bool2Str(actualDone).."\n")
    if not sameAST then
        io.write("\n")
        io.write("Expected AST:\n")
        printAST(expectedAST)
        io.write("\n")
        io.write("\n")
        io.write("Returned AST:\n")
        printAST(actualAST)
        io.write("\n")
    end
    io.write("\n")
    failExit()
end


-- *********************************************************************
-- Test Suite Functions
-- *********************************************************************


function test_simple(t)
    io.write("Test Suite: simple cases\n")

    checkParse(t, "", true, true, {PROGRAMx},
      "Empty program")
    checkParse(t, "return", false, true, nil,
      "Bad program: Keyword only #1")
    checkParse(t, "elif", true, false, nil,
      "Bad program: Keyword only #2")
    checkParse(t, "else", true, false, nil,
      "Bad program: Keyword only #3")
    checkParse(t, "ab", false, true, nil,
      "Bad program: Identifier only")
    checkParse(t, "123", true, false, nil,
      "Bad program: NumericLiteral only")
    checkParse(t, '"xyz"', true, false, nil,
      "Bad program: StringLiteral only")
    checkParse(t, "<=", true, false, nil,
      "Bad program: Operator only")
    checkParse(t, "(", true, false, nil,
      "Bad program: Punctuation only")
    checkParse(t, "\a", true, false, nil,
      "Bad program: Malformed only #1 (bad character)")
    checkParse(t, '"', true, false, nil,
      "bad program: malformed only #2 (bad string)")
end


function test_print_stmt_no_expr(t)
    io.write("Test Suite: print/println statements - no expressions\n")

    checkParse(t, "print()", true, true,
      {PROGRAMx,{PRINTxSTMT}},
      "Print statement: no args")
    checkParse(t, "print()print()print()", true, true,
      {PROGRAMx,{PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT}},
      "3 print statements")
    checkParse(t, "print(\"abc\")", true, true,
      {PROGRAMx,{PRINTxSTMT,{STRLITxOUT,"\"abc\""}}},
      "Print statement: StringLiteral")
    checkParse(t, "print(\"a\",\"b\",\"c\",\"d\",\"e\")", true, true,
      {PROGRAMx,{PRINTxSTMT,{STRLITxOUT,"\"a\""},{STRLITxOUT,"\"b\""},
        {STRLITxOUT,"\"c\""},{STRLITxOUT,"\"d\""},
        {STRLITxOUT,"\"e\""}}},
      "Print statement: many StringLiterals")
    checkParse(t, "print", false, true, nil,
      "Bad print statement: no parens, no arguments")
    checkParse(t, "print \"a\"", false, false, nil,
      "Bad print statement: no parens")
    checkParse(t, "print\"a\")", false, false, nil,
      "Bad print statement: no opening paren")
    checkParse(t, "print(\"a\"", false, true, nil,
      "Bad print statement: no closing paren")
    checkParse(t, "print(if)", false, false, nil,
      "Bad print statement: keyword #1")
    checkParse(t, "print(print)", false, false, nil,
      "Bad print statement: keyword #2")
    checkParse(t, "print(\"a\"\"b\")", false, false, nil,
      "Bad print statement: missing comma")
    checkParse(t, "print(,\"a\")", false, false, nil,
      "Bad print statement: comma without preceding argument")
    checkParse(t, "print(\"a\",)", false, false, nil,
      "Bad print statement: comma without following argument")
    checkParse(t, "print(,)", false, false, nil,
      "Bad print statement: comma alone")
    checkParse(t, "print(\"a\",,\"b\")", false, false, nil,
      "Bad print statement: extra comma")
    checkParse(t, "print(\"a\")else", true, false, nil,
      "Bad print statement: print followed by else")

    checkParse(t, "println()", true, true,
      {PROGRAMx,{PRINTLNxSTMT}},
      "Print statement: no args")
    checkParse(t, "println()println()println()", true, true,
      {PROGRAMx,{PRINTLNxSTMT},{PRINTLNxSTMT},{PRINTLNxSTMT}},
      "3 println statements")
    checkParse(t, "println(\"abc\")", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{STRLITxOUT,"\"abc\""}}},
      "Println statement: StringLiteral")
    checkParse(t, "println(\"a\",\"b\",\"c\",\"d\",\"e\")", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{STRLITxOUT,"\"a\""},{STRLITxOUT,"\"b\""},
        {STRLITxOUT,"\"c\""},{STRLITxOUT,"\"d\""},
        {STRLITxOUT,"\"e\""}}},
      "Println statement: many StringLiterals")
    checkParse(t, "println", false, true, nil,
      "Bad println statement: no parens, no arguments")
    checkParse(t, "println \"a\"", false, false, nil,
      "Bad println statement: no parens")
    checkParse(t, "println\"a\")", false, false, nil,
      "Bad println statement: no opening paren")
    checkParse(t, "println(\"a\"", false, true, nil,
      "Bad println statement: no closing paren")
    checkParse(t, "println(if)", false, false, nil,
      "Bad println statement: keyword #1")
    checkParse(t, "println(println)", false, false, nil,
      "Bad println statement: keyword #2")
    checkParse(t, "println(\"a\"\"b\")", false, false, nil,
      "Bad println statement: missing comma")
    checkParse(t, "println(,\"a\")", false, false, nil,
      "Bad println statement: comma without preceding argument")
    checkParse(t, "println(\"a\",)", false, false, nil,
      "Bad println statement: comma without following argument")
    checkParse(t, "println(,)", false, false, nil,
      "Bad println statement: comma alone")
    checkParse(t, "println(\"a\",,\"b\")", false, false, nil,
      "Bad println statement: extra comma")
    checkParse(t, "println(\"a\")else", true, false, nil,
      "Bad println statement: println followed by else")

    checkParse(t, "\"a\"", true, false, nil,
      "Bad program: (no print) string only")
    checkParse(t, "(\"a\")", true, false, nil,
      "Bad program: (no print) string in parens only")
end


function test_function_call_stmt(t)
    io.write("Test Suite: Function call statements\n")

    checkParse(t, "ff()", true, true,
      {PROGRAMx,{FUNCxCALL,"ff"}},
      "Function call statement #1")
    checkParse(t, "fffffffffffffffffffffffffffffffff()", true, true,
      {PROGRAMx,{FUNCxCALL,"fffffffffffffffffffffffffffffffff"}},
      "Function call statement #2")
    checkParse(t, "ff()gg()", true, true,
      {PROGRAMx,{FUNCxCALL,"ff"},{FUNCxCALL,"gg"}},
      "Two function call statements")
    checkParse(t, "ff)", false, false, nil,
      "Bad function call statement: no left paren")
    checkParse(t, "ff(", false, true, nil,
      "Bad function call statement: no right paren")
    checkParse(t, "ff(()", false, false, nil,
      "Bad function call statement: extra left paren")
    checkParse(t, "ff())", true, false, nil,
      "Bad function call statement: extra right paren")
    checkParse(t, "ff()()", true, false, nil,
      "Bad function call statement: extra pair of parens")
    checkParse(t, "ff gg()", false, false, nil,
      "Bad function call statement: extra name")
    checkParse(t, "(ff)()", true, false, nil,
      "Bad function call statement: parentheses around name")
    checkParse(t, "ff(a)", false, false, nil,
      "Bad function call statement: argument - Identfier arg")
    checkParse(t, "ff(\"abc\")", false, false, nil,
      "Bad function call statement: argument - StringLiteral arg")
    checkParse(t, "ff(2)", false, false, nil,
      "Bad function call statement: argument - NumericLiteral arg")
end


function test_func_def_no_expr(t)
    io.write("Test Suite: function definitions - no expressions\n")

    checkParse(t, "func s()end", true, true,
      {PROGRAMx,{FUNCxDEF,"s",{PROGRAMx}}},
      "Function definition: empty body")
    checkParse(t, "func()end", false, false, nil,
      "Bad function definition: missing name")
    checkParse(t, "func end", false, false, nil,
      "Bad function definition: missing name & parens")
    checkParse(t, "func &s()end", false, false, nil,
      "Bad function definition: ampersand before name")
    checkParse(t, "func s end", false, false, nil,
      "Bad function definition: no parens")
    checkParse(t, "func s()", false, true, nil,
      "Bad function definition: no end")
    checkParse(t, "func s(){}", false, false, nil,
      "Bad function definition: braces instead of end")
    checkParse(t, "func s())end", false, false, nil,
      "Bad function definition: extra right paren")
    checkParse(t, "func (s)()end", false, false, nil,
      "Bad function definition: name in parentheses")
    checkParse(t, "func s()print(\"abc\")end", true, true,
      {PROGRAMx,{FUNCxDEF,"s",{PROGRAMx,{PRINTxSTMT,
        {STRLITxOUT,"\"abc\""}}}}},
      "Function definition: 1-statement body #1")
    checkParse(t, "func s()print(\"x\")end", true, true,
      {PROGRAMx,{FUNCxDEF,"s",{PROGRAMx,{PRINTxSTMT,
        {STRLITxOUT,"\"x\""}}}}},
      "Function definition: 1-statement body #2")
    checkParse(t, "func s()print()print()end", true, true,
      {PROGRAMx,{FUNCxDEF,"s",{PROGRAMx,{PRINTxSTMT},
        {PRINTxSTMT}}}},
      "Function definition: 2-statement body")
    checkParse(t, "func sss()print()print()print()end",
      true, true,
      {PROGRAMx,{FUNCxDEF,"sss",{PROGRAMx,{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}}}},
      "Function definition: longer body")
    checkParse(t, "func s()func t()func u()print()end"
     .." func v()print()end end end", true, true,
      {PROGRAMx,{FUNCxDEF,"s",{PROGRAMx,{FUNCxDEF,"t",{PROGRAMx,
        {FUNCxDEF,"u",{PROGRAMx,{PRINTxSTMT}}},{FUNCxDEF,
        "v",{PROGRAMx,{PRINTxSTMT}}}}}}}},
      "Function definition: nested function definitions")
end

function test_while_loop_simple_expr(t)
    io.write("Test Suite: while loops - simple expressions only\n")

    checkParse(t, "while(1)end", true, true,
      {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},{PROGRAMx}}},
      "While loop: 1, empty")
    checkParse(t, "while(1)print()end", true, true,
      {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},{PROGRAMx,
        {PRINTxSTMT}}}},
      "While loop: true, 1 stmt in body")
    checkParse(t, "while(1)print()print()print()print()"
     .."print()print()print()print()print()print()end", true,
     true,
      {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},{PROGRAMx,
        {PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}}}},
      "While loop: 1, longer statement list")
    checkParse(t, "while(1)while(1)while(1)"
     .."while(1)while(1)while(1)while(1)"
     .."while(1)while(1)while(1)while(1)"
     .."while(1)while(1)while(1)end end end end end end end end end end"
     .." end end end end",
     true, true,
      {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx}}}}}}}}}}}}}}}}}}}}}}}}}}}}},
      "While loop: true, nested")

    checkParse(t, "while end", false, false, nil,
      "Bad while loop: no condition")
    checkParse(t, "while 1", false, true, nil,
      "Bad while loop: no end")
    checkParse(t, "while while 1end", false, false, nil,
      "Bad while loop: extra while")
    checkParse(t, "while 1 1end", false, false, nil,
      "Bad while loop: extra condition")
end


function test_if_stmt_simple_expr(t)
    io.write("Test Suite: if statements - simple expressions only\n")

    checkParse(t, "if 1end", true, true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx}}},
      "If statement: empty stmt list")
    checkParse(t, "if 1print()end", true, true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,
      {PRINTxSTMT}}}},
      "If statement: one stmt in body")
    checkParse(t, "if 1else end", true,
      true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx},
      {PROGRAMx}}},
      "If statement: else")
    checkParse(t, "if 1elif 1end", true, true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx},
        {NUMLITxVAL,"1"},{PROGRAMx}}},
      "If statement: elif")
    checkParse(t, "if 1print()elif 1print()print()"
      .."elif 1print()print()print()elif 1"
      .."print()print()print()print()elif 1print()"
      .."print()print()print()print()end", true, true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT}}}},
      "If statement: multiple elif, no else")
    checkParse(t, "if 1print()elif 1print()print()"
      .."elif 1print()print()print()elif 1"
      .."print()print()print()print()elif 1print()"
      .."print()print()print()print()else print()print()"
      .."print()print()print()print()end", true, true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}},
        {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT}},{PROGRAMx,
        {PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT},{PRINTxSTMT},
        {PRINTxSTMT},{PRINTxSTMT}}}},
      "If statement: multiple elif, else")
    checkParse(t, "if 1if 1print()else print()end"
      .." elif 1if 1print()else print()end else"
      .." if 1print()else print()end end", true, true,
        {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,
          {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT}},{PROGRAMx,
          {PRINTxSTMT}}}},{NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,
          {NUMLITxVAL,"1"},{PROGRAMx,{PRINTxSTMT}},{PROGRAMx,
          {PRINTxSTMT}}}},{PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},
          {PROGRAMx,{PRINTxSTMT}},{PROGRAMx,{PRINTxSTMT}}}}}},
      "If statement: nested #1")
    checkParse(t, "if 1if 1if 1if 1if 1if 1if 1"
      .."print()end end end end end end end", true, true,
      {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,
        {NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},
        {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,
        {NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},
        {PROGRAMx,{IFxSTMT,{NUMLITxVAL,"1"},{PROGRAMx,
        {PRINTxSTMT}}}}}}}}}}}}}}}},
      "If statement: nested #2")
    checkParse(t, "while 1if 1while 1end"
      .." elif 1while 1if 1elif 1"
      .."while 1 end else while 1end end end end end",
      true, true,
      {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,
        {NUMLITxVAL,"1"},{PROGRAMx,{WHILExLOOP,
        {NUMLITxVAL,"1"},{PROGRAMx}}},{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},{PROGRAMx,{IFxSTMT,
        {NUMLITxVAL,"1"},{PROGRAMx},{NUMLITxVAL,"1"},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},{PROGRAMx}}},
        {PROGRAMx,{WHILExLOOP,{NUMLITxVAL,"1"},
        {PROGRAMx}}}}}}}}}}},
      "If statement: nested while & if")

    checkParse(t, "if print()end", false, false, nil,
      "Bad if statement: no condition")
    checkParse(t, "if 1", false, true, nil,
      "Bad if statement: no end")
    checkParse(t, "if 1 1end", false, false, nil,
      "Bad if statement: 2 conditions")
    checkParse(t, "if 1else elif 1end",
      false, false, nil,
      "Bad if statement: else before elif")
    checkParse(t, "if 1end end", true, false, nil,
      "Bad if statement: extra end")
end


function test_assn_stmt(t)
    io.write("Test Suite: assignment statements - simple expressions\n")

    checkParse(t, "abc=123", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"abc"},{NUMLITxVAL,"123"}}},
      "Assignment statement: NumericLiteral")
    checkParse(t, "abc=xyz", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR, "abc"},{SIMPLExVAR,"xyz"}}},
      "Assignment statement: identifier")
    checkParse(t, "abc[1]=xyz", true, true,
      {PROGRAMx,{ASSNxSTMT,{ARRAYxVAR,"abc",{NUMLITxVAL,"1"}},
        {SIMPLExVAR,"xyz"}}},
      "Assignment statement: array ref = ...")
    checkParse(t, "=123", true, false, nil,
      "Bad assignment statement: missing LHS")
    checkParse(t, "123=123", true, false, nil,
      "Bad assignment statement: LHS is NumericLiteral")
    checkParse(t, "else=123", true, false, nil,
      "Bad assignment statement: LHS is Keyword")
    checkParse(t, "abc 123", false, false, nil,
      "Bad assignment statement: missing assignment op")
    checkParse(t, "abc==123", false, false, nil,
      "Bad assignment statement: assignment op replaced by equality")
    checkParse(t, "abc=", false, true, nil,
      "Bad assignment statement: RHS is empty")
    checkParse(t, "abc=else", false, false, nil,
      "Bad assignment statement: RHS is Keyword")
    checkParse(t, "abc=1 2", true, false, nil,
      "Bad assignment statement: RHS is two NumericLiterals")
    checkParse(t, "abc=1 else", true, false, nil,
      "Bad assignment statement: followed by else")

    checkParse(t, "x=foo()", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{FUNCxCALL,"foo"}}},
      "Simple expression: call")
    checkParse(t, "x=()", false, false, nil,
      "Bad expression: empty parentheses")
    checkParse(t, "x=1&&2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: &&")
    checkParse(t, "x=1||2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: ||")
    checkParse(t, "x=1 + 2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary + (numbers with space)")
    checkParse(t, "x=1+2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary + (numbers without space)")
    checkParse(t, "x=a+2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary + (var+number)")
    checkParse(t, "x=1+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"b"}}}},
      "Simple expression: binary + (number+var)")
    checkParse(t, "x=a+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}},
      "Simple expression: binary + (vars)")
    checkParse(t, "x=1+", false, true, nil,
      "Bad expression: end with +")
    checkParse(t, "x=1 - 2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary - (numbers with space)")
    checkParse(t, "x=1-2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary - (numbers without space)")
    checkParse(t, "x=1-", false, true, nil,
      "Bad expression: end with -")
    checkParse(t, "x=1*2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: * (numbers)")
    checkParse(t, "x=a*2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"2"}}}},
      "Simple expression: * (var*number)")
    checkParse(t, "x=1*b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"b"}}}},
      "Simple expression: * (number*var)")
    checkParse(t, "x=a*b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}},
      "Simple expression: * (vars)")
    checkParse(t, "x=1*", false, true, nil,
      "Bad expression: end with *")
    checkParse(t, "x=1/2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: /")
    checkParse(t, "x=1/", false, true, nil,
      "Bad expression: end with /")
    checkParse(t, "x=1%2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: % #1")
    checkParse(t, "x=1%y", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"y"}}}},
      "Simple expression: % #2")
    checkParse(t, "x=x%1", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},
        {SIMPLExVAR,"x"},{NUMLITxVAL,"1"}}}},
      "Simple expression: % #3")
    checkParse(t, "x=1%", false, true, nil,
      "Bad expression: end with %")
    checkParse(t, "x=1==2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: == (numbers)")
    checkParse(t, "x=a==2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"2"}}}},
      "Simple expression: == (var==number)")
    checkParse(t, "x=1==b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"b"}}}},
      "Simple expression: == (number==var)")
    checkParse(t, "x=a==b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}},
      "Simple expression: == (vars)")
    checkParse(t, "x=1==", false, true, nil,
      "Bad expression: end with ==")
    checkParse(t, "x=1!=2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: !=")
    checkParse(t, "x=1!=", false, true, nil,
      "Bad expression: end with !=")
    checkParse(t, "x=1<2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: <")
    checkParse(t, "x=1<", false, true, nil,
      "Bad expression: end with <")
    checkParse(t, "x=1<=2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: <=")
    checkParse(t, "x=1<=", false, true, nil,
      "Bad expression: end with <=")
    checkParse(t, "x=1>2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: >")
    checkParse(t, "x=1>", false, true, nil,
      "Bad expression: end with >")
    checkParse(t, "x=1>=2", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: >=")
    checkParse(t, "x=+a", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{SIMPLExVAR,
        "a"}}}},
      "Simple expression: unary +")
    checkParse(t, "x=-a", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{SIMPLExVAR,
        "a"}}}},
      "Simple expression: unary -")
    checkParse(t, "x=1>=", false, true, nil,
      "Bad expression: end with >=")
    checkParse(t, "x=(1)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{NUMLITxVAL,"1"}}},
      "Simple expression: parens (number)")
    checkParse(t, "x=(a)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{SIMPLExVAR,"a"}}},
      "Simple expression: parens (var)")
    checkParse(t, "x=a[1]", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{ARRAYxVAR,"a",
        {NUMLITxVAL,"1"}}}},
      "Simple expression: array ref")
    checkParse(t, "x=(1", false, true, nil,
      "Bad expression: no closing paren")
    checkParse(t, "x=a[1", false, true, nil,
      "Bad expression: no closing bracket")
    checkParse(t, "x=a 1]", true, false, nil,
      "Bad expression: no opening bracket")
    checkParse(t, "x=a[]", false, false, nil,
      "Bad expression: empty brackets")
    checkParse(t, "x=(x)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{SIMPLExVAR,"x"}}},
      "Simple expression: var in parens on RHS")
    checkParse(t, "(x)=x", true, false, nil,
      "Bad expression: var in parens on LHS")
    checkParse(t, "x[1]=(x[1])", true, true,
      {PROGRAMx,{ASSNxSTMT,{ARRAYxVAR,"x",{NUMLITxVAL,"1"}},
        {ARRAYxVAR,"x",{NUMLITxVAL,"1"}}}},
      "Simple expression: array ref in parens on RHS")
    checkParse(t, "(x[1])=x[1]", true, false, nil,
      "Bad expression: array ref in parens on LHS")

    checkParse(t, "x=f()()", true, false, nil,
      "Bad expression: call function call")
    checkParse(t, "x=3()", true, false, nil,
      "Bad expression: call number")
    checkParse(t, "x=(x)()", true, false, nil,
      "Bad expression: call with parentheses around ID")
end


function test_return_stmt(t)
    io.write("Test Suite: return statements\n")

    checkParse(t, "return x", true, true,
      {PROGRAMx,{RETURNxSTMT,{SIMPLExVAR,"x"}}},
      "return statement: variable")
    checkParse(t, "return -34", true, true,
      {PROGRAMx,{RETURNxSTMT,{{UNxOP,"-"},{NUMLITxVAL,"34"}}}},
      "return statement: number")
    checkParse(t, "return", false, true, nil,
      "return statement: no argument")
    checkParse(t, "return(x)", true, true,
      {PROGRAMx,{RETURNxSTMT,{SIMPLExVAR,"x"}}},
      "return statement: variable in parentheses")
    checkParse(t, "return(3+1<=4*(x-y))", true, true,
      {PROGRAMx,{RETURNxSTMT,{{BINxOP,"<="},{{BINxOP,"+"},{NUMLITxVAL,
        "3"},{NUMLITxVAL,"1"}},{{BINxOP,"*"},{NUMLITxVAL,"4"},
        {{BINxOP,"-"},{SIMPLExVAR,"x"},{SIMPLExVAR,"y"}}}}}},
      "return statement: fancier expression")
end


function test_print_stmt_with_expr(t)
    io.write("Test Suite: print/println statements"
             .." - with expressions\n")

    checkParse(t, "print(x)", true, true,
      {PROGRAMx,{PRINTxSTMT,{SIMPLExVAR,"x"}}},
      "print statement: variable")
    checkParse(t, "print(chr(65))", true, true,
      {PROGRAMx,{PRINTxSTMT,{CHRxCALL,{NUMLITxVAL,"65"}}}},
      "print statement: char call")
    checkParse(t, "print(chr(1),chr(2),chr(3))", true, true,
      {PROGRAMx,{PRINTxSTMT,{CHRxCALL,{NUMLITxVAL,"1"}},{CHRxCALL,
        {NUMLITxVAL,"2"}},{CHRxCALL,{NUMLITxVAL,"3"}}}},
      "print statement: multiple char calls")
    checkParse(t, "print(\"a b\", chr(1+2), a*4)", true, true,
      {PROGRAMx,{PRINTxSTMT,{STRLITxOUT,"\"a b\""},{CHRxCALL,
        {{BINxOP,"+"},{NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"4"}}}},
      "print statement: string literal, char call, expression #1")
    checkParse(t, "print(chr(1-2), \"a b\", 4/a)", true, true,
      {PROGRAMx,{PRINTxSTMT,{CHRxCALL,{{BINxOP,"-"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}}},{STRLITxOUT,"\"a b\""},{{BINxOP,"/"},
        {NUMLITxVAL,"4"},{SIMPLExVAR,"a"}}}},
      "print statement: string literal, char call, expression #2")
    checkParse(t, "print(a+xyz_3[b*(c==d-f)]%g<=h)", true, true,
      {PROGRAMx,{PRINTxSTMT,{{BINxOP,"<="},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{ARRAYxVAR,"xyz_3",{{BINxOP,"*"},{SIMPLExVAR,
        "b"},{{BINxOP,"=="},{SIMPLExVAR,"c"},{{BINxOP,"-"},{SIMPLExVAR,
        "d"},{SIMPLExVAR,"f"}}}}},{SIMPLExVAR,"g"}}},{SIMPLExVAR,
        "h"}}}},
      "print statement: complex expression")

    checkParse(t, "println(x)", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{SIMPLExVAR,"x"}}},
      "println statement: variable")
    checkParse(t, "println(chr(65))", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{CHRxCALL,{NUMLITxVAL,"65"}}}},
      "println statement: char call")
    checkParse(t, "println(chr(1),chr(2),chr(3))", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{CHRxCALL,{NUMLITxVAL,"1"}},{CHRxCALL,
        {NUMLITxVAL,"2"}},{CHRxCALL,{NUMLITxVAL,"3"}}}},
      "println statement: multiple char calls")
    checkParse(t, "println(\"a b\", chr(1+2), a*4)", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{STRLITxOUT,"\"a b\""},{CHRxCALL,
        {{BINxOP,"+"},{NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"4"}}}},
      "println statement: string literal, char call, expression #1")
    checkParse(t, "println(chr(1-2), \"a b\", 4/a)", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{CHRxCALL,{{BINxOP,"-"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}}},{STRLITxOUT,"\"a b\""},{{BINxOP,"/"},
        {NUMLITxVAL,"4"},{SIMPLExVAR,"a"}}}},
      "println statement: string literal, char call, expression #2")
    checkParse(t, "println(a+xyz_3[b*(c==d-f)]%g<=h)", true, true,
      {PROGRAMx,{PRINTLNxSTMT,{{BINxOP,"<="},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{ARRAYxVAR,"xyz_3",{{BINxOP,"*"},{SIMPLExVAR,
        "b"},{{BINxOP,"=="},{SIMPLExVAR,"c"},{{BINxOP,"-"},{SIMPLExVAR,
        "d"},{SIMPLExVAR,"f"}}}}},{SIMPLExVAR,"g"}}},{SIMPLExVAR,
        "h"}}}},
      "println statement: complex expression")
end


function test_func_def_with_expr(t)
    io.write("Test Suite: function definitions - with expressions\n")

    checkParse(t, "func q()print(abc+3)end", true, true,
      {PROGRAMx,{FUNCxDEF,"q",{PROGRAMx,{PRINTxSTMT,{{BINxOP,"+"},
        {SIMPLExVAR,"abc"},{NUMLITxVAL,"3"}}}}}},
      "function definition: with print expr")
    checkParse(t, "func qq()print(a+x[b*(c==d-f)]%g<=h)end",
      true, true,
      {PROGRAMx,{FUNCxDEF,"qq",{PROGRAMx,{PRINTxSTMT,{{BINxOP,"<="},
        {{BINxOP,"+"},{SIMPLExVAR,"a"},{{BINxOP,"%"},{ARRAYxVAR,"x",
        {{BINxOP,"*"},{SIMPLExVAR,"b"},{{BINxOP,"=="},{SIMPLExVAR,"c"},
        {{BINxOP,"-"},{SIMPLExVAR,"d"},{SIMPLExVAR,"f"}}}}},{SIMPLExVAR,
        "g"}}},{SIMPLExVAR,"h"}}}}}},
      "function definition: complex expression")
end


function test_expr_prec_assoc(t)
    io.write("Test Suite: expressions - precedence & associativity\n")

    checkParse(t, "x=1&& 2&& 3&& 4&& 5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},{{BINxOP,
        "&&"},{{BINxOP, "&&"},{{BINxOP,"&&"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator '&&' is left-associative")
    checkParse(t, "x=1 || 2 || 3 || 4 || 5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{{BINxOP,
        "||"},{{BINxOP, "||"},{{BINxOP,"||"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator '||' is left-associative")
    checkParse(t, "x=1+2+3+4+5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "+"},{{BINxOP, "+"},{{BINxOP,"+"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Binary operator + is left-associative")
    checkParse(t, "x=1-2-3-4-5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "-"},{{BINxOP, "-"},{{BINxOP,"-"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Binary operator - is left-associative")
    checkParse(t, "x=1*2*3*4*5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "*"},{{BINxOP, "*"},{{BINxOP,"*"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator * is left-associative")
    checkParse(t, "x=1/2/3/4/5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "/"},{{BINxOP, "/"},{{BINxOP,"/"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator / is left-associative")
    checkParse(t, "x=1%2%3%4%5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "%"},{{BINxOP, "%"},{{BINxOP,"%"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator % is left-associative")
    checkParse(t, "x=1==2==3==4==5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "=="},{{BINxOP, "=="},{{BINxOP,"=="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator == is left-associative")
    checkParse(t, "x=1!=2!=3!=4!=5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{{BINxOP,
        "!="},{{BINxOP, "!="},{{BINxOP,"!="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator != is left-associative")
    checkParse(t, "x=1<2<3<4<5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{BINxOP,
        "<"},{{BINxOP, "<"},{{BINxOP,"<"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator < is left-associative")
    checkParse(t, "x=1<=2<=3<=4<=5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},{{BINxOP,
        "<="},{{BINxOP, "<="},{{BINxOP,"<="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator <= is left-associative")
    checkParse(t, "x=1>2>3>4>5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        ">"},{{BINxOP, ">"},{{BINxOP,">"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator > is left-associative")
    checkParse(t, "x=1>=2>=3>=4>=5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{BINxOP,
        ">="},{{BINxOP, ">="},{{BINxOP,">="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator >= is left-associative")

    checkParse(t, "x=! ! ! ! a", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"!"},
        {{UNxOP,"!"},{{UNxOP,"!"},{{UNxOP,"!"},
        {SIMPLExVAR,"a"}}}}}}},
      "Operator ! is right-associative")
    checkParse(t, "x=++++a", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{UNxOP,"+"},
        {{UNxOP,"+"},{{UNxOP,"+"},{SIMPLExVAR,"a"}}}}}}},
      "Unary operator + is right-associative")
    checkParse(t, "x=- - - -a", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{UNxOP,"-"},
        {{UNxOP,"-"},{{UNxOP,"-"},{SIMPLExVAR,"a"}}}}}}},
      "Unary operator - is right-associative")

    checkParse(t, "x=a && b || c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{{BINxOP,
        "&&"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: &&, ||")
    checkParse(t, "x=a && b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"=="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, ==")
    checkParse(t, "x=a && b!=c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"!="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, !=")
    checkParse(t, "x=a && b<c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"<"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, <")
    checkParse(t, "x=a && b<=c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"<="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, <=")
    checkParse(t, "x=a && b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
      {SIMPLExVAR,"a"},{{BINxOP,">"},{SIMPLExVAR,"b"},
      {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, >")
    checkParse(t, "x=a && b>=c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,">="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, >=")
    checkParse(t, "x=a && b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, binary +")
    checkParse(t, "x=a && b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, binary -")
    checkParse(t, "x=a && b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, *")
    checkParse(t, "x=a && b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, /")
    checkParse(t, "x=a && b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},
        {SIMPLExVAR,"a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: &&, %")

    checkParse(t, "x=a || b && c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},{{BINxOP,
        "||"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: ||, &&")
    checkParse(t, "x=a || b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"=="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, ==")
    checkParse(t, "x=a || b!=c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"!="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: || , !=")
    checkParse(t, "x=a || b<c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"<"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, <")
    checkParse(t, "x=a || b<=c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"<="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, <=")
    checkParse(t, "x=a || b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,">"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, >")
    checkParse(t, "x=a || b>=c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,">="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, >=")
    checkParse(t, "x=a || b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, binary +")
    checkParse(t, "x=a || b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, binary -")
    checkParse(t, "x=a || b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, *")
    checkParse(t, "x=a || b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, /")
    checkParse(t, "x=a || b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ||, %")

    checkParse(t, "x=a==b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "=="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: ==, >")
    checkParse(t, "x=a==b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, binary +")
    checkParse(t, "x=a==b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, binary -")
    checkParse(t, "x=a==b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, *")
    checkParse(t, "x=a==b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, /")
    checkParse(t, "x=a==b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, %")

    checkParse(t, "x=a>b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        ">"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: >, ==")
    checkParse(t, "x=a>b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, binary +")
    checkParse(t, "x=a>b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, binary -")
    checkParse(t, "x=a>b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, *")
    checkParse(t, "x=a>b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, /")
    checkParse(t, "x=a>b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, %")

    checkParse(t, "x=a+b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary +, ==")
    checkParse(t, "x=a+b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary +, >")
    checkParse(t, "x=a+b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary +, binary -")
    checkParse(t, "x=a+b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary +, *")
    checkParse(t, "x=a+b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary +, /")
    checkParse(t, "x=a+b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary +, %")

    checkParse(t, "x=a-b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary -, ==")
    checkParse(t, "x=a-b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary -, >")
    checkParse(t, "x=a-b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary -, binary +")
    checkParse(t, "x=a-b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary -, *")
    checkParse(t, "x=a-b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary -, /")
    checkParse(t, "x=a-b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary -, %")

    checkParse(t, "x=a*b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, ==")
    checkParse(t, "x=a*b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, >")
    checkParse(t, "x=a*b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, binary +")
    checkParse(t, "x=a*b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, binary -")
    checkParse(t, "x=a*b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, /")
    checkParse(t, "x=a*b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, %")

    checkParse(t, "x=a/b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, ==")
    checkParse(t, "x=a/b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, >")
    checkParse(t, "x=a/b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, binary +")
    checkParse(t, "x=a/b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, binary -")
    checkParse(t, "x=a/b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, *")
    checkParse(t, "x=a/b%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, %")

    checkParse(t, "x=a%b==c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, ==")
    checkParse(t, "x=a%b>c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, >")
    checkParse(t, "x=a%b+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, binary +")
    checkParse(t, "x=a%b-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, binary -")
    checkParse(t, "x=a%b*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, *")
    checkParse(t, "x=a%b/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, /")

    checkParse(t, "x=! a && b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, &&")
    checkParse(t, "x=! a || b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, ||")
    checkParse(t, "x=! a==b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, ==")
    checkParse(t, "x=! a!=b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, !=")
    checkParse(t, "x=! a<b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, <")
    checkParse(t, "x=! a<=b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, <=")
    checkParse(t, "x=! a>b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, >")
    checkParse(t, "x=! a>=b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, >=")
    checkParse(t, "x=! a+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, binary +")
    checkParse(t, "x=! a-b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, binary -")
    checkParse(t, "x=! a*b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, *")
    checkParse(t, "x=! a/b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, /")
    checkParse(t, "x=! a%b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{UNxOP,
        "!"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: !, %")
    checkParse(t, "x=a!=+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: !=, unary +")
    checkParse(t, "x=-a<c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{UNxOP,
        "-"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary -, <")
    checkParse(t, "x=a++b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary +, unary +")
    checkParse(t, "x=a+-b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary +, unary -")
    checkParse(t, "x=+a+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary +, binary +, *")
    checkParse(t, "x=-a+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{UNxOP,"-"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary -, binary +")
    checkParse(t, "x=a-+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary -, unary +")
    checkParse(t, "x=a- -b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary -, unary -")
    checkParse(t, "x=+a-b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary +, binary -, *")
    checkParse(t, "x=-a-b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{UNxOP,"-"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary -, binary -")
    checkParse(t, "x=a*-b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: *, unary -")
    checkParse(t, "x=+a*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary +, *")
    checkParse(t, "x=a/+b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: /, unary +")
    checkParse(t, "x=-a/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{UNxOP,"-"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary -, /")
    checkParse(t, "x=a%-b", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: %, unary -")
    checkParse(t, "x=+a%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary +, %")

    checkParse(t, "x=1 && (2 && 3 && 4) && 5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"&&"},{{BINxOP,
        "&&"},{NUMLITxVAL,"1"},{{BINxOP,"&&"},{{BINxOP,"&&"},
          {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
          {NUMLITxVAL,"5"}}}},
      "Associativity override: &&")
    checkParse(t, "x=1 || (2 || 3 || 4) || 5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"||"},{{BINxOP,
        "||"},{NUMLITxVAL,"1"},{{BINxOP,"||"},{{BINxOP,"||"},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: ||")
    checkParse(t, "x=1==(2==3==4)==5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "=="},{NUMLITxVAL,"1"},{{BINxOP,"=="},{{BINxOP,"=="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: ==")
    checkParse(t, "x=1!=(2!=3!=4)!=5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{{BINxOP,
        "!="},{NUMLITxVAL,"1"},{{BINxOP,"!="},{{BINxOP,"!="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: !=")
    checkParse(t, "x=1<(2<3<4)<5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{BINxOP,
        "<"},{NUMLITxVAL,"1"},{{BINxOP,"<"},{{BINxOP,"<"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: <")
    checkParse(t, "x=1<=(2<=3<=4)<=5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},{{BINxOP,
        "<="},{NUMLITxVAL,"1"},{{BINxOP,"<="},{{BINxOP,"<="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: <=")
    checkParse(t, "x=1>(2>3>4)>5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        ">"},{NUMLITxVAL,"1"},{{BINxOP,">"},{{BINxOP,">"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: >")
    checkParse(t, "x=1>=(2>=3>=4)>=5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{BINxOP,
        ">="},{NUMLITxVAL,"1"},{{BINxOP,">="},{{BINxOP,">="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: >=")
    checkParse(t, "x=1+(2+3+4)+5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {{BINxOP,"+"},{NUMLITxVAL,"1"},{{BINxOP,"+"},{{BINxOP,"+"},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: binary +")
    checkParse(t, "x=1-(2-3-4)-5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "-"},{NUMLITxVAL,"1"},{{BINxOP,"-"},{{BINxOP,"-"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: binary -")
    checkParse(t, "x=1*(2*3*4)*5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "*"},{NUMLITxVAL,"1"},{{BINxOP,"*"},{{BINxOP,"*"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: *")
    checkParse(t, "x=1/(2/3/4)/5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "/"},{NUMLITxVAL,"1"},{{BINxOP,"/"},{{BINxOP,"/"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: /")
    checkParse(t, "x=1%(2%3%4)%5", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "%"},{NUMLITxVAL,"1"},{{BINxOP,"%"},{{BINxOP,"%"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: %")

    checkParse(t, "x=(a==b)+c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "=="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: ==, binary +")
    checkParse(t, "x=(a!=b)-c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "!="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: !=, binary -")
    checkParse(t, "x=(a<b)*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "<"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: <, *")
    checkParse(t, "x=(a<=b)/c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "<="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: <=, /")
    checkParse(t, "x=(a>b)%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        ">"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: >, %")
    checkParse(t, "x=a+(b>=c)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
       "a"},{{BINxOP,">="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: binary +, >=")
    checkParse(t, "x=(a-b)*c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: binary -, *")
    checkParse(t, "x=(a+b)%c", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: binary +, %")
    checkParse(t, "x=a*(b==c)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{SIMPLExVAR,
        "a"},{{BINxOP,"=="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: *, ==")
    checkParse(t, "x=a/(b!=c)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{SIMPLExVAR,
        "a"},{{BINxOP,"!="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: /, !=")
    checkParse(t, "x=a%(b<c)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{SIMPLExVAR,
        "a"},{{BINxOP,"<"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: %, <")

    checkParse(t, "x=+(a<=b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,
        "<="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, <=")
    checkParse(t, "x=-(a>b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{BINxOP,">"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary -, >")
    checkParse(t, "x=+(a+b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,"+"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, binary +")
    checkParse(t, "x=-(a-b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{BINxOP,"-"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary -, binary -")
    checkParse(t, "x=+(a*b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, *")
    checkParse(t, "x=-(a/b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{BINxOP,"/"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary -, /")
    checkParse(t, "x=+(a%b)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,"%"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, %")
end


function test_readnum_rnd(t)
    io.write("Test Suite: readnum & rnd\n")

    checkParse(t, "x=readnum()", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{READNUMxCALL}}},
      "Assignment with readnum")
    checkParse(t, "x=readnum(y)", false, false, nil,
      "Assignment with readnum - nonempty parens")
    checkParse(t, "x=readnum", false, true, nil,
      "Assignment with readnum - no parens")
    checkParse(t, "x=readnum)", false, false, nil,
      "Assignment with readnum - no left paren")
    checkParse(t, "x=readnum(", false, true, nil,
      "Assignment with readnum - no right paren")
    checkParse(t, "readnum()", true, false, nil,
      "readnum as statement")
    checkParse(t, "x=readnum()y=readnum()", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{READNUMxCALL}},{ASSNxSTMT,
        {SIMPLExVAR,"y"},{READNUMxCALL}}},
      "Multiple assignments with readnum")

    checkParse(t, "x=rnd(1)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{RNDxCALL,
      {NUMLITxVAL,"1"}}}},
      "Assignment with rnd")
    checkParse(t, "x=rnd()", false, false, nil,
      "Assignment with rnd - empty parens")
    checkParse(t, "x=rnd", false, true, nil,
      "Assignment with rnd - no parens")
    checkParse(t, "x=rnd 1)", false, false, nil,
      "Assignment with rnd - no left paren")
    checkParse(t, "x=rnd(1", false, true, nil,
      "Assignment with rnd - no right paren")
    checkParse(t, "rnd(1)", true, false, nil,
      "readnum as statement")
    checkParse(t, "x=rnd(a)y=rnd(0)", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{RNDxCALL,
        {SIMPLExVAR,"a"}}},{ASSNxSTMT,{SIMPLExVAR,"y"},{RNDxCALL,
        {NUMLITxVAL,"0"}}}},
      "Multiple assignments with rnd")
end


function test_array_item(t)
    io.write("Test Suite: array items\n")

    checkParse(t, "a[1] = 2", true, true,
      {PROGRAMx,{ASSNxSTMT,{ARRAYxVAR,"a",{NUMLITxVAL,"1"}},
        {NUMLITxVAL,"2"}}},
      "Array item in LHS of assignment")
    checkParse(t, "a = b[2]", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"a"},{ARRAYxVAR,"b",{NUMLITxVAL,
        "2"}}}},
      "Array item in RHS of assignment")
    checkParse(t, "abc[5*2+a]=bcd[5<=1/4]/cde[! 0>x]",
      true, true,
      {PROGRAMx,{ASSNxSTMT,{ARRAYxVAR,"abc",{{BINxOP,"+"},{{BINxOP,
        "*"},{NUMLITxVAL,"5"},{NUMLITxVAL,"2"}},{SIMPLExVAR,"a"}}},
        {{BINxOP,"/"},{ARRAYxVAR,"bcd",{{BINxOP,"<="},{NUMLITxVAL,"5"},
        {{BINxOP,"/"},{NUMLITxVAL,"1"},{NUMLITxVAL,"4"}}}},
        {ARRAYxVAR,"cde",{{BINxOP,">"},{{UNxOP,"!"},{NUMLITxVAL,
        "0"}},{SIMPLExVAR,"x"}}}}}},
      "Array items: fancier")
end


function test_expr_complex(t)
    io.write("Test Suite: complex expressions\n")

    checkParse(t, "x=((((((((((((((((((((((((((((((((((((((((a)))"
      ..")))))))))))))))))))))))))))))))))))))", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{SIMPLExVAR,"a"}}},
      "Complex expression: many parens")
    checkParse(t, "x=(((((((((((((((((((((((((((((((((((((((a))))"
      .."))))))))))))))))))))))))))))))))))))", true, false, nil,
      "Bad complex expression: many parens, mismatch #1")
    checkParse(t, "x=((((((((((((((((((((((((((((((((((((((((a)))"
      .."))))))))))))))))))))))))))))))))))))", false, true, nil,
      "Bad complex expression: many parens, mismatch #2")
    checkParse(t, "x=a==b+c[x-y[2]]*+d!=e-f/-g<h+i%+j", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},
        {{BINxOP,"!="},{{BINxOP,"=="},{SIMPLExVAR,"a"},{{BINxOP,"+"},
        {SIMPLExVAR,"b"},{{BINxOP,"*"},{ARRAYxVAR,"c",{{BINxOP,"-"},
        {SIMPLExVAR,"x"},{ARRAYxVAR,"y",{NUMLITxVAL,"2"}}}},{{UNxOP,
        "+"},{SIMPLExVAR,"d"}}}}},{{BINxOP,"-"},{SIMPLExVAR,"e"},
        {{BINxOP,"/"},{SIMPLExVAR,"f"},{{UNxOP,"-"},{SIMPLExVAR,
        "g"}}}}},{{BINxOP,"+"},{SIMPLExVAR,"h"},{{BINxOP,"%"},
        {SIMPLExVAR,"i"},{{UNxOP,"+"},{SIMPLExVAR,"j"}}}}}}},
      "Complex expression: misc #1")
    checkParse(t, "x=a==b+(c*+(d!=e[2*z]-f/-g)<h+i)%+j", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{{BINxOP,"%"},{{BINxOP,"<"},
        {{BINxOP,"*"},{SIMPLExVAR,"c"},{{UNxOP,"+"},{{BINxOP,"!="},
        {SIMPLExVAR,"d"},{{BINxOP,"-"},{ARRAYxVAR,"e",{{BINxOP,"*"},
        {NUMLITxVAL,"2"},{SIMPLExVAR,"z"}}},{{BINxOP,"/"},{SIMPLExVAR,
        "f"},{{UNxOP,"-"},{SIMPLExVAR,"g"}}}}}}},{{BINxOP,"+"},
        {SIMPLExVAR,"h"},{SIMPLExVAR,"i"}}},{{UNxOP,"+"},{SIMPLExVAR,
        "j"}}}}}}},
      "Complex expression: misc #2")
    checkParse(t, "x=a[x[y[z]]%4]++b*c<=d- -e/f>g+-h%i>=j", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{BINxOP,
        ">"},{{BINxOP,"<="},{{BINxOP,"+"},{ARRAYxVAR,"a",{{BINxOP,"%"},
        {ARRAYxVAR,"x",{ARRAYxVAR,"y",{SIMPLExVAR,"z"}}},{NUMLITxVAL,
        "4"}}},{{BINxOP,"*"},{{UNxOP,"+"},{SIMPLExVAR,"b"}},{SIMPLExVAR,
        "c"}}},{{BINxOP,"-"},{SIMPLExVAR,"d"},{{BINxOP,"/"},
        {{UNxOP,"-"},{SIMPLExVAR,"e"}},{SIMPLExVAR,"f"}}}},
        {{BINxOP,"+"},{SIMPLExVAR,"g"},{{BINxOP,"%"},{{UNxOP,"-"},
        {SIMPLExVAR,"h"}},{SIMPLExVAR,"i"}}}},{SIMPLExVAR,"j"}}}},
      "Complex expression: misc #3")
    checkParse(t, "x=a++(b*c<=d)- -e/(f>g+-h%i)>=j[-z]", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},
        {{BINxOP,"-"},{{BINxOP,"+"},{SIMPLExVAR,"a"},{{UNxOP,"+"},
        {{BINxOP,"<="},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}},
        {SIMPLExVAR,"d"}}}},{{BINxOP,"/"},{{UNxOP,"-"},
        {SIMPLExVAR,"e"}},{{BINxOP,">"},{SIMPLExVAR,"f"},{{BINxOP,"+"},
        {SIMPLExVAR,"g"},{{BINxOP,"%"},{{UNxOP,"-"},{SIMPLExVAR,"h"}},
        {SIMPLExVAR,"i"}}}}}},{ARRAYxVAR,"j",{{UNxOP,"-"},
        {SIMPLExVAR,"z"}}}}}},
      "Complex expression: misc #4")
    checkParse(t,
    "print(rnd(readnum()==15e3),rnd(rnd(rnd(readnum()))))",
      true, true,
     {PROGRAMx,{PRINTxSTMT,{RNDxCALL,{{BINxOP,"=="},{READNUMxCALL},
       {NUMLITxVAL,"15e3"}}},{RNDxCALL,{RNDxCALL,{RNDxCALL,
       {READNUMxCALL}}}}}},
     "Complex expression with print")
    checkParse(t, "x=a==b+c*+d!=e-/-g<h+i%+j",
      false, false, nil,
      "Bad complex expression: misc #1")
    checkParse(t, "x=a==b+(c*+(d!=e-f/-g)<h+i)%+",
      false, true, nil,
      "Bad complex expression: misc #2")
    checkParse(t, "x=a++b*c<=d- -e x/f>g+-h%i>=j",
      false, false, nil,
      "Bad complex expression: misc #3")
    checkParse(t, "x=a++b*c<=d)- -e/(f>g+-h%i)>=j",
      true, false, nil,
      "Bad complex expression: misc #4")

    checkParse(t, "x=((a[(b[c[(d[((e[f]))])]])]))", true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"x"},{ARRAYxVAR,"a",
        {ARRAYxVAR,"b",{ARRAYxVAR,"c",{ARRAYxVAR,"d",{ARRAYxVAR,"e",
        {SIMPLExVAR,"f"}}}}}}}},
      "Complex expression: many parens/brackets")
    checkParse(t, "x=((a[(b[c[(d[((e[f]))]])])]))", false, false, nil,
      "Bad complex expression: mismatched parens/brackets")

    checkParse(t, "while(a+b)%d+a()!=1print()end", true, true,
      {PROGRAMx,{WHILExLOOP,{{BINxOP,"!="},{{BINxOP,"+"},
        {{BINxOP,"%"},{{BINxOP,"+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},
        {SIMPLExVAR,"d"}},{FUNCxCALL,"a"}},{NUMLITxVAL,"1"}},
        {PROGRAMx,{PRINTxSTMT}}}},
      "While loop with complex expression")
    checkParse(t, "if(6e+5==1/((q()))+-+-+-0)a=3elif"
      .."(3+4+5)x=5else r=7end", true, true,
      {PROGRAMx,{IFxSTMT,{{BINxOP,"=="},{NUMLITxVAL,"6e+5"},{{BINxOP,
        "+"},{{BINxOP,"/"},{NUMLITxVAL,"1"},{FUNCxCALL,"q"}},
        {{UNxOP,"-"},{{UNxOP,"+"},{{UNxOP,"-"},{{UNxOP,"+"},{{UNxOP,
        "-"},{NUMLITxVAL,"0"}}}}}}}},{PROGRAMx,{ASSNxSTMT,
        {SIMPLExVAR,"a"},{NUMLITxVAL,"3"}}},{{BINxOP,"+"},{{BINxOP,"+"},
        {NUMLITxVAL,"3"},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}},{PROGRAMx,
        {ASSNxSTMT,{SIMPLExVAR,"x"},{NUMLITxVAL,"5"}}},{PROGRAMx,
        {ASSNxSTMT,{SIMPLExVAR,"r"},{NUMLITxVAL,"7"}}}}},
      "If statement with complex expression")
end


function test_prog(t)
    io.write("Test Suite: complete programs\n")

    -- Example #1 from Assignment 4 description
    checkParse(t,
      [[#!
        # Fulmar Example #1
        # Glenn G. Chappell
        # 2025-02-18
        nn = 3
        println(nn+4)
      ]], true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"nn"},{NUMLITxVAL,"3"}},
        {PRINTLNxSTMT,{{BINxOP,"+"},{SIMPLExVAR,"nn"},
        {NUMLITxVAL,"4"}}}},
      "Program: Example #1 from Assignment 4 description")

    -- Fibonacci Example
    checkParse(t,
      [[#!
      # fibo.fmar
      # Glenn G. Chappell
      # 2025-01-10
      #
      # For CS 331 Spring 2025
      # Compute Fibonacci Numbers


      # The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
      # F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


      # fibo (param in variable n)
      # Return Fibonacci number F(n).
      func fibo()
          # Variables holding consecutive Fibonacci numbers
          currfib = 0
          nextfib = 1

          # Advance currfib, nextfib as many times as needed
          i = 0  # Loop counter
          while i < n
              tmp = currfib + nextfib
              currfib = nextfib
              nextfib = tmp
              i = i+1
          end
          return currfib
      end


      # Main program
      # Print some Fibonacci numbers, nicely formatted.
      how_many_to_print = 20

      println("Fibonacci Numbers")

      j = 0  # Loop counter
      while j < how_many_to_print
          n = j  # Set param for fibo
          ff = fibo()
          println("F(", j, ") = ", ff)
          j = j+1
      end
      ]], true, true,
      {PROGRAMx,{FUNCxDEF,"fibo",{PROGRAMx,{ASSNxSTMT,
      {SIMPLExVAR,"currfib"},{NUMLITxVAL,"0"}},{ASSNxSTMT,
      {SIMPLExVAR,"nextfib"},{NUMLITxVAL,"1"}},{ASSNxSTMT,
      {SIMPLExVAR,"i"},{NUMLITxVAL,"0"}},{WHILExLOOP,{{BINxOP,"<"},
      {SIMPLExVAR,"i"},{SIMPLExVAR,"n"}},{PROGRAMx,{ASSNxSTMT,
      {SIMPLExVAR,"tmp"},{{BINxOP,"+"},{SIMPLExVAR,"currfib"},
      {SIMPLExVAR,"nextfib"}}},{ASSNxSTMT,{SIMPLExVAR,"currfib"},
      {SIMPLExVAR,"nextfib"}},{ASSNxSTMT,{SIMPLExVAR,"nextfib"},
      {SIMPLExVAR,"tmp"}},{ASSNxSTMT,{SIMPLExVAR,"i"},{{BINxOP,"+"},
      {SIMPLExVAR,"i"},{NUMLITxVAL,"1"}}}}},{RETURNxSTMT,
      {SIMPLExVAR,"currfib"}}}},{ASSNxSTMT,
      {SIMPLExVAR,"how_many_to_print"},{NUMLITxVAL,"20"}},{PRINTLNxSTMT,
      {STRLITxOUT,"\"Fibonacci Numbers\""}},{ASSNxSTMT,
      {SIMPLExVAR,"j"},{NUMLITxVAL,"0"}},{WHILExLOOP,{{BINxOP,"<"},
      {SIMPLExVAR,"j"},{SIMPLExVAR,"how_many_to_print"}},{PROGRAMx,
      {ASSNxSTMT,{SIMPLExVAR,"n"},{SIMPLExVAR,"j"}},{ASSNxSTMT,
      {SIMPLExVAR,"ff"},{FUNCxCALL,"fibo"}},{PRINTLNxSTMT,
      {STRLITxOUT,"\"F(\""},{SIMPLExVAR,"j"},{STRLITxOUT,"\") = \""},
      {SIMPLExVAR,"ff"}},{ASSNxSTMT,{SIMPLExVAR,"j"},
      {{BINxOP,"+"},{SIMPLExVAR,"j"},{NUMLITxVAL,"1"}}}}}},
      "Program: Fibonacci Example")

    -- Input number, print its square
    checkParse(t,
      [[#!
        print("Type a number: ")
        a = readnum()
        println()
        println()
        print("You typed: ")
        println(a)
        print("Its square is: ")
        println(a*a)
        println()
      ]], true, true,
      {PROGRAMx,{PRINTxSTMT,{STRLITxOUT,"\"Type a number: \""}},
        {ASSNxSTMT,{SIMPLExVAR,"a"},{READNUMxCALL}},{PRINTLNxSTMT},
        {PRINTLNxSTMT},{PRINTxSTMT,
        {STRLITxOUT,"\"You typed: \""}},{PRINTLNxSTMT,{SIMPLExVAR,"a"}},
        {PRINTxSTMT,
        {STRLITxOUT,"\"Its square is: \""}},{PRINTLNxSTMT,{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"a"}}},{PRINTLNxSTMT}},
      "Program: Input number, print its square")

    -- Input numbers, stop at sentinel, print even/odd
    checkParse(t,
      [[#!
        continue = 1
        while continue
            print("Type a number (0 to end): ")
            n = readnum()
            println()
            println()
            if n == 0
                continue = 0
            else
                print("The number ", n, " is ")
                if n % 2 == 0
                    print("even")
                else
                    print("odd")
                end
                println()
                println()
            end
        end
        println("Bye!")
        println()
      ]], true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"continue"},
      {NUMLITxVAL,"1"}},{WHILExLOOP,{SIMPLExVAR,"continue"},
      {PROGRAMx,{PRINTxSTMT,
      {STRLITxOUT,"\"Type a number (0 to end): \""}},{ASSNxSTMT,
      {SIMPLExVAR,"n"},{READNUMxCALL}},{PRINTLNxSTMT},{PRINTLNxSTMT},
      {IFxSTMT,{{BINxOP,"=="},{SIMPLExVAR,"n"},{NUMLITxVAL,"0"}},
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"continue"},
      {NUMLITxVAL,"0"}}},{PROGRAMx,{PRINTxSTMT,
      {STRLITxOUT,"\"The number \""},{SIMPLExVAR,"n"},
      {STRLITxOUT,"\" is \""}},{IFxSTMT,{{BINxOP,"=="},{{BINxOP,"%"},
      {SIMPLExVAR,"n"},{NUMLITxVAL,"2"}},{NUMLITxVAL,"0"}},{PROGRAMx,
      {PRINTxSTMT,{STRLITxOUT,"\"even\""}}},{PROGRAMx,{PRINTxSTMT,
      {STRLITxOUT,"\"odd\""}}}},{PRINTLNxSTMT},{PRINTLNxSTMT}}}}},
      {PRINTLNxSTMT,{STRLITxOUT,"\"Bye!\""}},{PRINTLNxSTMT}},
      "Program: Input numbers, stop at sentinel, print even/odd")

    -- Input numbers, print them in reverse order
    checkParse(t,
      [[#!
        howMany = 5  # How many numbers to input
        println("I will ask you for ", howMany, " numbers.")
        println("Then I will print them in reverse order.")
        println()
        i = 1
        while i <= howMany  # Input loop
            print("Type value #", i, ": ")
            v[i] = readnum()
            println()
            println()
            i = i+1
        end
        println("------------------------------------")
        println()
        println("Here are the values, in reverse order:")
        i = howMany
        while i > 0  # Output loop
            println("Value #", i, ": ", v[i])
            i = i-1
        end
        println()
      ]], true, true,
      {PROGRAMx,{ASSNxSTMT,{SIMPLExVAR,"howMany"},{NUMLITxVAL,"5"}},
      {PRINTLNxSTMT,{STRLITxOUT,"\"I will ask you for \""},
      {SIMPLExVAR,"howMany"},{STRLITxOUT,"\" numbers.\""}},
      {PRINTLNxSTMT,
      {STRLITxOUT,"\"Then I will print them in reverse order.\""}},
      {PRINTLNxSTMT},
      {ASSNxSTMT,{SIMPLExVAR,"i"},
      {NUMLITxVAL,"1"}},{WHILExLOOP,{{BINxOP,"<="},{SIMPLExVAR,"i"},
      {SIMPLExVAR,"howMany"}},{PROGRAMx,{PRINTxSTMT,
      {STRLITxOUT,"\"Type value #\""},{SIMPLExVAR,"i"},
      {STRLITxOUT,"\": \""}},{ASSNxSTMT,{ARRAYxVAR,"v",
      {SIMPLExVAR,"i"}},{READNUMxCALL}},{PRINTLNxSTMT},{PRINTLNxSTMT},
      {ASSNxSTMT,{SIMPLExVAR,"i"},{{BINxOP,"+"},{SIMPLExVAR,"i"},
      {NUMLITxVAL,"1"}}}}},{PRINTLNxSTMT,
      {STRLITxOUT,"\"------------------------------------\""}},
      {PRINTLNxSTMT},{PRINTLNxSTMT,
      {STRLITxOUT,"\"Here are the values, in reverse order:\""}},
      {ASSNxSTMT,{SIMPLExVAR,"i"},{SIMPLExVAR,"howMany"}},
      {WHILExLOOP,{{BINxOP,">"},{SIMPLExVAR,"i"},{NUMLITxVAL,"0"}},
      {PROGRAMx,{PRINTLNxSTMT,{STRLITxOUT,"\"Value #\""},
      {SIMPLExVAR,"i"},{STRLITxOUT,"\": \""},{ARRAYxVAR,"v",
      {SIMPLExVAR,"i"}}},{ASSNxSTMT,{SIMPLExVAR,"i"},
      {{BINxOP,"-"},{SIMPLExVAR,"i"},{NUMLITxVAL,"1"}}}}},
      {PRINTLNxSTMT}},
      "Program: Input numbers, print them in reverse order")

    -- Long program
    howmany = 200
    progpiece = "print(42)"
    prog = progpiece:rep(howmany)
    ast = {PROGRAMx}
    astpiece = {PRINTxSTMT,{NUMLITxVAL,"42"}}
    for i = 1, howmany do
        table.insert(ast, astpiece)
    end
    checkParse(t, prog, true, true,
      ast,
      "Program: Long program")

    -- Very long program
    howmany = 30000
    progpiece = "x=readnum()println(x)"
    prog = progpiece:rep(howmany)
    ast = {PROGRAMx}
    astpiece1 = {ASSNxSTMT,{SIMPLExVAR,"x"},{READNUMxCALL}}
    astpiece2 = {PRINTLNxSTMT,{SIMPLExVAR,"x"}}
    for i = 1, howmany do
        table.insert(ast, astpiece1)
        table.insert(ast, astpiece2)
    end
    checkParse(t, prog, true, true,
      ast,
      "Program: Very long program")
end


function test_parseit(t)
    io.write("TEST SUITES FOR MODULE parseit\n")
    test_simple(t)
    test_print_stmt_no_expr(t)
    test_function_call_stmt(t)
    test_func_def_no_expr(t)
    test_while_loop_simple_expr(t)
    test_if_stmt_simple_expr(t)
    test_assn_stmt(t)
    test_return_stmt(t)
    test_print_stmt_with_expr(t)
    test_func_def_with_expr(t)
    test_expr_prec_assoc(t)
    test_readnum_rnd(t)
    test_array_item(t)
    test_expr_complex(t)
    test_prog(t)
end


-- *********************************************************************
-- Main Program
-- *********************************************************************


test_parseit(tester)
io.write("\n")
endMessage(tester:allPassed())

-- Terminate program, signaling no error
terminate(0)

