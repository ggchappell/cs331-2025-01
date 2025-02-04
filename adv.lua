#!/usr/bin/env lua
-- adv.lua
-- Glenn G. Chappell
-- 2025-02-03
--
-- For CS 331 Spring 2025
-- Code from Feb 3 - Lua: Advanced Flow


-- Upper limit for the Fibonacci numbers we print
max_fibo = 3000


-- ***** Coroutines *****


io.write("\n*** Coroutines:\n")

-- Here is a coroutine: a function that can temporarily give up control
-- ("yield"), and then be resumed again.

-- small_fibos1
-- Yield Fibonacci numbers at most given limit.
function small_fibos1(limit)
    local currfib, nextfib = 0, 1
    while currfib <= limit do
        coroutine.yield(currfib)  -- yield value; resumable afterwards
        currfib, nextfib = nextfib, currfib + nextfib
    end
end

-- Use the above coroutine
io.write("Fibonacci number <= "..max_fibo.." with a coroutine\n")

-- Get the coroutine wrapper function
cw = coroutine.wrap(small_fibos1)

f = cw(max_fibo)   -- Attempt to get value from coroutine;
                   --  argument passed to small_fibos1
while f ~= nil do  -- While coroutine has not returned
    io.write(f .. "  ")  -- Do something with our value
    f = cw()             -- Attempt to get another value from coroutine
end
io.write("\n")


-- ***** Custom Iterators *****


io.write("\n*** Custom Iterators:\n")

-- You can make your own iterators for use with the for-in control
-- structure.

-- Here is an example (which goes through the same values as the above
-- coroutine example):

-- small_fibos2
-- Allows for-in iteration through Fibonacci numbers at most n.
function small_fibos2(limit)
    local currfib, nextfib = 0, 1

    function iter_func()
        if currfib > limit then
            return nil  -- End iteration
        end
        local save_curr = currfib
        currfib, nextfib = nextfib, currfib + nextfib
        return save_curr
    end

    return iter_func
end

-- Use the above iterator
io.write("Fibonacci numbers <= "..max_fibo.." with a custom iterator\n")

for f in small_fibos2(max_fibo) do
    io.write(f .. "  ")
end
io.write("\n")


io.write("\n")
io.write("This file contains sample code from February 3, 2025,\n")
io.write("for the topic \"Lua: Advanced Flow\".\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("useful. See the source.\n")

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

