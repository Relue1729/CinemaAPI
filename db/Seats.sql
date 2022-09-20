CREATE TABLE Seats (
  id          SERIAL PRIMARY KEY,
  hall        INTEGER REFERENCES Halls(id),
  row         INTEGER NOT NULL
);