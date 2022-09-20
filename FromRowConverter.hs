{-# LANGUAGE OverloadedStrings #-}

module FromRowConverter where

import Database.PostgreSQL.Simple.FromRow
import CinemaData


instance FromRow Reservation where
  fromRow = Reservation <$> field <*> field <*> field <*> field <*> field <*> field <*> field

instance FromRow Film where
  fromRow = Film <$> field <*> field <*> field <*> field

instance FromRow Timeslot where
  fromRow = Timeslot <$> field <*> field <*> field