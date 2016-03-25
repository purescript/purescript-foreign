module Example.Objects where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)

import Data.Foreign (F)
import Data.Foreign.Class (class IsForeign, readJSON, readProp)

-- | To parse objects of a particular type, we need to define some helper
--   data types as making class instances for records is not possible.
data Point = Point { x :: Number, y :: Number }

instance showPoint :: Show Point where
  show (Point o) = "(Point { x: " <> show o.x <> ", y: " <> show o.y <> " })"

-- | The IsForeign implementations for these types are basically boilerplate,
--   type inference takes care of most of the work so we don't have to
--   explicitly define the type each of the properties we're parsing.
instance pointIsForeign :: IsForeign Point where
  read value = do
    x <- readProp "x" value
    y <- readProp "y" value
    pure $ Point { x: x, y: y }

main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ readJSON """{ "x": 1, "y": 2 }""" :: F Point
