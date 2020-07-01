module ArgParse (
    optCharset,
    setOptions
) where


import System.Console.GetOpt
import System.Exit (die, exitSuccess)


data Options = Options { 

    optCharset :: String, 
    optShowHelp :: Bool 
}


defaultOptions = Options {

    optCharset = "%a",
    optShowHelp = False
}


options :: [OptDescr (Options -> Options)]
options =
        [ 
            Option ['c'] ["charset"] 
            (ReqArg (\c opts -> opts { optCharset = c }) "CHARSET") 
            "The character set to test against the ciphertext.", 

            Option ['h'] ["help"] 
            (NoArg (\opts -> opts { optShowHelp = True })) 
            "Print this help message." 
        ]


setOptions :: [String] -> IO (Options, [String])
setOptions argv = case getOpt Permute options argv of
                        
                        (_, [], _) -> printHelp

                        (o, fs, []) -> 
                                        let 
                                            uOpts = foldl (flip id) defaultOptions o
                                        in
                                            if optShowHelp uOpts
                                            then printHelp
                                            else return (uOpts, fs)
                                                
                        (_, _, errs) -> die (concat errs ++ usageInfo header options)
                        
                        where
                            header = "Usage: freqalysis [ -c|--charset %u|%l|%n|%h|%a ] <pathToFile>"
                            printHelp = putStrLn (usageInfo header options) >> exitSuccess
