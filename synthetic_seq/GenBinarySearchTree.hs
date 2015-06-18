module GenBinaryTree where

import System.Random

data BTree a = Leaf a
             | Node (BTree a) a (BTree a)

instance (Show a) => Show (BTree a) where
    show (Leaf a) = "Leaf(" ++ show a ++ ")"
    show (Node t1 a t2) = "Node(" ++ show t1 ++ "," ++ show a ++ "," ++ show t2 ++ ")"

g = mkStdGen 0

gen = gen' 10 (-1000000,10000000) g

gen' :: Int -> (Int,Int) -> StdGen -> BTree Int
gen' depth (lb,ub) g = let
    (a',g') = randomR (ub,lb) g
    (g1,g2) = split g'
    in
      if depth == 0
      then Leaf a'
      else Node (gen' (depth-1) (lb,a') g1) a' (gen' (depth-1) (a',ub) g2)
