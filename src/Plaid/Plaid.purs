module Plaid
       ( PlaidClient (..)
       , PlaidOptions
       , Environments (..)
       , defaultPlaidClient
       , plaidRequest
       ) where

import Plaid.Types

import Affjax (Response, ResponseFormatError, request, defaultRequest)
import Affjax.RequestBody (RequestBody)
import Affjax.RequestHeader (RequestHeader(..))
import Affjax.ResponseFormat (json)
import Data.Argonaut.Core (Json)
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe)
import Data.MediaType (MediaType(..))
import Effect.Aff (Aff)
import Prelude (class Show, ($), show, (<>))

type PlaidOptions =
  { version :: Maybe String
  , account_ids :: Array String
  }

data Environments
  = Sandbox
  | Development
  | Production

instance showEnvironments :: Show Environments where
  show Sandbox = "sandbox"
  show Development = "development"
  show Production = "production"

data PlaidClient = PlaidClient
  { client_id :: String
  , secret :: String
  , env :: Environments
  }

instance showPlaid :: Show PlaidClient where
  show (PlaidClient { client_id , secret , env }) = show $
    { client_id: client_id
    , secret: secret
    , env: (show env)
    }

defaultPlaidClient :: PlaidClient
defaultPlaidClient = PlaidClient
  { client_id: ""
  , secret: ""
  , env: Sandbox
  }

apiHosts :: Environments -> String
apiHosts env =
  "https://" <> (show env) <> ".plaid.com"

plaidRequest
  :: Path
  -> Environments
  -> Maybe RequestBody
  -> Aff (Response (Either ResponseFormatError Json))
plaidRequest path env body = request
  (defaultRequest { url = apiHosts env <> path
                  , method = Left POST
                  , responseFormat = json
                  , content = body
                  , headers = [ContentType (MediaType "application/json")]
                  })
