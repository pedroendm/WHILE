module State where

import qualified Data.Map as Map

type State = Map.Map String Int

empty :: State
empty = Map.empty

update :: String -> Int -> State -> State
update = Map.insert

lookup :: String -> State -> Int
lookup id s = case Map.lookup id s of
            Just v -> v
            Nothing -> 0

toList :: State -> [(String, Int)]
toList = Map.toList
