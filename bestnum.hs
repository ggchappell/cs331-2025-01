-- bestnum.hs
-- Glenn G. Chappell
-- 2025-03-05
--
-- For CS 331 Spring 2025
-- Second Computer Science I Program in Haskell

module Main where

import System.IO  -- for hFlush, stdout


-- bestNum
-- Repeatedly input a number from the user. If it is the best number,
-- then say that it is right and quit. Otherwise, admonish the user and
-- let them try again.
bestNum = do
    putStr "What is the best number? "
    hFlush stdout
    line <- getLine
    let n = read line
    let thebest = 6    -- The best number
    if n == thebest
    then do
        putStrLn "You're right!"
        putStrLn ""
    else do
        putStrLn "You're wrong."
        putStrLn "Try again, you doofus."
        putStrLn ""
        bestNum        -- Repeat


-- main
-- Demonstrate bestNum.
main = bestNum

