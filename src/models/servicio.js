const conection = require('../db/mysql');

var servicio = {}

servicio.getServicio = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select servicioid,nombre,descripcion,precio from servicio', (error,rows) => {
            if(error){
                throw error;
            }else{
                res = {
                    status:"success",
                    data:rows
                }
                callback(null,res);
            }
            conection.cerrarConexion();
        });
    }
}

servicio.getServicioById = (id,callback) => {
    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `SELECT servicioid,nombre,descripcion,precio FROM servicio WHERE servicioid = ${_id}`;
        con.query(sql, (error,rows) => {
            if(error){
                throw error;
            }else{
                res = {
                    status:"success",
                    data:rows
                }
                callback(null,res);
            }
            conection.cerrarConexion();
        });
    }
}

servicio.insertServicio = (servicioData,callback) => {
    con = conection.conMysql();
    if (con) 
    {
        con.query('INSERT INTO servicio SET ?', servicioData, (error, result) => {
            if(error){
                throw error;
            }else{
                callback(null, {status:"success"});
            }
            conection.cerrarConexion();
        });
    }
}

servicio.updateServicio = (id,datosServicio,callback) => {
    const _id = con.escape(id);
    const _nombre = con.escape(datosServicio.nombre);

    con = conection.conMysql();
    if(con){
        var sql = `UPDATE servicio SET nombre=${_nombre} WHERE servicioid=${_id}`;
        con.query(sql, (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, {status:"success"});
            }
            conection.cerrarConexion();
        });
    }
}

servicio.deleteServicio = (id,callback) => {

    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `DELETE FROM servicio WHERE servicioid = ${_id}`;
        con.query(sql, (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, {status:"success"});
            }
            conection.cerrarConexion();
        });
    }
}

module.exports = servicio;