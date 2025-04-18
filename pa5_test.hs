-- pa5_test.hs
-- Glenn G. Chappell
-- 2025-03-18
--
-- For CS 331 Spring 2025
-- Test Program for Assignment 5 Functions & Variables
-- Used in Assignment 5, Exercise B

module Main where

import qualified PA5  -- For Assignment 5 Functions & Variables


------------------------------------------------------------------------
-- Testing Package
------------------------------------------------------------------------


-- TestState a
-- Data type for holding results of tests
-- First item in pair is a Maybe giving pass/fail results so far:
--     Just _   means all passed so far
--     Nothing  means at least one failure so far
-- Second item in pair is IO for output of tests
data TestState a = TS (Maybe a, IO a)

-- Accessor functions for parts of a TestState value
tsMaybe (TS (x, y)) = x
tsIO (TS (x, y)) = y

-- Make TestState a Functor in the obvious way
instance Functor TestState where
    fmap f (TS (a, b)) = TS (fmap f a, fmap f b)

-- Make TestState an Applicative in the obvious way
instance Applicative TestState where
    pure a = TS (pure a, pure a)
    TS (f, g) <*> TS (x, y) = TS (f <*> x, g <*> y)

-- Make TestState a Monad in the obvious way
instance Monad TestState where
    return = pure
    TS (x, y) >>= f = TS (x >>= f1, y >>= f2) where
        f1 = tsMaybe . f
        f2 = tsIO . f

-- testMsg
-- Print a message (e.g., "Test Suite: ...") in TestState monad
testMsg :: String -> TestState ()
testMsg str = TS (Just (), putStrLn str)

-- test
-- Do test in TestState monad
-- Given result of test (Bool: True if passed) & description of test
-- Adds result of test & description + pass/fail output to monadic value
test :: Bool -> String -> TestState ()
test success descrip = TS (theMaybe, putStrLn fullDescrip) where
    theMaybe  | success    = Just ()
              | otherwise  = Nothing
    fullDescrip = "    Test: " ++ descrip ++ " - " ++ passFailStr
    passFailStr  | success    = "passed"
                 | otherwise  = "********** FAILED **********"

-- testEq
-- Like test, but given 2 values, checks whether they are equal
testEq :: Eq a => a -> a -> String -> TestState ()
testEq a b str = test (a == b) str

-- printResults
-- Converts TestState monadic value to IO monadic value
--  with summary of all test results
printResults :: TestState () -> IO ()
printResults z = do
    -- Do IO from tests
    tsIO z
    putStrLn ""
    -- Output summary: all passed or not
    putStrLn $ summaryString z
    where
        summaryString (TS (Just _, _)) = "All tests successful"
        summaryString _ = "Tests ********** UNSUCCESSFUL **********"

-- allPassed
-- Given TestState, returns Bool indicating whether all tests passed.
allPassed :: TestState () -> Bool
allPassed (TS (Just _, _)) = True
allPassed _ = False


------------------------------------------------------------------------
-- Test Suites
------------------------------------------------------------------------


-- test_collatzCounts
-- Test Suite for variable collatzCounts
test_collatzCounts = do
    testMsg "Test Suite: Variable collatzCounts"
    testEq (take 10 PA5.collatzCounts) [0,1,7,2,5,8,16,3,19,6]
        "collatzCounts, example from Assn 5 description"
    test (corrCounts numck PA5.collatzCounts)
        ("collatzCounts, first " ++ show numck ++ " items")
    testEq (PA5.collatzCounts !! ii1) vv1
        ("collatzCounts, item #" ++ show ii1 ++ " = " ++ show vv1)
    testEq (PA5.collatzCounts !! ii2) vv2
        ("collatzCounts, item #" ++ show ii2 ++ " = " ++ show vv2)
    where
        numck = 300
        ii1 = 100001
        vv1 = 53
        ii2 = 200001
        vv2 = 90
        corrCounts len list = corrCounts' len list 1
        corrCounts' 0 _ _ = True
        corrCounts' len [] _ = False
        corrCounts' len (t:ts) n = corrCount n t &&
            corrCounts' (len-1) ts (n+1)
        corrCount n t = t >= 0 && iterCol t n == 1 &&
            (t < 3 || iterCol (t-3) n /= 1)
        iterCol 0 n = n
        iterCol t n = coll $ iterCol (t-1) n
        coll n = if mod n 2 == 1 then 3*n+1 else div n 2


-- test_op_greaterSharp
-- Test Suite for operator >#
test_op_greaterSharp = do
    testMsg "Test Suite: Infix Operator >#"
    testEq ([1,2,3,4,5] PA5.># [1,1,3,2,9,9,9,9]) 2
        "op >#, example #1 from Assn 5"
    testEq ([1,1,3,2,9,9,9,9] PA5.># [1,2,3,4,5]) 1
        "op >#, example #1 from Assn 5 reversed"
    testEq ([] PA5.># [1,1,3,2,9,9,9,9,9]) 0
        "op >#, example #2 from assn 5"
    testEq ([1,1,3,2,9,9,9,9,9] PA5.># []) 0
        "op >#, example #2 from assn 5 reversed"
    testEq ("axcxex" PA5.># "abcde") 2
        "op >#, example #3 from Assn 5"
    testEq ("abcde" PA5.># "axcxex") 0
        "op >#, example #3 from Assn 5 reversed"
    testEq ("fffff" PA5.># "abcde") 5
        "op >#, example #4 from Assn 5"
    testEq (biglist1a PA5.># biglist1b) 33334
        "op >#, long lists #1"
    testEq (biglist2a PA5.># biglist2b) 49999
        "op >#, long lists #2"
    where
        bignum = 100000
        f3 n = (n `div` 3) * 3 + 1
        biglist1a = map f3 [0..bignum-1]
        biglist1b = [0..bignum-1]
        biglist2a = [0,2..2*bignum-1]
        biglist2b = [div bignum 2..div (3*bignum) 2 - 1]


-- test_superfilter
-- Test Suite for function superfilter
test_superfilter = do
    testMsg "Test Suite: Function superfilter"
    testEq (PA5.superfilter (>0) [-1,1,-2,2] [1,2,3,4,5,6]) [2,4]
        "superfilter, example #1 from Assn 5 description"
    testEq (PA5.superfilter (==1) [2,2,1,1,1,1,1] "abcde") "cde"
        "superfilter, example #2 from Assn 5 description"
    testEq (PA5.superfilter (=='z') "azazazazazaz" [1..11]) [2,4..10]
        "superfilter, 1st list is string"
    testEq (PA5.superfilter (\n -> mod n 4==2) [1..100] "spaghetti")
        "pe"
        "superfilter, 2nd list is string"
    testEq (PA5.superfilter (\n -> mod n 3==1) [2..100000] [6,8..4000])
        [10,16..4000]
        "superfilter, longer lists #1"
    testEq (PA5.superfilter (\n -> mod n 3==1) [2..4000] [6,8..100000])
        [10,16..8002]
        "superfilter, longer lists #2"
    testEq (PA5.superfilter (\n -> n>1000 && n<2000) [3,7..3000]
            [4,9..5000])
        [1254,1259..2499]
        "superfilter, longer lists #3"
    testEq (PA5.superfilter (>0) [] [1..100000]) []
        "superfilter, first list empty"
    testEq (PA5.superfilter (\n -> mod n 2==0) [1..100000] noints) []
        "superfilter, second list empty"
    testEq (PA5.superfilter (>0) [] noints) []
        "superfilter, both lists empty"
    where
        noints = []::[Integer]
            -- Empty list that will not confuse the type inference


-- test_listSearch
-- Test Suite for function listSearch
test_listSearch = do
    testMsg "Test Suite: Function listSearch"
    testEq (PA5.listSearch "abcde" 'd') (Just 3)
        "listSearch, example #1 from Assn 5"
    testEq (PA5.listSearch "abcde" 'x') Nothing
        "listSearch, example #2 from Assn 5"
    testEq (PA5.listSearch [2,1,2,1,2] 1) (Just 1)
        "listSearch, example #3 from Assn 5"
    testEq (PA5.listSearch [5,5,5,5,5] 5) (Just 0)
        "listSearch, example #4 from Assn 5"
    testEq (PA5.listSearch [3..10000] 2003) (Just 2000)
        "listSearch, longer list #1: found"
    testEq (PA5.listSearch [3..10000] 1) Nothing
        "listSearch, longer list #2: not found"


-- test_alternatingSums
-- Test Suite for function alternatingSums
test_alternatingSums = do
    testMsg "Test Suite: Function alternatingSums"
    testEq (PA5.alternatingSums [1,2,3,4]) (4,6)
        "alternatingSums, example #1 from Assn 5"
    testEq (PA5.alternatingSums [20]) (20,0)
        "alternatingSums, example #2 from Assn 5"
    testEq (PA5.alternatingSums [20.0]) (20.0,0.0)
        "alternatingSums, example #3 from Assn 5"
    testEq (PA5.alternatingSums []) (0,0)
        "alternatingSums, example #4 from Assn 5"
    testEq (PA5.alternatingSums [1,1,1,1,1,1,1]) (4,3)
        "alternatingSums, example #5 from Assn 5"
    testEq (PA5.alternatingSums [1..1000]) (250000,250500)
        "alternatingSums, long list"
    testEq (PA5.alternatingSums [1..100000]) (2500000000,2500050000)
        "alternatingSums, longer list"


-- allTests
-- Run all test suites for Assignment 5 functions & variables
allTests = do
    testMsg "TEST SUITES FOR ASSIGNMENT 5 FUNCTIONS & VARIABLES"
    test_collatzCounts
    test_op_greaterSharp
    test_superfilter
    test_listSearch
    test_alternatingSums

-- main
-- Do all test suites & print results.
main = do
    printResults allTests

    -- If all tests pass, print reminder on implementation
    if allPassed allTests then do
        putStrLn ""
        putStrLn "  :::::::::::::::::::::::::::::::::::::::::::::::::::"
        putStrLn "  : Note. alternatingSums must be done as a fold.   :"
        putStrLn "  : The test program cannot check this requirement. :"
        putStrLn "  : (This is just a REMINDER, not a failing test.)  :"
        putStrLn "  :::::::::::::::::::::::::::::::::::::::::::::::::::"
    else
        return ()
    putStrLn ""

