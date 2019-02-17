module Plaid.Item
       ( exchangePublicToken
       ) where

import Affjax (Response)
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode.Class (encodeJson)
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Foreign.Object (empty, insert)
import Plaid (PlaidClient(..), plaidRequest)
import Prelude (($), (<<<))

reqBody :: PlaidClient -> Json
reqBody (PlaidClient { client_id, secret, public_token }) =
  encodeJson <<<
  insert "secret" secret <<<
  insert "public_token" public_token <<<
  insert "client_id" client_id $ empty

-- | exchanges `public_token` for an `access_token`
exchangePublicToken
  :: PlaidClient
  -> Aff (Response (Either ResponseFormatError Json))
exchangePublicToken pd@(PlaidClient { client_id, secret, public_token, env }) =
  plaidRequest "/item/public_token/exchange" env (Just <<< json <<< reqBody $ pd)
