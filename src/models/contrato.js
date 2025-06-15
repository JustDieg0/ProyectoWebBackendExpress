const conection = require('../db/mysql');
const { pool } = require('../db/mysql');

var contrato = {}

contrato.getContrato = (callback) => {
    pool.query('select contratoid,administradorid,usuarioid,departamentoid,garantiaid,fecha_inicio,fecha_fin,estado,monto from contrato', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

contrato.getContratoById = (id,callback) => {
    const _id = pool.escape(id);
    var sql = `SELECT contratoid,administradorid,usuarioid,departamentoid,garantiaid,fecha_inicio,fecha_fin,estado,monto FROM contrato WHERE contratoid = ${_id}`;
    pool.query(sql, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

contrato.insertContrato = (contratoData,callback) => {
    pool.query('call sp_addContrato(?,?,?,?,?,?,?,?)', [contratoData.usuarioid,contratoData.administradorid,contratoData.departamentoid,contratoData.garantiaid,contratoData.fecha_inicio,contratoData.fecha_fin,contratoData.estado,contratoData.monto], (error, result) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
        
    });
}

contrato.updateContrato = (id,datosContrato,callback) => {
    var sql = `UPDATE contrato SET ?  WHERE contratoid=?`;
    pool.query(sql,[datosContrato,id], (error,rows) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

contrato.deleteContrato = (id,callback) => {
    const _id = pool.escape(id);
    var sql = `DELETE FROM contrato WHERE contratoid = ${_id}`;
    pool.query(sql, (error,rows) => {
        if(error){
            throw error;
        }else{
            callback(null, rows.affectedRows);
        }
    });
}

module.exports = contrato;