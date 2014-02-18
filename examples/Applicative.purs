module Applicative where

  import Prelude
  import Either
  import Arrays
  import Eff
  import Data.JSON
  
  data Point = Point Number Number Number
  
  instance Data.JSON.ReadJSON Point where
    readJSON = Point <$> readJSONProp "x" 
                     <*> readJSONProp "y"
                     <*> readJSONProp "z"
      
  main = do
  
    Trace.trace $ case parseJSON "{ \"x\": 1, \"y\": 2, \"z\": 3 }" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right (Point x y z) -> show [x, y, z]
