-- | Item Product Access
module Plaid.Products where

import Plaid.Types (AccessToken, PlaidClient)

import Affjax (Response)
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((:=), (~>))
import Data.DateTime (DateTime)
import Data.Either (Either, either)
import Data.Formatter.DateTime (formatDateTime)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Plaid (plaidRequest)
import Prelude (($), identity)

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

type StartDate = DateTime
type EndDate = DateTime

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

formatDate :: DateTime -> Either String String
formatDate = formatDateTime "YYYY-MM-DD"

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
    , start_date: (either identity identity $ formatDate sDate)
    , end_date: (either identity identity $ formatDate eDate)
    }

-- | Retrieve Transactions Request
-- | Allows you to receive user-authorized transaction data for credit
-- | and depository-type accounts.
getTransactions
  :: PlaidClient
  -> AccessToken
  -> StartDate
  -> EndDate
  -> Aff (Response (Either ResponseFormatError Json))
getTransactions pd aToken sDate eDate =
  plaidRequest "/transactions/get" pd.env
   (Just $ json $ encodeJson $ transReqBody pd aToken sDate eDate)

-- | Retrieve Balance Requests
-- | Returns the real-time balnace for each of an `Item's` accounts.
-- | It can be used for existing `Items` added via any of Plaid's products.
getBalance
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getBalance pd atoken =
  plaidRequest "/accounts/balance/get" pd.env
    (Just $ json $ encodeJson $ reqBody pd.client_id pd.secret atoken)

-- | Retrieve Identity Request
-- | Allows you to retrieve various account holder information on file with the
-- | financial institution, including names, emails, phone numbers, and addresses.
getIdentity
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getIdentity pd atoken =
  plaidRequest "/identity/get" pd.env
    (Just $ json $ encodeJson $ reqBody pd.client_id pd.secret atoken)

-- | Retrieve Income Request
-- | Allows you to retrieve information pertaining to an `Item`'s income.
-- | In addition to the annual income, detailed information will be provided
-- | for each contributing income stream (or job.)
getIncome
  :: PlaidClient
  -> AccessToken
  -> Aff (Response (Either ResponseFormatError Json))
getIncome plaidClient pd atoken =
  plaidRequest "/income/get" pd.env
    (Just $ json $ encodeJson $ reqBody pd.client_id pd.secret atoken)
