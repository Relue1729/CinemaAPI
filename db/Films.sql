CREATE TABLE Films (
  id              SERIAL PRIMARY KEY,
  name            VARCHAR(100),
  length          INTERVAL not null
);
