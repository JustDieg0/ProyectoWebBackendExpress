const conection = require('../db/mysql');

var garantia = {}

garantia.getGarantia = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select garantiaid,monto,estado from garantia', (error,rows) => {
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

garantia.getGarantiaById = (id,callback) => {
    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `SELECT garantiaid,monto,estado FROM garantia WHERE garantiaid = ${_id}`;
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

garantia.insertGarantia = (garantiaData,callback) => {
    con = conection.conMysql();
    if (con) 
    {
        con.query('call sp_addGarantia(?,?)', [garantiaData.monto,garantiaData.estado], (error, result) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

garantia.updateGarantia = (id,datosGarantia,callback) => {
    
    con = conection.conMysql();
    if(con){
        var sql = `UPDATE garantia SET ?  WHERE garantiaid=?`;
        con.query(sql,[datosGarantia,id], (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

garantia.deleteGarantia = (id,callback) => {

    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `DELETE FROM garantia WHERE garantiaid = ${_id}`;
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

module.exports = garantia;