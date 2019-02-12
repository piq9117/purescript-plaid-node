module Plaid where

import Prelude (class Show, ($), show)

type Options =
  { version :: String }

data Environments
  = Sandbox
  | Development
  | Production

envToStr :: Environments -> String
envToStr e =
  case e of
    Sandbox -> "sandbox"
    Development -> "development"
    Production -> "production"

data PlaidClient = PlaidClient
  { client_id :: String
  , secret :: String
  , public_key :: String
  , env :: String
  , client_request_opts :: Options
  }

instance showPlaid :: Show PlaidClient where
  show (PlaidClient { client_id
                   , secret
                   , public_key
                   , env
                   , client_request_opts
                   }) = show $
    { client_id: client_id
    , secret: secret
    , public_key: public_key
    , env: env
    , client_request_opts:(show client_request_opts)
    }

createPlaidClient
  :: { client_id :: String
     , secret :: String
     , public_key :: String
     , env :: Environments
     , client_request_opts :: Options
     }
  -> PlaidClient
createPlaidClient attr = PlaidClient (attr { env = (envToStr attr.env) })
