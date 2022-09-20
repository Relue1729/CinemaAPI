# CinemaAPI
Small Haskell WebAPI using Scotty as web framework

Basic idea: API to manage seat reservation at the movie theatre and to look up what movies will be shown in the future

Endpoints:
- [GET]  / - Basic info about endpoints
- [GET]  /api/film - Get list of all films screening in the future
- [GET]  /api/film/id - Get times for a film screening (and which cinema halls they will be shown in)
- [POST] /api/reserve - Reserve a seat for a movie screening, accepts JSON

DB used: PostgreSQL (connection to cloud DB ElephantSQL with sample data is already set up in Main.hs, table create scripts are provided in the db folder)  
All endpoints require Basic Auth to access (username: admin password: pass)
