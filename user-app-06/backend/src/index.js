// INICIAR EL SERVIDOR
const app = require('./app');
const { connect } = require('./database');

async function main(){
    //database connection
    await connect();
    
    //conexion de app
    await app.listen(4000)
    console.log("Server on port 4000: Connected");
}

main();

// const express = require('express');
// const app = express();
// const { connect } = require('./database');

// // Middleware
// app.use(express.json());

// // Conexión a la base de datos
// connect();

// // Rutas
// app.use('/api', require('./routes/user'));

// // Puerto
// const PORT = process.env.PORT || 4000;

// // Iniciar servidor
// app.listen(PORT, () => {
//   console.log(`Server running on port ${PORT}`);
// });

