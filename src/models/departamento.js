const conection = require('../db/mysql');

var departamento = {}

departamento.getDepartamento = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select departamentoid,nombre,descripcion,tipo,precio_mensual,estado,aforo,ubicacion from departamento', (error,rows) => {
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

departamento.getDepartamentoById = (id,callback) => {
    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `select departamentoid,nombre,descripcion,tipo,precio_mensual,estado,aforo,ubicacion from departamento WHERE departamentoid = ${_id}`;
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

departamento.insertDepartamento = (departamentoData,callback) => {
    con = conection.conMysql();
    if (con) 
    {
        con.query('call sp_addDepartamento(?,?,?,?,?,?,?)', [departamentoData.nombre,departamentoData.descripcion,departamentoData.tipo,departamentoData.precio_mensual,departamentoData.estado,departamentoData.aforo,departamentoData.ubicacion], (error, result) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

departamento.updateDepartamento = (id,datosDepartamento,callback) => {
    
    con = conection.conMysql();
    if(con){
        var sql = `UPDATE departamento SET ?  WHERE departamentoid=?`;
        con.query(sql,[datosDepartamento,id], (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

departamento.deleteDepartamento = (id,callback) => {

    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `DELETE FROM departamento WHERE departamentoid = ${_id}`;
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

module.exports = departamento;