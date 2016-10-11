module Example.MaybeNullable where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Control.Monad.Except (runExcept)

import Data.Foreign (F, unsafeFromForeign)
import Data.Foreign.Class (readJSON, write)
import Data.Foreign.Null (Null(..), unNull)
import Data.Maybe (Maybe(..))

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ unNull <$> runExcept (readJSON "null" :: F (Null Boolean))
  logShow $ unNull <$> runExcept (readJSON "true" :: F (Null Boolean))
  log $ unsafeFromForeign $ write $ Null Nothing :: Null Boolean
  log $ unsafeFromForeign $ write $ Null $ Just true
