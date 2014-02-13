module Main where

  import Prelude
  import Either
  import JSON 
  import Monad 
  import Arrays 
  
  foreign import toJSON "function toJSON (obj) { return obj; }" :: forall a. a -> JSON
  
  showUnsafe :: forall a. a -> String
  showUnsafe = showJSON <<< toJSON
  
  class ReadJSON a where
    readJSON :: JSONParser a
    
  instance ReadJSON Number where
    readJSON = num
    
  readJSONProp :: forall a. (ReadJSON a) => String -> JSONParser a
  readJSONProp p j = (prop p j) >>= readJSON
  
  data Item = Item Number Number Number
  
  instance ReadJSON Item where
    readJSON json = Item <$> (readJSONProp "x" json) 
                         <*> (readJSONProp "y" json) 
                         <*> (readJSONProp "z" json)
  
  main = do
    let obj = fromString "{\"x\":1,\"y\":2,\"z\":3}" 
    case obj of
      Left err -> Trace.print $ "Error parsing: " ++ err
      Right obj -> case readJSON obj of
        Left err -> Trace.print err
        Right (Item x y z) -> Trace.print [x, y, z]
