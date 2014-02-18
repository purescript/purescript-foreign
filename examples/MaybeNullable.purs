module MaybeNullable where

  import Prelude
  import Either
  import Maybe
  import Eff
  import Data.JSON
  
  -- Parsing values that are allowed to null or undefined is possible by 
  -- using Maybe types.
  main = do
  
    Trace.trace $ case parseJSON "null" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> show $ result :: Maybe Boolean
      
    Trace.trace $ case parseJSON "true" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> show $ result :: Maybe Boolean
