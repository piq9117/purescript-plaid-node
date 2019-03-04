-- | Item Product Access
module Plaid.Products where

import Plaid.Types

import Affjax (Response)
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((:=), (~>))
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Plaid (plaidRequest)
import Prelude (($))

newtype ReqBody = ReqBody
  { client_id :: String
  , secret :: String
  , access_token :: String
  }

instance encodeReqBody :: EncodeJson ReqBody where
  encodeJson (ReqBody {client_id, secret, access_token})
    = "client_id" := client_id
    ~> "secret" := secret
    ~> "access_token" := access_token
    ~> jsonEmptyObject

reqBody
  :: String
  -> String
  -> AccessToken
  -> ReqBody
reqBody client_id secret aToken =
  ReqBody
  { client_id: client_id
  , secret: secret
  , access_token: aToken
  }

-- | Retrieve Auth Request
getAuth
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getAuth pd aToken =
  plaidRequest "/auth/get" pd.env
   (Just $ json $ encodeJson $ reqBody pd.client_id pd.secret aToken)
