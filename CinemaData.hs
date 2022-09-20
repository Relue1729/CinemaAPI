{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module CinemaData where

import Data.Int
import Data.Time
import Data.Aeson
import GHC.Generics


data Film = Film
  { filmId :: !Int,
    filmName :: !String,
    filmLength :: !String,
    filmDescription :: !String
  } deriving (Show, Generic)

instance FromJSON Film
instance ToJSON Film

data Timeslot = Timeslot
  { hallId :: !Int,
    startTime :: !UTCTime,
    endTime :: !UTCTime
  } deriving (Show, Generic)

instance FromJSON Timeslot
instance ToJSON Timeslot

data Reservation = Reservation
  { reservationId :: !Int,
    reservationFilmId :: !Int,
    reservationHallId :: !Int,
    reservationTimeSlotId :: !Int,
    reservationSeatId :: !Int,
    reservationUserName :: !String,
    reservationPaid :: !Bool
  }

instance FromJSON Reservation where
  parseJSON (Object o) =
    Reservation <$> o .:? "id" .!= 0
      <*> o .: "filmId"
      <*> o .: "hallId"
      <*> o .: "timeSlotId"
      <*> o .: "seatId"
      <*> o .: "userName"
      <*> o .: "paid"
  parseJSON _ = fail "Expected an object for Reservation"

instance ToJSON Reservation where
  toJSON (Reservation reservationId reservationFilmId reservationHallId reservationTimeSlotId reservationSeatId reservationUserName reservationPaid) =
    object
      [ "id" .= reservationId,
        "filmId" .= reservationFilmId,
        "hallId" .= reservationHallId,
        "timeSlotId" .= reservationTimeSlotId,
        "seatId" .= reservationSeatId,
        "userName" .= reservationUserName,
        "paid" .= reservationPaid
      ]