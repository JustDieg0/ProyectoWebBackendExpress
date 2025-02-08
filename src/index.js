const express = require('express');
const morgan = require('morgan');

const app = express();

//global
app.set("port",process.env.PORT || 3000);

//config
app.use(morgan("dev"));
app.use(express.json()); //hace que use json

//endpoints
app.use(require("./routes/administrador"));
app.use(require("./routes/usuario"));
app.use(require("./routes/contrato"));
app.use(require("./routes/habitacion"));
app.use(require("./routes/pago"));
app.use(require("./routes/garantia"));
app.use(require("./routes/contratoservicio"));
app.use(require("./routes/servicio.js"));

//server
app.listen(app.get("port"), () => {
    console.log(`Server Running at port ${app.get("port")}`);
})