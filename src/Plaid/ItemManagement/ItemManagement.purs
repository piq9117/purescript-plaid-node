module Plaid.ItemManagement where

import Plaid.Types

import Plaid (PlaidClient(..), plaidRequest)
import Data.Argonaut.Encode.Class (encodeJson)
import Prelude((<<<), ($))
import Data.Maybe (Maybe(..))
import Affjax.RequestBody (json)
import Foreign.Object (empty, insert)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json)
import Effect.Aff (Aff)
import Affjax (Response)
import Data.Either (Either)

-- | Retrieve Accounts
getAccounts
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getAccounts (PlaidClient { env, client_id, secret }) accessToken =
  plaidRequest "/accounts/get" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "access_token" accessToken $ empty
