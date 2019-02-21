module Plaid.ItemManagement where

import Affjax (Response, ResponseFormatError(..))
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode.Class (encodeJson)
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Foreign.Object (empty, insert)
import Plaid (PlaidClient(..), plaidRequest)
import Plaid.Types (AccessToken, WebHook)
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

-- | Pull the information about the Item.
getItem :: PlaidClient -> AccessToken -> Aff (Response (Either ResponseFormatError Json))
getItem (PlaidClient { env, client_id, secret }) accessToken =
  plaidRequest "/item/get" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" secret <<<
          insert "client_id" client_id <<<
          insert "access_token" accessToken $ empty

-- | Update the webhook associated with the Item.
updateWebHook
  :: PlaidClient
  -> AccessToken
  -> WebHook
  -> Aff (Response (Either ResponseFormatError Json))
updateWebHook (PlaidClient { client_id, secret, env }) accessToken webhook =
  plaidRequest "/item/webhook/update" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" secret <<<
          insert "client_id" client_id <<<
          insert "access_token" accessToken <<<
          insert "webhook" webhook $ empty

-- | Rotate Access Token.
-- | By default, the `access_token` associated with an `Item` does not expire
-- | and should be stored in a persistent, secure manner.
-- | This function can be used to rotate the `access_token` associated with an
-- | `Item`. It returns a new `access_token` and immediately invalidates the
-- | previous `access_token`.
invalidateAccesToken
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
invalidateAccesToken (PlaidClient { client_id, secret, env }) accessToken =
  plaidRequest "/item/access_token/invalidate" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "client_id" client_id <<<
          insert "secret" secret <<<
          insert "access_token" accessToken $ empty
