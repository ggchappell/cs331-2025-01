-- PA5.hs  SKELETON
-- Glenn G. Chappell
-- 2025-03-18
--
-- For CS 331 Spring 2025
-- Solutions to Assignment 5 Exercise B

module PA5 where


-- =====================================================================


-- collatzCounts
collatzCounts :: [Integer]
collatzCounts = [42..]  -- DUMMY; REWRITE THIS!!!


-- =====================================================================


-- operator >#
(>#) :: Ord a => [a] -> [a] -> Int
_ ># _ = 42  -- DUMMY; REWRITE THIS!!!


-- =====================================================================


-- superfilter
superfilter :: (a -> Bool) -> [a] -> [b] -> [b]
superfilter _ _ bs = bs  -- DUMMY; REWRITE THIS!!!


-- =====================================================================


-- listSearch
listSearch :: Eq a => [a] -> a -> Maybe Int
listSearch _ _ = Just 42  -- DUMMY; REWRITE THIS!!!


-- =====================================================================


-- alternatingSums
alternatingSums :: Num a => [a] -> (a, a)
{-
  The assignment requires alternatingSums to be written as a fold.
  Like this:

    alternatingSums xs = fold* ... xs  where
        ...

  Above, "..." must be replaced by other code. "fold*" must be one of
  the following: foldl, foldr, foldl1, foldr1.

  Here is an implementation of alternatingSums that works, but does not
  meet the requirements of the assignment (and so would not be graded,
  if you turned it in).

    alternatingSums [] = (0,0)
    alternatingSums (x:xs) = (x+b,a)  where
        (a,b) = alternatingSums xs
-}
alternatingSums _ = (42, 42)  -- DUMMY; REWRITE THIS!!!

