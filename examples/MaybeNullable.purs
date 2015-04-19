module Example.MaybeNullable where

import Data.Foreign
import Data.Foreign.Null
import Data.Foreign.Class

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main = do
  Console.print $ runNull <$> readJSON "null" :: F (Null Boolean)
  Console.print $ runNull <$> readJSON "true" :: F (Null Boolean)
