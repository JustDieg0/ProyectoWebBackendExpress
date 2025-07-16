const express = require('express');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');
const cors = require('cors');

const app = express();

//config
app.use(morgan("dev"));
app.use(express.json()); //hace que use json
app.use(cors({
  origin: 'http://localhost:3000', // dirección de tu frontend
  credentials: true // NECESARIO para enviar cookies
}));
app.use(cookieParser());

//endpoints
//app.use(require("./routes/administrador"));
app.use(require("./routes/usuario"));
app.use(require("./routes/contrato"));
app.use(require("./routes/departamento"));
app.use(require("./routes/reserva"));
app.use(require("./routes/pago"));
app.use(require("./routes/garantia"));
/*app.use(require("./routes/contratoservicio"));
app.use(require("./routes/servicio.js"));*/
app.use(require("./routes/login.js"));
app.use(require("./routes/imagenes.js"));

module.exports = app;