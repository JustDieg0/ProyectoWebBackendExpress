const conection = require('../db/mysql');

var contrato_servicio = {}

contrato_servicio.getContrato_servicio = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select contratoid,servicioid,cantidad from contrato_servicio', (error,rows) => {
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

contrato_servicio.getContrato_servicioById = (id,callback) => {
    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `SELECT contratoid,servicioid,cantidad FROM contrato_servicio WHERE contrato_servicioid = ${_id}`;
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

contrato_servicio.insertContrato_servicio = (contrato_servicioData,callback) => {
    con = conection.conMysql();
    if (con) 
    {
        con.query('insert into contrato_servicio (contratoid, servicioid, cantidad) values (?,?,?)', [contrato_servicio.contratoid,contrato_servicioData.servicioid,contrato_servicioData.cantidad], (error, result) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

contrato_servicio.updateContrato_servicio = (id,datosContrato_servicio,callback) => {
    
    con = conection.conMysql();
    if(con){
        var sql = `UPDATE contrato_servicio SET ?  WHERE contrato_servicioid=?`;
        con.query(sql,[datosContrato_servicio,id], (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

contrato_servicio.deleteContrato_servicio = (id,callback) => {

    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `DELETE FROM contrato_servicio WHERE contrato_servicioid = ${_id}`;
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

module.exports = contrato_servicio;