// inciar servidor de express
const express = require('express');
const app = express();

const morgan = require('morgan');
const cors = require('cors');

app.use(morgan('dev'));
app.use(cors(''));

app.use(require('./routes/user.js'));

module.exports = app;


