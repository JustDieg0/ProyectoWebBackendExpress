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

pago.getIndicadoresIngresos = (anio, callback) => {
  const con = conection.conMysql();
  if (!con) return;
  const sqlTotales = `
      SELECT LPAD(MONTH(fecha_pago),2,'0')  AS mes,
             SUM(monto)                     AS total_mes
        FROM pago
       WHERE YEAR(fecha_pago) = ?
    GROUP BY mes
    ORDER BY mes;
  `;

  con.query(sqlTotales, [anio], (err, rows) => {
    if (err) throw err;

    const totales = Array.from({ length: 12 }, () => 0);
    rows.forEach(r => {
      const idx = parseInt(r.mes, 10) - 1; 
      totales[idx] = Number(r.total_mes);
    });

    // 2) Calcular indicadores
    let ingresoMax = Math.max(...totales);
    let ingresoMin = Math.min(...totales);
    let promedio   = totales.reduce((a, b) => a + b, 0) / 12;

    const mesMaxIdx = totales.indexOf(ingresoMax);        
    const mesMinIdx = totales.indexOf(ingresoMin);

    const formatearMes = i =>
      `${anio}-${(i + 1).toString().padStart(2, "0")}`;

    const resultado = {
      mes_max: formatearMes(mesMaxIdx),
      ingreso_max: ingresoMax,
      mes_min: formatearMes(mesMinIdx),
      ingreso_min: ingresoMin,
      promedio: Number(promedio.toFixed(2)),
      cantidad_meses: rows.length, 
    };

    callback(null, resultado);
    conection.cerrarConexion();
  });
};

module.exports = pago;