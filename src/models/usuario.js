const conection = require('../db/mysql');

var usuario = {}

usuario.getUsuario = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select usuarioid,nombres,apellidos,telefono,nacionalidad,doc_ident from usuario', (error,rows) => {
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

module.exports = usuario;