const conection = require('../db/mysql');

var usuario = {}

usuario.getUsuario = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select usuarioid,nombres,apellidos,telefono,nacionalidad,doc_ident,correo,contrasena from usuario', (error,rows) => {
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

usuario.getUsuarioById = (id,callback) => {
    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `SELECT usuarioid,nombres,apellidos,telefono,nacionalidad,doc_ident FROM usuario WHERE usuarioid = ${_id}`;
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

usuario.insertUsuario = (usuarioData,callback) => {
    con = conection.conMysql();
	if (con) 
	{
		con.query('call sp_addUsuario(?,?,?,?,?)', [usuarioData.nombres,usuarioData.apellidos,usuarioData.telefono,usuarioData.nacionalidad,usuarioData.doc_ident], (error, result) => {
			if(error){
				throw error;
			}else{
				callback(null, true);
			}
            conection.cerrarConexion();
		});
	}
}

usuario.updateUsuario = (id,datosUsuario,callback) => {
    
    con = conection.conMysql();
    if(con){
        var sql = `UPDATE usuario SET ?  WHERE usuarioid=?`;
        con.query(sql,[datosUsuario,id], (error,rows) => {
            if(error){
                throw error;
            }else{
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

usuario.deleteUsuario = (id,callback) => {

    con = conection.conMysql();
    if(con){
        const _id = con.escape(id);
        var sql = `DELETE FROM usuario WHERE usuarioid = ${_id}`;
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

usuario.getCountUsuario = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select COUNT(*) AS cantidad from usuario WHERE activo = 1', (error,rows) => {
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

usuario.getCountContrato = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select COUNT(*) AS cantidad from contrato WHERE estado = "activo"', (error,rows) => {
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

usuario.getCountPagos = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select COUNT(*) AS cantidad from pago WHERE tipo_pago = "pagado"', (error,rows) => {
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

usuario.getCountPagosPorMes = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('SELECT SUM(total_pagos) AS suma_total_junio FROM ( SELECT SUM(p.monto) AS total_pagos FROM pago p WHERE p.tipo_pago = "pagado" AND MONTH(p.fecha_pago) = 6 AND YEAR(p.fecha_pago) = YEAR(CURDATE()) UNION ALL SELECT SUM(pr.monto) AS total_pagos FROM pago_reserva pr JOIN reserva r ON pr.reservaid = r.reservaid WHERE r.estado = "confirmada" AND MONTH(pr.fecha_pago) = 6 AND YEAR(pr.fecha_pago) = YEAR(CURDATE())) AS subconsulta;', (error,rows) => {
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

usuario.getListProximosPagos = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('call sp_proximos_pagos_pendientes()', (error,rows) => {
            if(error){
                throw error;
            }else{
                res = rows[0]
                callback(null,res);
            }
            conection.cerrarConexion();
        });
    }
}


module.exports = usuario;