require('dotenv').config();
var express = require('express');
var app = express();
var uuid = require('node-uuid');
var pg = require('pg');

const conString = {
  user: process.env.DBUSER,
  database: process.env.DB,
  password: process.env.DBPASS,
  host: process.env.DBHOST,
  port: process.env.DBPORT,
  ssl: {
    rejectUnauthorized: false
  }
};

const Pool = pg.Pool;
const pool = new Pool(conString);

// Routes
app.get('/api/status', function (req, res) {
  pool.connect((err, client, release) => {
    if (err) {
      console.error('Error acquiring client', err.stack);
      return res.status(500).json({ error: 'Database connection failed', details: err.message });
    }
    client.query('SELECT now() as time', (err, result) => {
      release();
      if (err) {
        console.error('Error executing query', err.stack);
        return res.status(500).json({ error: 'Query execution failed' });
      }
      res.status(200).send(result.rows);
    });
  });
});

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers
// production error handler
app.use(function (err, req, res, next) {
  res.status(err.status || 500);
  res.json({
    message: err.message,
    error: {}
  });
});

module.exports = app;
