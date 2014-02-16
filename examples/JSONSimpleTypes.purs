module JSONSimpleTypes where

  import Prelude
  import Either
  import Eff
  import JSON
  
  -- Parsing of the simple JSON String, Number and Boolean types is provided
  -- out of the box.
  main = do
  
    Trace.trace $ case parseJSON "\"a JSON string\"" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> result :: String
      
    Trace.trace $ case parseJSON "42" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> show $ result :: Number
      
    Trace.trace $ case parseJSON "true" of
      Left err -> "Error parsing JSON:\n" ++ err
      Right result -> show $ result :: Boolean
