module Test.Main where

import Plaid
import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)

pl :: PlaidClient
pl =
  createPlaidClient
  { client_id : "client id"
  , secret : "secret"
  , public_key : "public key"
  , env: Sandbox
  , client_request_opts : {version : "2018-05-22"}
  }

main :: Effect Unit
main = do
  logShow pl
  log "You should add some tests."
