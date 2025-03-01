-- io.hs  UNFINISHED
-- Glenn G. Chappell
-- 2025-02-28
--
-- For CS 331 Spring 2025
-- Code from Feb 28 - Haskell: I/O

module Main where

import System.IO  -- for hFlush, stdout


main = do
    putStrLn ""
    putStrLn "This file contains sample code from February 28, 2025,"
    putStrLn "for the topic \"Haskell: I/O\"."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "useful. See the source."
    putStrLn ""


-- ***** String Conversion *****


-- Function "show" converts anything showable (type must be in class
-- Show) to a String.

-- numConcat
-- Returns string containing 2 params separated by blank.
-- So (numConcat 42 7) returns "42 7".
numConcat a b = (show a) ++ " " ++ (show b)

-- Try:
--   numConcat 42 7


-- Function "read" converts a string to anything (type must be in class
-- Read).

-- Try:
--   read "42"
-- Result is error; need to force return type.


stringPlusOne str = 1 + read str

stringToInteger str = (read str)::Integer

-- Try:
--   stringPlusOne "42"
--   stringToInteger "42"


-- ***** Simple Output *****


-- An I/O action is type of value. We do I/O by returning an I/O action
-- to the outside world.

sayHowdy = putStr "Howdy!"

sayHowdyNewLine = putStrLn "Howdy!"

-- Use ">>" to join I/O actions together into a single I/O action

sayHowdyAgain = putStr "Howdy " >> putStrLn "thar!"

sayHowdy2Line = putStrLn "Howdy" >> putStrLn "thar!"

-- Try:
--   sayHowdy
--   sayHowdyNewLine
--   sayHowdyAgain
--   sayHowdy2Line

secondsInADay = 60*60*24

ss1 = "There are "
ss2 = show secondsInADay
ss3 = " seconds in a day."
printSec = putStrLn $ ss1 ++ ss2 ++ ss3

io1 = putStr "There are "
io2 = putStr $ show secondsInADay
io3 = putStrLn " seconds in a day -- or so they say."
printSec' = io1 >> io2 >> io3

-- Try:
--   printSec
--   printSec'


-- ***** Simple Input *****


-- An I/O action wraps a value. The above I/O actions all wrapped
-- "nothing" values. getLine returns an I/O action that wraps the String
-- that is input.

-- Send the wrapped value to a function with ">>="

getPrint   = getLine >>= putStrLn
getPrint'  = getLine >>= (\ line -> putStrLn line)

rMsg = "What you typed, reversed: "
reverseIt' = putStr "Type something: "
             >> getLine
             >>= (\ line -> putStrLn (rMsg ++ reverse line))

-- The wrapped value cannot be removed from the I/O action, but it can
-- be processed inside it (e.g., the above call to function reverse).

-- Try:
--   getPrint
--   getPrint'
--   reverseIt'


-- MORE TO COME ...

