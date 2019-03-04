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
import Plaid (plaidRequest)
import Plaid.Types (AccessToken, WebHook, PlaidClient)
import Prelude ((<<<), ($))

-- | Pull the accounts associated with the Item.
getAccounts
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getAccounts pd accessToken =
  plaidRequest "/accounts/get" pd.env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" pd.secret <<<
          insert "client_id" pd.client_id <<<
          insert "access_token" accessToken $ empty

-- | Pull the information about the Item.
getItem :: PlaidClient -> AccessToken -> Aff (Response (Either ResponseFormatError Json))
getItem pd accessToken =
  plaidRequest "/item/get" pd.env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" pd.secret <<<
          insert "client_id" pd.client_id <<<
          insert "access_token" accessToken $ empty

-- | Update the webhook associated with the Item.
updateWebHook
  :: PlaidClient
  -> AccessToken
  -> WebHook
  -> Aff (Response (Either ResponseFormatError Json))
updateWebHook pd accessToken webhook =
  plaidRequest "/item/webhook/update" pd.env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "secret" pd.secret <<<
          insert "client_id" pd.client_id <<<
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
invalidateAccesToken pd accessToken =
  plaidRequest "/item/access_token/invalidate" pd.env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "client_id" pd.client_id <<<
          insert "secret" pd.secret <<<
          insert "access_token" accessToken $ empty

-- | Remove an Item
-- | Once an item is removed, the `access_token` associated with the `Item` is
-- | no longer valid and cannote be used to access any data that was associated
-- | with the `Item`.
removeItem
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
removeItem pd accessToken =
  plaidRequest "/item/remove" pd.env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "client_id" pd.client_id <<<
          insert "secret" pd.secret <<<
          insert "access_token" accessToken $ empty
