module MaybeNullable where

import Data.Maybe
import Data.Either
import Data.Foreign
import Data.Foreign.Null
import Data.Foreign.Class
import Control.Monad.Eff
import Debug.Trace

-- Parsing values that are allowed to null or undefined is possible by 
-- using Maybe types.
main = do
  print $ runNull <$> readJSON "null" :: F (Null Boolean)
  print $ runNull <$> readJSON "true" :: F (Null Boolean)
