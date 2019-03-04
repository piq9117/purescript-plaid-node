-- | Item Product Access
module Plaid.Products where

import Plaid.Types

import Affjax (Response)
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((:=), (~>))
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Plaid (plaidRequest)
import Prelude ((<<<), ($))

newtype ReqBody = ReqBody
  { client_id :: String
  , secret :: String
  , access_token :: String
  }

instance encodeReqBody :: EncodeJson ReqBody where
  encodeJson (ReqBody req)
    = "client_id" := req.client_id
    ~> "secret" := req.secret
    ~> "access_token" := req.access_token

reqBody
  :: String
  -> String
  -> AccessToken
  -> ReqBody
reqBody client_id secret accessToken =
  ReqBody
  { client_id: client_id
  , secret: secret
  , access_token: accessToken
  }

-- | Retrieve Auth Request
getAuth
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getAuth pd accessToken =
  plaidRequest "/auth/get" pd.env
  (Just <<< json <<< encodeJson $ reqBody pd.client_id pd.secret accessToken)
