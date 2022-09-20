{-# LANGUAGE OverloadedStrings #-}

module Controller
  ( getFilms,
    getTimeslots,
    reserveSeat
  )
where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import Database.PostgreSQL.Simple
import Network.HTTP.Types.Status (Status, status200, status201, status400)
import Web.Scotty (ActionM, jsonData, param, post, status, text)
import CinemaData
import FromRowConverter
import qualified Web.Scotty as Scotty


getFilms :: Connection -> ActionM ()
getFilms connection = do
  films <- liftIO $ query_ connection "select distinct f.Id, f.Name, cast (f.Length as varchar), f.Description from films f \
                                      \join timeslots t on f.id = t.filmid where t.starttime > CURRENT_TIMESTAMP \
                                      \order by f.id" :: ActionM [Film]
  status status200
  Scotty.json $ object ["films" .= films]


getTimeslots :: Connection -> ActionM ()
getTimeslots connection = do
  _filmId <- param "id" :: ActionM Int
  let result = query connection "select t.hallid, t.starttime, t.endtime from Timeslots t \
                                \join films f on f.id = t.filmid \
                                \where t.starttime > CURRENT_TIMESTAMP \
                                \and f.id = ?" (Only _filmId)
  timeslots <- liftIO result :: ActionM [Timeslot]
  case timeslots of
    [] -> do
      status status400
      Scotty.json $ object ["error" .= ("Timeslots not found for film id "  ++ show (_filmId) :: String)]
    _ -> do
      status status200
      Scotty.json $ object ["timeslots" .= timeslots]


reserveSeat :: Connection -> ActionM ()
reserveSeat connection = do
  (Reservation _ _filmId _hallId _timeSlotId _seatId _userName _paid) <- jsonData :: ActionM Reservation
  exists <- liftIO $ reservationExists connection _hallId _seatId _timeSlotId
  if exists 
    then do
      status status400
      Scotty.json $ object ["error" .= ("Reservation already exists" :: String)]
    else insertReservation connection


insertReservation :: Connection -> ActionM()
insertReservation connection = do
  (Reservation _ _filmId _hallId _timeSlotId _seatId _userName _paid) <- jsonData :: ActionM Reservation
  let result = execute connection "INSERT INTO reservations (filmId, hallId, timeSlotId, seatId, userName, paid) \
                                  \VALUES (?, ?, ?, ?, ?, ?)"
                                  (_filmId, _hallId, _timeSlotId, _seatId, _userName, _paid)
  x <- liftIO result
  if x > 0 
    then do
      status status201
      Scotty.json $ object ["message" .= ("Reservation created" :: String)]
    else do
      status status400
      Scotty.json $ object ["error" .= ("Reservation not created" :: String)]


reservationExists :: Connection -> Int -> Int -> Int -> IO Bool
reservationExists connection _hallid _seatid _timeslotid = do
  [Only x] <- query connection "SELECT COUNT(*) FROM reservations WHERE hallid = ? AND seatid = ? AND timeslotid = ?" 
                               (_hallid, _seatid, _timeslotid) :: IO [Only Int]
  return $ x > 0