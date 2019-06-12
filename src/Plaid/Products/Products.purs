-- | Item Product Access
module Plaid.Products
       ( getAuth
       , getTransactions
       , getBalance
       , getIdentity
       , getIncome
       , createAssetReport
       , refreshAssetReport
       , filterAssetReport
       , getAssetReport
       , getAssetPdfReport
       ) where

import Affjax (Response)
import Affjax.RequestBody (json)
import Affjax.ResponseFormat (ResponseFormatError)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((:=), (~>))
import Data.Either (Either, either)
import Data.Formatter.DateTime (formatDateTime)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Plaid (plaidRequest)
import Plaid.Types (PlaidClient, AccessToken, StartDate, EndDate, AssetReportToken, DaysRequested)
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

-- formatDate :: DateTime -> Either String String
-- formatDate = formatDateTime "YYYY-MM-DD"

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
    where
      formatDate = formatDateTime "YYYY-MM-DD"

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
getIncome pd atoken =
  plaidRequest "/income/get" pd.env
    (Just $ json $ encodeJson $ reqBody pd.client_id pd.secret atoken)

data CreateAssetReportReqBody = CreateAssetReportReqBody
  { client_id :: String
  , secret :: String
  , access_tokens :: Array String
  , days_requested :: Int
  }

instance encodeCreateAssetRepReqBody :: EncodeJson CreateAssetReportReqBody where
  encodeJson (CreateAssetReportReqBody { client_id, secret, access_tokens, days_requested })
    = "client_id" := client_id
    ~> "secret" := secret
    ~> "access_tokens" := access_tokens
    ~> "days_requested" := days_requested
    ~> jsonEmptyObject

caReqBody
  :: String
  -> String
  -> Array String
  -> DaysRequested
  -> CreateAssetReportReqBody
caReqBody clientId secret atokens dr =
  CreateAssetReportReqBody
  { client_id: clientId
  , secret: secret
  , access_tokens: atokens
  , days_requested: dr
  }

-- | Create an Asset Report
createAssetReport
  :: PlaidClient
  -> Array AccessToken
  -> DaysRequested
  -> Aff (Response (Either ResponseFormatError Json))
createAssetReport pd atokens dr =
  plaidRequest "/asset_report/create" pd.env
    (Just $ json $ encodeJson $ caReqBody pd.client_id pd.secret atokens dr)

data RefAssetReportReqBody = RefAssetReportReqBody
  { days_requested :: Int
  , asset_report_token :: String
  , client_id :: String
  , secret :: String
  }

instance encodeRefAsstRepReqBody :: EncodeJson RefAssetReportReqBody where
  encodeJson (RefAssetReportReqBody { days_requested
                                    , asset_report_token
                                    , client_id, secret
                                    })
    = "days_requested" := days_requested
    ~> "asset_report_token" := asset_report_token
    ~> "client_id" := client_id
    ~> "secret" := secret
    ~> jsonEmptyObject

refAsstReqBody
  :: PlaidClient
  -> AssetReportToken
  -> DaysRequested
  -> RefAssetReportReqBody
refAsstReqBody pd art dr =
  RefAssetReportReqBody
  { asset_report_token: art
  , days_requested: dr
  , client_id: pd.client_id
  , secret: pd.secret
  }

-- | Refresh an Asset Report
refreshAssetReport
  :: PlaidClient
  -> AssetReportToken
  -> DaysRequested
  -> Aff (Response (Either ResponseFormatError Json))
refreshAssetReport pd art dr =
  plaidRequest "/asset_report/refresh" pd.env
    (Just $ json $ encodeJson $ refAsstReqBody pd art dr)

data FilterAssetReqBody = FilterAssetReqBody
  { client_id :: String
  , secret :: String
  , asset_report_token :: String
  , account_ids_to_exclude :: Array String
  }

instance encodeFiltAsstReqBody :: EncodeJson FilterAssetReqBody where
  encodeJson (FilterAssetReqBody { client_id, secret, asset_report_token, account_ids_to_exclude })
    = "client_id" := client_id
    ~> "secret" := secret
    ~> "asset_report_token" := asset_report_token
    ~> "account_ids_to_exclude" := account_ids_to_exclude
    ~> jsonEmptyObject

type AccountToExclude = String

filtAsstReqBody
  :: PlaidClient
  -> AssetReportToken
  -> Array AccountToExclude
  -> FilterAssetReqBody
filtAsstReqBody pd art act =
  FilterAssetReqBody
  { client_id: pd.client_id
  , secret: pd.secret
  , account_ids_to_exclude: act
  , asset_report_token: art
  }

filterAssetReport
  :: PlaidClient
  -> AssetReportToken
  -> Array AccountToExclude
  -> Aff (Response (Either ResponseFormatError Json))
filterAssetReport pd art act =
  plaidRequest "/asset_report/filter" pd.env
    (Just $ json $ encodeJson $ filtAsstReqBody pd art act)

data GetAssetReportReqBody = GetAssetReportReqBody
  { client_id :: String
  , secret :: String
  , asset_report_token :: String
  }

instance encodeGetAssetReportReqbody :: EncodeJson GetAssetReportReqBody where
  encodeJson (GetAssetReportReqBody req)
    =  "client_id" := req.client_id
    ~> "secret" := req.secret
    ~> "asset_report_token" := req.asset_report_token
    ~> jsonEmptyObject

getAsstReqBody
  :: PlaidClient
  -> AssetReportToken
  -> GetAssetReportReqBody
getAsstReqBody pd art =
  GetAssetReportReqBody
  { client_id: pd.client_id
  , secret: pd.secret
  , asset_report_token: art
  }

-- | Retrieve an Asset Report
getAssetReport
  :: PlaidClient
  -> AssetReportToken
  -> Aff (Response (Either ResponseFormatError Json))
getAssetReport pd art =
  plaidRequest "/asset_report/get" pd.env
  (Just $ json $ encodeJson $ getAsstReqBody pd art)

getAssetPdfReport
  :: PlaidClient
  -> AssetReportToken
  -> Aff (Response (Either ResponseFormatError Json))
getAssetPdfReport pd art =
  plaidRequest "/asset_report/pdf/get" pd.env
  (Just $ json $ encodeJson $ getAsstReqBody pd art)
