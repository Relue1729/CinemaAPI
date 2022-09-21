CREATE TABLE Reservations(
  id          SERIAL  PRIMARY KEY,
  seatId      INTEGER REFERENCES Seats(id),
  timeslotId  INTEGER REFERENCES Timeslots (id),
  userName    VARCHAR(100) NOT NULL,
  paid        BOOL NOT NULL DEFAULT FALSE
);
CREATE UNIQUE INDEX UIX_Reservations ON Reservations (seatid, timeslotid);