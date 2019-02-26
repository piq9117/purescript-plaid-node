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
import Plaid (PlaidClient(..), PlaidOptions, plaidRequest)
import Prelude ((<<<), ($))

newtype ReqBody = ReqBody
  { client_id :: String
  , secret :: String
  , options :: PlaidOptions
  , access_token :: String
  }

instance encodeReqBody :: EncodeJson ReqBody where
  encodeJson (ReqBody req)
    = "client_id" := req.client_id
    ~> "secret" := req.secret
    ~> "options" := req.options
    ~> "access_token" := req.access_token
reqBody
  :: String
  -> String
  -> AccessToken
  -> Maybe PlaidOptions
  -> ReqBody
reqBody client_id secret accessToken mOps =
  case mOps of
    Nothing -> ReqBody
      { client_id: client_id
      , secret: secret
      , options: { version: Nothing, account_ids: [] }
      , access_token: accessToken
      }
    Just ops -> ReqBody
      { client_id: client_id
      , secret: secret
      , options: ops
      , access_token: accessToken
      }

-- | Retrieve Auth Request
getAuth
  :: PlaidClient
  -> AccessToken
  -> Maybe PlaidOptions
  -> Aff (Response (Either ResponseFormatError Json))
getAuth (PlaidClient { client_id, secret, env }) accessToken mOps =
  plaidRequest "/auth/get" env
    (Just <<< json <<< encodeJson $ reqBody client_id secret accessToken mOps)
