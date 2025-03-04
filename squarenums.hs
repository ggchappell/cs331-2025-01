-- squarenums.hs
-- Glenn G. Chappell
-- 2025-03-03
--
-- For CS 331 Spring 2025
-- Computer Science I Program in Haskell

module Main where

import System.IO  -- for hFlush, stdout


-- squareNums
-- Repeatedly input a number from the user. If 0, then quit; otherwise
-- print its square, and repeat.
squareNums = do
    putStr "Type an integer (0 to quit): "
    hFlush stdout       -- Make sure prompt comes before input
    line <- getLine     -- Bind name to I/O-wrapped value
    let n = read line   -- Bind name to non-I/O value
                        -- Compiler knows n is Integer by how we use it
    if n == 0
    then return ()  -- Must have I/O action here, but there are no side
                    --  effects to perform and nothing it needs to wrap.
    else do
        putStrLn ""
        putStr "The square of your number is: "
        putStrLn $ show $ n*n
        putStrLn ""
        squareNums    -- Repeat


-- main
-- Demonstrate squareNums.
main = squareNums

