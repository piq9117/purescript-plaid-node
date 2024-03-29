module Plaid.Tokens
       ( exchangePublicToken
       , createPublicToken
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
import Plaid (plaidRequest)
import Prelude (($), (<<<))
import Plaid.Types (AccessToken, PlaidClient, PublicToken)
import Plaid.Schema

-- | exchanges `public_token` for an API `access_token`.
exchangePublicToken
  :: PlaidClient
  -> PublicToken
  -> Aff (Response (Either ResponseFormatError Json))
exchangePublicToken pd public_token =
  plaidRequest linkSchema.exchangeToken pd.env reqBody
  where reqBody = Just <<< json $
          encodeJson <<<
          insert "secret" pd.secret <<<
          insert "public_token" public_token <<<
          insert "client_id" pd.client_id $ empty

-- | Create a public_token.
createPublicToken
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
createPublicToken pd accessToken =
  plaidRequest linkSchema.createToken pd.env reqBody
  where
    reqBody = Just <<< json $ encodeJson <<<
              insert "client_id" pd.client_id <<<
              insert "secret" pd.secret <<<
              insert "access_token" accessToken $ empty
