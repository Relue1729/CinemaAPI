{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Monoid (mconcat)
import Database.PostgreSQL.Simple
import Web.Scotty
import Network.Wai.Middleware.HttpAuth
import Controller

dbConnectInfo :: ConnectInfo
dbConnectInfo =
  defaultConnectInfo
    { connectHost = "jelani.db.elephantsql.com",
      connectDatabase = "hvfffksy",
      connectUser = "hvfffksy",
      connectPassword = "mwWPQZaJoYeSE0zM8AyedabheDiYYb7R"
    }

routes :: Connection -> IO ()
routes connection = scotty 3000 $ do
  middleware $ basicAuth (\u p -> return $ u == "admin" && p == "pass") "My Realm"
  get "/" $ do
    html "[GET] /api/films - Get list of all films screening in the future <br>\
        \ [GET] /api/films/id - Get times for a film screening <br>\
        \ [POST]/api/reserve - Reserve a seat for a movie screening"
  get "/api/films" $ getFilms connection
  get "/api/films/:id" $ getTimeslots connection
  post "/api/reserve/" $ reserveSeat connection

main :: IO ()
main = do
  connection <- connect dbConnectInfo
  routes connection