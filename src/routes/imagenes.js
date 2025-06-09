const { Router } = require("express");

const path = require('path');
const fs = require('fs');

const router = Router();

router.get('/img/departamento/:id', (req, res) => {
    const { id } = req.params;
    const rutaImagen = path.join(__dirname, '../img/departamento/', `${id}`);
    const imagenPorDefecto = path.join(__dirname, '../img/departamento/', 'imagen.png');

    fs.access(rutaImagen, fs.constants.F_OK, (err) => {
        if (err) {
            res.sendFile(imagenPorDefecto);
        } else {
            res.sendFile(rutaImagen);
        }
    });
});

router.get('/img/usuario/:id', (req, res) => {
    const { id } = req.params;
    const rutaImagen = path.join(__dirname, '../img/usuario/', `${id}`);
    const imagenPorDefecto = path.join(__dirname, '../img/usuario/', 'imagen.png');

    fs.access(rutaImagen, fs.constants.F_OK, (err) => {
        if (err) {
            res.sendFile(imagenPorDefecto);
        } else {
            res.sendFile(rutaImagen);
        }
    });
});

module.exports = router;