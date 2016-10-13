module Examples.Either where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (logShow, CONSOLE)
import Control.Monad.Except (runExcept)

import Data.Either (Either)
import Data.Foreign (F, parseJSON)
import Data.Foreign.Class (class IsForeign, readEitherR, readProp)

data Point = Point Number Number Number

instance showPoint :: Show Point where
  show (Point x y z) = "Point " <> show [x, y, z]

instance pointIsForeign :: IsForeign Point where
  read value = Point <$> readProp "x" value
                     <*> readProp "y" value
                     <*> readProp "z" value

type Response = Either (Array String) Point

main :: forall eff. Eff (console :: CONSOLE | eff) Unit
main = do
  logShow $ runExcept do
    json <- parseJSON """{ "x":1, "y": 2, "z": 3}"""
    readEitherR json :: F Response

  logShow $ runExcept do
    json <- parseJSON """["Invalid parse", "Not a valid y point"]"""
    readEitherR json :: F Response
