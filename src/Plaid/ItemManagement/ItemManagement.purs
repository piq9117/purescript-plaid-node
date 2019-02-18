module Plaid.ItemManagement where

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
import Plaid.Types (AccessToken)
import Prelude ((<<<), ($))

-- | Pull the accounts associated with the Item.
getAccounts
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getAccounts (PlaidClient { env, client_id, secret }) accessToken =
  plaidRequest "/accounts/get" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" secret <<<
          insert "client_id" client_id <<<
          insert "access_token" accessToken $ empty

getItem :: PlaidClient -> AccessToken -> Aff (Response (Either ResponseFormatError Json))
getItem (PlaidClient { env, client_id, secret }) accessToken =
  plaidRequest "/item/get" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" secret <<<
          insert "client_id" client_id <<<
          insert "access_token" accessToken $ empty
