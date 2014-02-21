module ParseErrors where

import Prelude
import Data.Array
import Data.Either
import Data.JSON
import Control.Monad.Eff

-- | See the `Objects` example for an explanation of how to parse objects 
--   like this.
data Point = Point { x :: Number, y :: Number }

instance Data.JSON.ReadJSON Point where
  readJSON = do
    x <- readJSONProp "x"
    y <- readJSONProp "y"
    return $ Point { x: x, y: y }
    
main = do

  -- When trying to parse invalid JSON we catch an exception from 
  -- `JSON.parse` and pass it on.
  Debug.Trace.trace $ case parseJSON "not even JSON" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: String
    
  Debug.Trace.trace ""

  -- When attempting to coerce one type to another we get an error.
  Debug.Trace.trace $ case parseJSON "26" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: Boolean
    
  Debug.Trace.trace ""
  
  -- When parsing fails in an array, we're told at which index the value that 
  -- failed to parse was, along with the reason the value didn't parse.
  Debug.Trace.trace $ case parseJSON "[1, true, 3]" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: [Boolean]
    
  Debug.Trace.trace ""
  
  -- When parsing fails in an object, we're the name of the property which 
  -- failed to parse was, along with the reason the value didn't parse.
  Debug.Trace.trace $ case parseJSON "{ \"x\": 1, \"y\": false }" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right (Point result) -> (show result.x) ++ ", " ++ (show result.y)
    
  -- These error messages combine too, so if a value in an object in an array 
  -- in another object fails to parse, the full stack of errors will be 
  -- returned, e.g.:
  --   Error reading property 'list':
  --   Error reading item at index 1:
  --   Error reading property 'z':
  --   Value is not a Number
