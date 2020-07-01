module Charsets (
    charSelect
) where


import Data.Char (toUpper)


charSelect :: String -> String
charSelect set
    | set == "%l" = lowerC
    | set == "%u" = upperC
    | set == "%h" = digi ++ takeWhile (/= 'G') upperC ++ takeWhile (/= 'g') lowerC -- hex
    | set == "%n" = lowerC ++ upperC ++ digi -- alphanumeric
    | otherwise = [' '..'~'] -- printable ascii range from 32 - 126
    where
        lowerC = ['a'..'z']
        upperC = map (toUpper) lowerC
        digi = ['0'..'9']
