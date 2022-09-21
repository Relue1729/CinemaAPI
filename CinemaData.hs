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
    reservationTimeSlotId :: !Int,
    reservationSeatId :: !Int,
    reservationUserName :: !String,
    reservationPaid :: !Bool
  }

instance FromJSON Reservation where
  parseJSON (Object o) =
    Reservation <$> o .:? "id" .!= 0
      <*> o .: "timeSlotId"
      <*> o .: "seatId"
      <*> o .: "userName"
      <*> o .: "paid"
  parseJSON _ = fail "Expected an object for Reservation"

instance ToJSON Reservation where
  toJSON (Reservation reservationId reservationTimeSlotId reservationSeatId reservationUserName reservationPaid) =
    object
      [ "id" .= reservationId,
        "timeSlotId" .= reservationTimeSlotId,
        "seatId" .= reservationSeatId,
        "userName" .= reservationUserName,
        "paid" .= reservationPaid
      ]