const conection = require('../db/mysql');

var pago = {}

pago.getPago = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select pagoid,contratoid,fecha_pago,monto,tipo_pago,metodo_pago from pago', (error,rows) => {
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

pago.getPagoById = (id,callback) => {
    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `SELECT pagoid,contratoid,fecha_pago,monto,tipo_pago,metodo_pago FROM pago WHERE pagoid = ${_id}`;
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

pago.insertPago = (pagoData,callback) => {
    con = conection.conMysql();
    if (con) 
    {
        con.query('call sp_addPago(?,?,?,?,?)', [pagoData.contratoid,pagoData.fecha_pago,pagoData.monto,pagoData.tipo_pago,pagoData.metodo_pago], (error, result) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

pago.updatePago = (id,datosPago,callback) => {
    
    con = conection.conMysql();
    if(con){
        var sql = `UPDATE pago SET ?  WHERE pagoid=?`;
        con.query(sql,[datosPago,id], (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

pago.deletePago = (id,callback) => {

    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `DELETE FROM pago WHERE pagoid = ${_id}`;
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

module.exports = pago;