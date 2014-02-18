module JSONArrays where

  import Prelude
  import Either
  import Arrays
  import Eff
  import Data.JSON
  
  main = do
  
    Trace.trace $ case parseJSON "[\"hello\", \"world\"]" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> show $ result :: [String]
      
    Trace.trace $ case parseJSON "[1, 2, 3, 4]" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> show $ result :: [Number]
