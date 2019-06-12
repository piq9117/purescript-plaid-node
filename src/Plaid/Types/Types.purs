module Plaid.Types
       ( AccessToken
       , PublicToken
       , Path
       , WebHook
       , PlaidClient
       , PlaidOptions
       , Environments (..)
       , StartDate
       , EndDate
       ) where

import Data.Maybe (Maybe)
import Prelude (class Show)
import Data.DateTime (DateTime)

type AccessToken = String
type PublicToken = String
type Path = String
type WebHook = String

type PlaidClient =
  { client_id :: String
  , secret :: String
  , env :: Environments
  }

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

type StartDate = DateTime
type EndDate = DateTime
