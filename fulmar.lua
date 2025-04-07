#!/usr/bin/env lua
-- fulmar.lua
-- Glenn G. Chappell
-- 2025-04-06
--
-- For CS 331 Spring 2025
-- REPL/Shell for Fulmar Programming Language
-- Requires lexit.lua, parseit.lua, interpit.lua


parseit = require "parseit"
interpit = require "interpit"


-- *********************************************************************
-- Variables
-- *********************************************************************


local fulmar_state  -- Fulmar variable values


-- *********************************************************************
-- Object with Callback Functions for Interpreter
-- *********************************************************************


-- We define this object to so we can pass it to the interpreter.

local fulmar_util = {}


-- fulmar_util.input
-- Input a line of text from standard input and return it in string
-- form, with no trailing newline.
function fulmar_util.input()
    io.flush()  -- Ensure previous output is done before input
    local line = io.read("*l")
    if type(line) == "string" then
        return line
    else
        return ""
    end
end


-- fulmar_util.output
-- Output the given string to standard output, with no added newline.
function fulmar_util.output(s)
    assert(type(s) == "string")

    io.write(s)
end


-- fulmar_util.random
-- Given integer n, if n < 2, then return 0. Otherwise return a
-- pseudorandom integer from 0 to n-1. The PRNG is first seeded with a
-- time-dependent value if it has not been seeded yet in the current
-- Fulmar program.
-- Uses local seeded (set to false in runFulmar), seed.
local seeded = false
local seed = 0
function fulmar_util.random(n)
    assert(type(n) == "number")

    if not seeded then
        -- Update seed using time
        seed = seed + os.time() + math.floor(1000000 * os.clock())

        -- Update seed using randomly generated filename
        t = os.tmpname()
        bs = table.pack(t:byte(1, #t))
        for i, v in ipairs(bs) do
            seed = seed + v
        end

        -- Seed the PRNG
        math.randomseed(seed)
        seeded = true

        -- Skip early values (bad on some OSs)
        local dummy = math.random(10)
        dummy = math.random(10)
        dummy = math.random(10)
    end

    if n < 2 then
        return 0
    end
    return math.random(math.floor(n)) - 1
end


-- *********************************************************************
-- Functions for Fulmar REPL
-- *********************************************************************


-- printHelp
-- Print help for REPL.
local function printHelp()
    io.write("Type Fulmar code to execute it.\n")
    io.write("Commands (these may be abbreviated;")
    io.write(" for example, \":e\" for \":exit\")\n")
    io.write("  :exit          - Exit.\n")
    io.write("  :run FILENAME  - Execute Fulmar source file.\n")
    io.write("  :clear         - Clear Fulmar state")
    io.write(" (defined variables, functions).\n")
    io.write("  :help          - Print this help.\n")
end


-- elimSpace
-- Given a string, remove all leading & trailing whitespace, and return
-- result. If given nil, returns nil.
local function elimSpace(s)
    if s == nil then
        return nil
    end

    assert(type(s) == "string")

    local ss = s:gsub("^%s+", "")
    ss = ss:gsub("%s+$", "")
    return ss
end


-- elimLeadingNonspace
-- Given a string, remove leading non-whitespace, and return result.
local function elimLeadingNonspace(s)
    assert(type(s) == "string")

    local ss = s:gsub("^%S+", "")
    return ss
end


-- containsDot
-- Given a string, return true if it contains a dot (".") character,
-- false otherwise. (In Lua 5.2+ this can be done with string.match, but
-- apparently not in Lua 5.1.)
local function containsDot(s)
    assert(type(s) == "string")

    for i = 1, s:len() do
        if s:sub(i,i) == "." then
            return true
        end
    end

    return false
end


-- errMsg
-- Given an error message, prints it in flagged-error form, with a
-- newline appended.
local function errMsg(msg)
    assert(type(msg) == "string")

    io.write("*** ERROR - "..msg.."\n")
end


-- clearState
-- Clear Fulmar state: functions, simple variables, arrays.
local function clearState()
    fulmar_state = { f={}, v={}, a={} }
end


-- runFulmar
-- Given a string, attempt to treat it as source code for a Fulmar
-- program, and execute it. I/O uses standard input & output.
--
-- Parameters:
--   program  - Fulmar source code
--   state    - Values of Fulmar variables as in interpit.interp.
--   exec_msg  - Optional string. If code parses, then, before it is
--              executed, this string is printed, followed by a newline.
--
-- Returns three values:
--   good     - true if initial portion of program parsed successfully;
--              false otherwise.
--   done     - true if parse reached end of program; false otherwise.
--   newstate - If good, done are both true, then new value of state,
--              updated with revised values of variables. Otherwise,
--              same as passed value of state.
--
-- If good and done are both true, then the code was executed.
local function runFulmar(program, state, exec_msg)
    assert(type(program) == "string")
    assert(type(state) == "table")
    assert(type(state.f) == "table")
    assert(type(state.v) == "table")
    assert(type(state.a) == "table")
    assert(exec_msg == nil or type(exec_msg) == "string")

    -- Mark PRNG as not seeded; it will be seeded the first time a
    -- random number is requested in the program.
    seeded = false

    local good, done, ast = parseit.parse(program)
    local newstate
    if good and done then
        if exec_msg ~= nil then
            io.write(exec_msg.."\n")
        end
        newstate = interpit.interp(ast, state, fulmar_util)
    else
        newstate = state
    end
    return good, done, newstate
end


-- runFile
-- Given filename, attempt to read source for a Fulmar program from it,
-- and execute the program. If prinntmsg is true and the program parses
-- correctly, then print a message before executing the file.
local function runFile(fname, printmsg)
    assert(type(fname) == "string")
    assert(type(printmsg) == "boolean")

    function readable(fname)
        local f = io.open(fname, "r")
        if f ~= nil then
            f:close()
            return true
        else
            return false
        end
    end

    local good, done

    if not readable(fname) then
        errMsg("Fulmar source file not readable: '"..fname.."'")
        return
    end
    local source = ""
    for line in io.lines(fname) do
        source = source .. line .. "\n"
    end
    local exec_msg
    if printmsg then
        exec_msg = "EXECUTING FILE: '"..fname.."'"
    else
        exec_msg = nil
    end
    good, done, fulmar_state = runFulmar(source, fulmar_state, exec_msg)
    if not (good and done) then
        errMsg("Syntax error in Fulmar source file: '"..fname.."'")
    end
end


-- doReplCommand
-- Given input line beginning with ":", execute as REPL command. Return
-- true if execution of REPL should continue; false if it should end.
local function doReplCommand(line)
    assert(line:sub(1,1) == ":")
    if line:sub(1,2) == ":e" then
        return false
    elseif line:sub(1,2) == ":h" then
        printHelp()
        return true
    elseif line:sub(1,2) == ":c" then
        clearState()
        io.write("Fulmar state cleared\n")
        return true
    elseif line:sub(1,2) == ":r" then
        fname = elimLeadingNonspace(line:sub(3))
        fname = elimSpace(fname)
        if (fname == "") then
            errMsg("No filename given")
            return true
        end

        if fname:sub(fname:len(),fname:len()) == "." then
            fname = fname .. "fmar"
        elseif not containsDot(fname) then
            fname = fname .. ".fmar"
        end
        runFile(fname, true)  -- true: Print execution message
        return true
    else
        errMsg("Unknown command")
        return true
    end
end


-- repl
-- Fulmar REPL. Prompt & get a line. If it begins with a colon (":")
-- then treat it as a REPL command. Otherwise, treat line as Fulmar
-- program, and attempt to execute it. If it looks like an incomplete
-- Fulmar program, then keep inputting, and continue to attempt to
-- execute. REPEAT.
local function repl()
    local line, good, done, continueflag, prompt
    local source = ""

    printHelp()
    while true do
        -- Prompt
        if source == "" then
            io.write("\n")
            prompt = ">>> "
        else
            prompt = "... "
        end

        -- Input a line + error check
        repeat
            io.write(prompt)
            io.flush()  -- Ensure previous output is done before input
            line = io.read("*l")  -- Read a line
            line = elimSpace(line)
        until line ~= ""

        if line == nil then             -- Read error (EOF?)
            io.write("\n")
            break
        end

        -- Handle input, as approprite
        if line:sub(1,1) == ":" then    -- Command
            source = ""
            continueflag = doReplCommand(line)
            if not continueflag then
                break
            end
        else                            -- Fulmar code
            source = source .. line
            good, done, fulmar_state = runFulmar(source, fulmar_state)
            if (not good) and done then
                source = source .. "\n" -- Continue inputting source
            else
                source = ""             -- Start over
            end
            if not done then
                errMsg("Syntax error in Fulmar code")
            end
        end
    end
end


-- *********************************************************************
-- Main Program
-- *********************************************************************


-- Initialize Fulmar
clearState()

-- Command-line argument? If so treat as Fulmar source filename, read
-- source, and execute.
if arg[1] ~= nil then
    runFile(arg[1], false)  -- false: Do not print execution message
    io.write("\n")
    io.write("Press ENTER to quit ")
    io.flush()  -- Ensure previous output is done before input
    io.read("*l")
-- Otherwise, fire up the Fulmar REPL.
else
    repl()
end

