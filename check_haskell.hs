-- check_haskell.hs
-- Glenn G. Chappell
-- 2025-02-03
--
-- For CS 331 Spring 2025
-- A Haskell Program to Run
-- Used in Assignment 2, Exercise A

module Main where


-- main
-- Print second secret message.
main = do
    putStrLn "Secret message #2:"
    putStrLn ""
    putStrLn secret_message
    putStrLn ""


-- secret_message
-- A mysterious message.
secret_message = map xk xj  where
    xa = [82,18,-5,-71,76,-15]
    xb = [15,3,-17,-9,9,-78]
    xc = [64,-3,0,10,-3,3]
    xd = [-85,63,17,-86,75,-6]
    xe = [-7,8,-7,-4,-1,10,-72]
    xf = [2,-13,17,31,-14,6]
    xg = "The treasure is buried under a palm tree on the third island."
    xh = map (+ xl) $ concat [xa, xb, xc, xd, xe]
    xi a as = a : map (+ a) as
    xj = foldr xi [] xh
    xk a = toEnum a `asTypeOf` hh where (hh:tt) = xg
    xl = hh where (hh:tt) = xf

