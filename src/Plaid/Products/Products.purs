module Products where

import Plaid.Types

import Affjax (Response)
import Affjax.ResponseFormat (ResponseFormatError)
import Affjax.RequestBody (json)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode.Class (encodeJson)
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Plaid (PlaidClient(..), plaidRequest)
import Prelude ((<<<), ($))
import Foreign.Object (insert, empty)
  
getAuth
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getAuth (PlaidClient { client_id, secret, env }) accessToken =
  plaidRequest "/auth/get" env reqBody
  where reqBody =
          Just <<< json $ encodeJson <<<
          insert "client_id" client_id <<<
          insert "secret" secret <<<
          insert "access_token" accessToken $ empty

