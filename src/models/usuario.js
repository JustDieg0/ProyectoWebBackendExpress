
const { pool } = require('../db/mysql')

var usuario = {}

usuario.getUsuario = (callback) => {
    pool.query('select usuarioid,nombres,apellidos,telefono,nacionalidad,doc_ident,correo,contrasena,activo from usuario', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.getUsuarioById = (id,callback) => {
    const _id = pool.escape(id);
    var sql = `SELECT usuarioid,nombres,apellidos,telefono,nacionalidad,doc_ident,correo,contrasena,activo FROM usuario WHERE usuarioid = ${_id}`;
    pool.query(sql, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.insertUsuario = (usuarioData,callback) => {
    pool.query('call sp_addUsuario(?,?,?,?,?,?,?)', [usuarioData.nombres,usuarioData.apellidos,usuarioData.telefono,usuarioData.nacionalidad,usuarioData.doc_ident,usuarioData.correo,usuarioData.contrasena], (error, result) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

usuario.updateUsuario = (id,datosUsuario,callback) => {
    var sql = `UPDATE usuario SET ?  WHERE usuarioid=?`;
    pool.query(sql,[datosUsuario,id], (error,rows) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

usuario.deleteUsuario = (id,callback) => {
    const _id = pool.escape(id);
    var sql = `DELETE FROM usuario WHERE usuarioid = ${_id}`;
    pool.query(sql, (error,rows) => {
        if(error){
            throw error;
        }else{
            callback(null, rows.affectedRows);
        }
    });
}

usuario.loginUsuario = (usuarioData,callback) => {
    pool.query('SELECT * FROM usuario WHERE correo = ? AND contrasena = ?', [usuarioData.correo,usuarioData.contrasena], (error, rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null, res);
        }
    });
}

usuario.getCountUsuario = (callback) => {
    pool.query('select COUNT(*) AS cantidad from usuario WHERE activo = 1', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.getCountContrato = (callback) => {
    pool.query('select COUNT(*) AS cantidad from contrato WHERE estado = "activo"', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.getCountPagos = (callback) => {
    pool.query('SELECT SUM(total_pagos) AS cantidad FROM ( SELECT SUM(p.monto) AS total_pagos FROM pago p WHERE p.tipo_pago = "pagado" AND MONTH(p.fecha_pago) = 6 AND YEAR(p.fecha_pago) = YEAR(CURDATE()) UNION ALL SELECT SUM(pr.monto) AS total_pagos FROM pago_reserva pr JOIN reserva r ON pr.reservaid = r.reservaid WHERE r.estado = "confirmada" AND MONTH(pr.fecha_pago) = 6 AND YEAR(pr.fecha_pago) = YEAR(CURDATE())) AS subconsulta', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.getCountReservas = (callback) => {
    pool.query('select COUNT(*) AS cantidad from reserva WHERE estado = "pendiente" OR estado = "confirmada"', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.getCountPagosPorMes = (callback) => {
    pool.query('CALL sp_ganancias_ultimos_12_meses()', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
}

usuario.getListProximosPagos = (callback) => {
    pool.query('call sp_proximos_pagos_pendientes()', (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows[0]
            callback(null,res);
        }
    });
}


module.exports = usuario;