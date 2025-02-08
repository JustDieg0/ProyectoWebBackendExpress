const conection = require('../db/mysql');

var usuario = {}

usuario.getUsuario = (callback) => {
    con = conection.conMysql();
    if(con){
        con.query('select usuarioid,nombres,apellidos,telefono,nacionalidad,doc_ident from usuario', (error,rows) => {
            if(error){
                throw error;
            }else{
                res = {
                    data:rows
                }
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
                res = {
                    data:rows
                }
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
		con.query('INSERT INTO usuario SET ?', usuarioData, (error, result) => {
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
    const _id = con.escape(id);
    const _nombres = con.escape(datosUsuario.nombres);
    const _apellidos = con.escape(datosUsuario.apellidos);
    const _telefono = con.escape(datosUsuario.telefono);
    const _nacionalidad = con.escape(datosUsuario.nacionalidad);
    const _doc_ident = con.escape(datosUsuario.doc_ident);

    con = conection.conMysql();
    if(con){
        var sql = `UPDATE usuario SET nombres=${_nombres}, apellidos=${_apellidos}, telefono=${_telefono}, nacionalidad=${_nacionalidad}, doc_ident=${_doc_ident}  WHERE usuarioid=${_id}`;
        con.query(sql, (error,rows) => {
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
                callback(null, true);
            }
            conection.cerrarConexion();
        });
    }
}

module.exports = usuario;