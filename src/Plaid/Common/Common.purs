module Plaid.Common where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, Fn3, runFn3)
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Exception (Error)
import Prelude (Unit)

type JSCallback a = Fn2 (Nullable Error) a Unit
type Callback a = Either Error a -> Effect Unit

foreign import handleCallbackImpl
  :: forall a.
  Fn3 (Error -> Either Error a)
  (a -> Either Error a)
  (Callback a)
  (JSCallback a)

handleCallback :: forall a. Callback a -> JSCallback a
handleCallback cb = runFn3 handleCallbackImpl Left Right cb
