{-# LANGUAGE OverloadedStrings #-}

module Main where

import ArgParse
import Gramification
import Charsets
import qualified Data.ByteString.Char8 as B
import System.Environment (getArgs)
import System.Directory (doesFileExist)

main :: IO ()
main = do
        (o, cf:_) <- getArgs >>= setOptions
        existing <- doesFileExist cf
        if existing
        then B.readFile cf >>= B.putStr . frequencyCount (charSelect $ optCharset o) 
        else B.putStrLn "Couldn't find the specified file..."

