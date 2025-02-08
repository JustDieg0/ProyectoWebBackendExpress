const mysql = require('mysql');
require('dotenv').config();

const dbconfig = {
    host: process.env.MYSQL_ADDON_HOST,
    user: process.env.MYSQL_ADDON_USER,
    password: process.env.MYSQL_ADDON_PASSWORD,
    database: process.env.MYSQL_ADDON_DB
};

let conexion;

function conMysql() {
    conexion = mysql.createConnection(dbconfig);

    conexion.connect((err) => {
        if (err) {
            console.log('[db err]', err);
        } else {
            console.log('DB CONECTADA!!');
        }
    });

    conexion.on('error', err => {
        console.log('[db err]', err);
        if (err.code === 'PROTOCOL_CONNECTION_LOST') {
            conMysql();
        } else {
            throw err;
        }
    });

    return conexion;
}

function cerrarConexion() {
    if (conexion) {
        conexion.end((err) => {
            if (err) {
                console.log('[db err] Error al cerrar la conexión:', err);
            } else {
                console.log('Conexión cerrada exitosamente.');
            }
        });
    }
}

module.exports = { conMysql, cerrarConexion };