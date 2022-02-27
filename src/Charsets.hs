module Charsets (
    charSelect
) where


import Data.Char (toUpper)


-- the character set option mainly exists for performance reasons
charSelect :: String -> String
charSelect set
    | set == "%l" = lowerC
    | set == "%u" = upperC
    | set == "%h" = digi ++ takeWhile (/= 'G') upperC ++ takeWhile (/= 'g') lowerC -- hex
    | set == "%n" = lowerC ++ upperC ++ digi -- alphanumeric
    | set == "%p" = ['!'..'~'] -- printable ascii range from 33 - 126
    | otherwise = ['\1'..'\255'] -- Entire Char value range
    where
        lowerC = ['a'..'z']
        upperC = map (toUpper) lowerC
        digi = ['0'..'9']
