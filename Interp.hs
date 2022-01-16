module Interp where

import Parser
import State

data SDState = S State
             | Bottom
            deriving (Eq, Show)

interp :: Com -> SDState 
interp com = sCom com (S State.empty)

sCom :: Com -> SDState -> SDState
sCom Skip s = s
sCom (Assign id aexp) (S s) = let n = sAExp aexp s
                              in S $ State.update id n s
sCom (Seq com1 com2) (S s) | sCom com1 (S s) == Bottom = Bottom
                           | sCom com2 (sCom com1 (S s)) == Bottom = Bottom
                           | otherwise = sCom com2 (sCom com1 (S s))
sCom (If bexp com1 com2) (S s) | sBExp bexp s && sCom com1 (S s) == Bottom = Bottom
                               | not (sBExp bexp s) && sCom com2 (S s) == Bottom = Bottom
                               | sBExp bexp s = sCom com1 (S s)
                               | not (sBExp bexp s) = sCom com2 (S s)
sCom (While bexp com) (S s') = fix 99999 (\g -> cond (sBExp bexp, after g (sCom com), id)) (S s')

cond :: ((State -> Bool), (SDState -> SDState), (SDState -> SDState)) -> (SDState -> SDState)
cond (p, g1, g2) (S s) = if p s then g1 (S s) else g2 (S s) 

after g com s | com s == Bottom = Bottom
              | otherwise = g . com $ s

fix :: Int -> ((SDState -> SDState) -> (SDState -> SDState)) -> (SDState -> SDState)
fix c f | c < 0 = (\s -> Bottom) :: SDState -> SDState
        | otherwise = f (fix (c-1) f)

sAExp :: AExp -> State -> Int
sAExp (Num n)            s = n
sAExp (Var id)           s = State.lookup id s
sAExp (Plus a1 a2)  s = let a1' = sAExp a1 s
                            a2' = sAExp a2 s
                        in a1' + a2'
sAExp (Minus a1 a2) s = let a1' = sAExp a1 s
                            a2' = sAExp a2 s
                        in  a1' - a2'
sAExp (Times a1 a2) s = let a1' = sAExp a1 s
                            a2' = sAExp a2 s
                        in a1' * a2'

sBExp :: BExp -> State -> Bool
sBExp (T t) s = t
sBExp (Eq a1 a2) s  = let a1' = sAExp a1 s
                          a2' = sAExp a2 s
                      in  a1' == a2'
sBExp (Leq a1 a2) s = let a1' = sAExp a1 s
                          a2' = sAExp a2 s
                      in  a1' <= a2'
sBExp (Not b) s     = let b' = sBExp b s
                      in not b'
sBExp (And b1 b2) s = let b1' = sBExp b1 s
                          b2' = sBExp b2 s
                      in  b1' && b2'
