const mongoose = require('mongoose');

//CONEXION A LA BASE DE DATOS
async function connect() {
    try {
        await mongoose.connect('mongodb://localhost/flutter', {
            useUnifiedTopology: true,
        });
        console.log('Database: Conectada');
    } catch (error) {
        console.error('Error connecting to MongoDB:', error);
    }
}

module.exports = { connect };

