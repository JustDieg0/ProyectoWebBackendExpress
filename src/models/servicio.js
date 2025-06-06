const conection = require('../db/mysql');

var servicio = {}

servicio.getServicio = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select servicioid,nombre,descripcion,precio from servicio', (error,rows) => {
            if(error){
                throw error;
            }else{
                res = rows
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
                res = rows
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
        con.query('call sp_addServicio(?,?,?)', [servicioData.nombre,servicioData.descripcion,servicioData.precio], (error, result) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

servicio.updateServicio = (id,datosServicio,callback) => {
    
    con = conection.conMysql();
    if(con){
        var sql = `UPDATE servicio SET ?  WHERE servicioid=?`;
        con.query(sql,[datosServicio,id], (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
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
                callback(null, rows.affectedRows);
            }
            conection.cerrarConexion();
        });
    }
}

module.exports = servicio;