-- mymodule.lua
-- Glenn G. Chappell
-- 2025-01-29
--
-- For CS 331 Spring 2025
-- Code from Jan 29 - Example Lua Module
-- Not a complete program


-- To use this module, do
--     mymodule = require "mymodule"
-- in some Lua program.
-- Then you can call, for example, function "mymodule.print_with_stars".


local mymodule = {}  -- Module table


-- square
-- Given a number, return its square.
-- NOT EXPORTED
local function square(n)
    return n*n
end


-- square_plus_one
-- Given a number, return its square plus one.
-- EXPORTED
function mymodule.square_plus_one(n)
    return square(n) + 1
end


-- print_with_border
-- Given message and border character, prints message using the char as
-- the border.
-- NOT EXPORTED
local function print_with_border(msg, borderchar)
    local n = msg:len()  -- length of string msg

    local function line()
        for i = 1, n+4 do
            io.write(borderchar)
        end
        io.write("\n")
    end

    line()
    io.write(borderchar .. " " .. msg .. " " .. borderchar .. "\n")
    line()
end


-- print_with_stars
-- Given message and border character, prints message surrounded by
-- stars.
-- EXPORTED
function mymodule.print_with_stars(msg)
    print_with_border(msg, "*")
end


return mymodule      -- Return the module, so client code can use it

