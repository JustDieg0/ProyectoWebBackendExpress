const { pool } = require('../db/mysql')

var administrador = {}

administrador.loginAdministrador = (administradorData,callback) => {
    pool.query('SELECT * FROM administrador WHERE correo = ? AND contrasena = ?', [administradorData.correo,administradorData.contrasena], (error, rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null, res);
        }
    });
}

module.exports = administrador;