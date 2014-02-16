module Objects where

  import Prelude
  import Either
  import Arrays
  import Eff
  import JSON
  
  -- | Convenience function to allow us to turn any type into a string.
  foreign import showUnsafe "function showUnsafe (obj) { \
                            \  return JSON.stringify(obj); \
                            \}" :: forall a. a -> String
  
  -- | To parse objects of a particular type, we need to define some helper 
  --   data types as making class instances for records is not possible.
  data Point = Point { x :: Number, y :: Number }
  
  -- | The ReadJSON implementations for these types are basically boilerplate, 
  --   type inference takes care of most of the work so we don't have to 
  --   explicitly define the type each of the properties we're parsing.
  instance JSON.ReadJSON Point where
    readJSON = do
      x <- readJSONProp "x"
      y <- readJSONProp "y"
      return $ Point { x: x, y: y }
      
  main = do
  
    -- Type inference helps us out again when reading the result too. Because 
    -- we matched Point in the pattern, we don't have to explicitly cast 
    -- anything to ensure the right ReadJSON instance is chosen.
    Trace.trace $ case parseJSON "{ \"x\": 1, \"y\": 2 }" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right (Point result) -> showUnsafe result
