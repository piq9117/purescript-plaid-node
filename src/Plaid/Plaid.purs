module Plaid
       ( defaultPlaidClient
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
import Prelude (show, (<>))

defaultPlaidClient :: PlaidClient
defaultPlaidClient =
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
