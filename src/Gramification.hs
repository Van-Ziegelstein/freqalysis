{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

module Gramification ( 
    frequencyCount
) where


import qualified Data.List as L
import qualified Control.Applicative as A
import qualified Control.Monad.Writer as W
import qualified Data.ByteString.Char8 as B


data TokenFreq = TokenFreq !B.ByteString !Int deriving Eq

instance Ord TokenFreq where
    compare (TokenFreq _ freq1) (TokenFreq _ freq2) = compare freq1 freq2


-- use the writer monad to aggregate intermediate token sets and output strings.
statLog :: B.ByteString -> [TokenFreq] -> W.Writer B.ByteString [TokenFreq]
statLog id ta = W.writer (ta, "\nMost frequent " <> id <> "\n" <> tokLines ta)
    where
        tokLines = B.unlines . L.map (\(TokenFreq s freq) -> s <> ": " <> (B.pack $ show freq)) . take 6


aboveAvg :: [TokenFreq] -> [TokenFreq]
aboveAvg toks = 
                let 
                    (sum, len) = L.foldl' (\(!a, !n) (TokenFreq ts freq) -> (a + freq, n + 1)) (0,0) toks
                in
                    L.filter (\(TokenFreq _ freq) -> freq > sum `div` len) toks


-- count the occurences of a (sub-)bytestring inside another bytestring
tFreq :: B.ByteString -> B.ByteString -> Int
tFreq subs bs = 
                let 
                    ns = (B.drop $ B.length subs) . snd $ B.breakSubstring subs bs 
                in 
                    if B.null ns then 0 else 1 + tFreq subs ns


singles :: Char -> B.ByteString -> TokenFreq
singles c = TokenFreq (B.singleton c) . lfreq
    where
        lfreq = B.length . B.filter (==c)


ngrams :: B.ByteString -> B.ByteString -> TokenFreq
ngrams p = TokenFreq p . tFreq p


-- this uses the properties of the list monad to generate all 
-- strings derived from pre- and suffixing entities from the char set.
gramCascade :: [TokenFreq] -> String -> [B.ByteString]
gramCascade toks cset = L.nub $ do
                        (TokenFreq ts _) <- toks
                        c <- cset
                        prepend <- [True, False]
                        if prepend
                        then return $ c `B.cons` ts
                        else return $ ts `B.snoc` c 


frequencyCount :: String -> B.ByteString -> B.ByteString
frequencyCount cset cystr = snd $ W.runWriter computeStats
    where
        gramStat f frags = L.reverse . L.sort . aboveAvg . A.getZipList $ (f) <$> frags <*> (pure cystr)
        computeStats = do
                        singleHighs <- statLog "letters" $ gramStat (singles) (A.ZipList cset)
                        statLog "twin repeats" $ gramStat (ngrams . B.replicate 2) (A.ZipList cset)
                        doubleHighs <- statLog "bigrams" $ gramStat (ngrams) (A.ZipList $ gramCascade singleHighs cset)
                        statLog "trigrams" $ gramStat (ngrams) (A.ZipList $ gramCascade doubleHighs cset)

