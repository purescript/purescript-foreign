module Example.MaybeNullable where

import Prelude

import Data.Foreign
import Data.Foreign.Null
import Data.Foreign.Class
import Control.Monad.Eff.Console

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main = do
  print $ runNull <$> readJSON "null" :: F (Null Boolean)
  print $ runNull <$> readJSON "true" :: F (Null Boolean)
