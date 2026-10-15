module Example.Util.Value where

import Prelude

import Control.Monad.Except (Except)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.List.NonEmpty (NonEmptyList)

import Foreign (Foreign, ForeignError(..), fail)

foreign import foreignValueImpl :: forall r. Fn3 (String -> r) (Foreign -> r) String r

foreignValue :: String -> Except (NonEmptyList ForeignError) Foreign
foreignValue json = runFn3 foreignValueImpl (fail <<< ForeignError) pure json
