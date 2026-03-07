-- 19/06/2015
-- Paulo Oliva
-- Prepared to TACL'2015 invited talk

import Data.List

-- Players
type Player r x = (x -> r) -> [x]

-- Candidates
data Cand = A | B deriving (Eq,Ord,Enum,Show)

-- Judges
type Judge x = Player Cand x

cand = enumFrom A

-- Outcome function, most votes
most :: [Cand] -> Cand
most xs = (sort xs) !! (div (length xs) 2)

-- Outcome function, most votes
least :: [Cand] -> Cand
least xs = if most xs == A then B else A

-- Judge that prefers A > B
argmax1 :: Judge Cand
argmax1 p = [ x | x <- cand, p x == minimum (map p cand) ]

-- Judge that prefers B > A
argmax2 :: Judge Cand
argmax2 p = [ x | x <- cand, p x == maximum (map p cand) ]

-- Keynesian judge, wants to vote for winner
fix :: Judge Cand
fix p = [ x | x <- cand, p x == x ]

-- Unilateral context
-- Game context when all palyers but i-th have fixed their moves
cont :: ([Cand] -> Cand) -> [Cand] -> Int -> Cand -> Cand
cont q xs i x = q $ (take i xs) ++ [x] ++ (drop (i+1) xs)

-- Equilibrium checking = Global player
global :: [Judge Cand] -> Judge [Cand]
global js q = [ xs | xs <- plays, all (good xs) (zip [0..] js) ]
	where
		n = length js
		plays = sequence (replicate n cand)
		good xs (i,e) = elem (xs !! i) (e (cont q xs i))

-- FIRST GAME EXAMPLE: Three judges
-- Judge 1 prefers A
-- Judge 2 prefer B
-- Judge 3 wants to vote for the winner

judges1 = [argmax1, argmax2, fix]

-- Equilibrium strategies
eq1 = global judges1 most

-- SECOND GAME EXAMPLE: Five judges
-- Judges 1 and 5 prefers A
-- Judge 3 prefer B
-- Judge 2 and 4 want to vote for the winner

judges2 = [argmax1, fix, argmax2, fix, argmax1]

eq2 = global judges2 most

-- Two more judges

judges3 = [argmax1, fix, argmax2, fix, argmax1, fix, argmax2]

eq3 = global judges3 most

-- All Keynesian judges

judges4 = [fix, fix, fix, fix, fix]

eq4 = global judges4 most
