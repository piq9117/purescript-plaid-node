module Plaid
       ( PlaidClient (..)
       , Options
       , Environments (..)
       , createPlaidClient
       , plaidRequest
       ) where

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

type Options =
  { version :: String }

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
  , public_token :: String
  , env :: Environments
  }

instance showPlaid :: Show PlaidClient where
  show (PlaidClient { client_id
                   , secret
                   , public_token
                   , env
                   }) = show $
    { client_id: client_id
    , secret: secret
    , public_token: public_token
    , env: (show env)
    }

createPlaidClient
  :: { client_id :: String
     , secret :: String
     , public_token :: String
     , env :: Environments
     }
  -> PlaidClient
createPlaidClient attr = PlaidClient attr

apiHosts :: Environments -> String
apiHosts env = 
  "https://" <> (show env) <> ".plaid.com"

plaidRequest
  :: String
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
