CREATE TABLE Timeslots (
  id          SERIAL PRIMARY KEY,
  filmId      INTEGER REFERENCES Films(id),
  hallId      INTEGER REFERENCES Halls(id),
  startTime   TIMESTAMPTZ NOT NULL,
  endTime     TIMESTAMPTZ NOT NULL,
  CHECK (startTime < endTime)
)