const { pool } = require('../db/mysql')

var departamento = {}

departamento.getDepartamento = (callback) => {
    pool.query('select departamentoid,nombre,descripcion,tipo,precio_mensual,estado,aforo,ubicacion,activo from departamento', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

departamento.getDepartamentoById = (id,callback) => {
    const _id = pool.escape(id);
    var sql = `select departamentoid,nombre,descripcion,tipo,precio_mensual,estado,aforo,ubicacion,activo from departamento WHERE departamentoid = ${_id}`;
    pool.query(sql, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

departamento.insertDepartamento = (departamentoData,callback) => {
    pool.query('call sp_addDepartamento(?,?,?,?,?,?,?)', [departamentoData.nombre,departamentoData.descripcion,departamentoData.tipo,departamentoData.precio_mensual,departamentoData.estado,departamentoData.aforo,departamentoData.ubicacion], (error, result) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

departamento.updateDepartamento = (id,datosDepartamento,callback) => {
    var sql = `UPDATE departamento SET ?  WHERE departamentoid=?`;
    pool.query(sql,[datosDepartamento,id], (error,rows) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

departamento.deleteDepartamento = (id,callback) => {
    const _id = pool.escape(id);
    var sql = `DELETE FROM departamento WHERE departamentoid = ${_id}`;
    pool.query(sql, (error,rows) => {
        if(error){
            throw error;
        }else{
            callback(null, rows.affectedRows);
        }
    });
}

departamento.getActiveAndDisponibleDepartamento = (callback) => {
    pool.query('select departamentoid,nombre,descripcion,tipo,precio_mensual,estado,aforo,ubicacion from departamento where activo=1 AND estado="disponible"', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

departamento.getDepartamentosEliminados = (callback) => {
    pool.query('SELECT departamentoid, nombre, descripcion, tipo, precio_mensual, estado, aforo, ubicacion, activo FROM departamento WHERE activo = 0', (error, rows) => {
        if (error) {
            throw error;
        } else {
            callback(null, rows);
        }
    });
}

departamento.getActiveAndDisponibleDepartamento = (callback) => {
    pool.query('select departamentoid,nombre,descripcion,tipo,precio_mensual,estado,aforo,ubicacion from departamento where activo=1 AND estado="disponible"', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

module.exports = departamento;