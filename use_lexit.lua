#!/usr/bin/env lua
-- use_lexit.lua
-- Glenn G. Chappell
-- 2025-02-11
--
-- For CS 331 Spring 2025
-- Simple Main Program for lexit Module
-- Requires lexit.lua

lexit = require "lexit"


-- Our "program", which is sent to the lexer
-- Change this string and see what happens.
program = "println(\"xy+23 = \", xy+23)  # Print something\n"


-- Print the input ("program")
io.write("*** Lexer Input (CHANGE THIS AND SEE WHAT HAPPENS):\n")
io.write(program)
io.write("\n\n")

-- Lex away and print the output as we go
io.write("*** Lexer Output:\n")
for lexstr, cat in lexit.lex(program) do
    local catstr = lexit.catnames[cat]
    io.write(string.format("%-10s  %s\n", lexstr, catstr))
end

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

