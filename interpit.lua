-- interpit.lua  UNFINISHED
-- Glenn G. Chappell
-- 2025-04-06
--
-- For CS 331 Spring 2025
-- Interpret AST from parseit.parse
-- Solution to Assignment 6, Exercise A


-- *** To run a Fulmar program, use fulmar.lua, which uses this file.


-- *********************************************************************
-- Module Table Initialization
-- *********************************************************************


local interpit = {}  -- Our module


-- *********************************************************************
-- Symbolic Constants for AST
-- *********************************************************************


local PROGRAM       = 1
local PRINT_STMT    = 2
local PRINTLN_STMT  = 3
local RETURN_STMT   = 4
local ASSN_STMT     = 5
local FUNC_CALL     = 6
local FUNC_DEF      = 7
local IF_STMT       = 8
local WHILE_LOOP    = 9
local STRLIT_OUT    = 10
local CHR_CALL      = 11
local BIN_OP        = 12
local UN_OP         = 13
local NUMLIT_VAL    = 14
local READNUM_CALL  = 15
local RND_CALL      = 16
local SIMPLE_VAR    = 17
local ARRAY_VAR     = 18


-- *********************************************************************
-- Utility Functions
-- *********************************************************************


-- numToInt
-- Given a number, return the number rounded toward zero.
local function numToInt(n)
    assert(type(n) == "number")

    if n >= 0 then
        return math.floor(n)
    else
        return math.ceil(n)
    end
end


-- strToNum
-- Given a string, attempt to interpret it as an integer. If this
-- succeeds, return the integer. Otherwise, return 0.
local function strToNum(s)
    assert(type(s) == "string")

    -- Try to do string -> number conversion; make protected call
    -- (pcall), so we can handle errors.
    local success, value = pcall(function() return tonumber(s) end)

    -- Return integer value, or 0 on error.
    if success and value ~= nil then
        return numToInt(value)
    else
        return 0
    end
end


-- numToStr
-- Given a number, return its string form.
local function numToStr(n)
    assert(type(n) == "number")

    return tostring(n)
end


-- boolToInt
-- Given a boolean, return 1 if it is true, 0 if it is false.
local function boolToInt(b)
    assert(type(b) == "boolean")

    if b then
        return 1
    else
        return 0
    end
end


-- astToStr
-- Given an AST, produce a string holding the AST in (roughly) Lua form,
-- with numbers replaced by names of symbolic constants used in parseit.
-- A table is assumed to represent an array.
-- See the Assignment 4 description for the AST Specification.
--
-- THIS FUNCTION IS INTENDED FOR USE IN DEBUGGING ONLY!
-- IT SHOULD NOT BE CALLED IN THE FINAL VERSION OF THE CODE.
local function astToStr(x)
    local symbolNames = {
        "PROGRAM", "PRINT_STMT", "PRINTLN_STMT", "RETURN_STMT",
        "ASSN_STMT", "FUNC_CALL", "FUNC_DEF", "IF_STMT", "WHILE_LOOP",
        "STRLIT_OUT", "CHR_CALL", "BIN_OP", "UN_OP", "NUMLIT_VAL",
        "READNUM_CALL", "RND_CALL", "SIMPLE_VAR", "ARRAY_VAR",
    }
    if type(x) == "number" then
        local name = symbolNames[x]
        if name == nil then
            return "<Unknown numerical constant: "..x..">"
        else
            return name
        end
    elseif type(x) == "string" then
        return '"'..x..'"'
    elseif type(x) == "boolean" then
        if x then
            return "true"
        else
            return "false"
        end
    elseif type(x) == "table" then
        local first = true
        local result = "{"
        for k = 1, #x do
            if not first then
                result = result .. ","
            end
            result = result .. astToStr(x[k])
            first = false
        end
        result = result .. "}"
        return result
    elseif type(x) == "nil" then
        return "nil"
    else
        return "<"..type(x)..">"
    end
end


-- *********************************************************************
-- Primary Function for Client Code
-- *********************************************************************


-- interp
-- Interpreter, given AST returned by parseit.parse.
-- Parameters:
--   ast    - AST constructed by parseit.parse
--   state  - Table holding Fulmar variables & functions
--            - AST for function xyz is in state.f["xyz"]
--            - Value of simple variable xyz is in state.v["xyz"]
--            - Value of array item xyz[42] is in state.a["xyz"][42]
--   util   - Table with 3 members, all functions:
--            - util.input() inputs line, returns string with no newline
--            - util.output(str) outputs str with no added newline
--              To print a newline, do util.output("\n")
--            - util.random(n), for an integer n, returns a pseudorandom
--              integer from 0 to n-1, or 0 if n < 2.
-- Return Value:
--   state, updated with changed variable values
function interpit.interp(ast, state, util)
    -- Each local interpretation function is given the AST for the
    -- portion of the code it is interpreting. The function-wide
    -- versions of state and until may be used. The function-wide
    -- version of state may be modified as appropriate.


    -- Forward declare local functions
    local interp_program
    local interp_stmt
    local eval_print_arg
    local eval_expr


    -- interp_program
    -- Given the ast for a program, execute it.
    function interp_program(ast)
        -- TODO: WRITE THIS!!!
    end


    -- interp_stmt
    -- Given the ast for a statement, execute it.
    function interp_stmt(ast)
        -- TODO: WRITE THIS!!!
    end


    -- eval_print_arg
    -- Given the AST for an output argument, evaluate it and return the
    -- value, as a string.
    function eval_print_arg(ast)
        -- TODO: WRITE THIS!!!
        return "Aardvark"  -- DUMMY
    end


    -- eval_expr
    -- Given the AST for an expression, evaluate it and return the
    -- value, as a number.
    function eval_expr(ast)
        -- TODO: WRITE THIS!!!
        return 42  -- DUMMY
    end


    -- Body of function interp
    interp_program(ast)
    return state
end


-- *********************************************************************
-- Module Table Return
-- *********************************************************************


return interpit

