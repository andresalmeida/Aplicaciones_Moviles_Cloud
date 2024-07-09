// inciar servidor de express
const express = require('express');
const app = express();

const morgan = require('morgan');
const cors = require('cors');

app.use(morgan('dev'));
app.use(cors(''));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(require('./routes/user.js'));

module.exports = app;


