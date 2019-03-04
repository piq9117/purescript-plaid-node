-- | Item Product Access
module Plaid.Products where

import Plaid.Types

import Affjax (Response)
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((:=), (~>))
import Data.Date (Date)
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Plaid (plaidRequest)
import Prelude (($), show)

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

type StartDate = Date
type EndDate = Date

newtype TransReqBody = TransReqBody
  { client_id :: String
  , secret :: String
  , access_token :: String
  , start_date :: String
  , end_date :: String
  }

instance encodeTransReqBody :: EncodeJson TransReqBody where
  encodeJson (TransReqBody req)
    = "client_id" := req.client_id
    ~> "secret" := req.secret
    ~> "access_token" := req.access_token
    ~> "start_date" := req.start_date
    ~> "end_date" := req.end_date
    ~> jsonEmptyObject

transReqBody
  :: PlaidClient
  -> AccessToken
  -> StartDate
  -> EndDate
  -> TransReqBody
transReqBody pd aToken sDate eDate =
  TransReqBody
    { client_id: pd.client_id
    , secret: pd.secret
    , access_token: aToken
    , start_date: (show sDate)
    , end_date: (show eDate)
    }

-- | Retrieve Transactions Request
getTransactions
  :: PlaidClient
  -> AccessToken
  -> StartDate
  -> EndDate
  -> Aff (Response (Either ResponseFormatError Json))
getTransactions pd aToken sDate eDate =
  plaidRequest "/transactions/get" pd.env
   (Just $ json $ encodeJson $ transReqBody pd aToken sDate eDate)
