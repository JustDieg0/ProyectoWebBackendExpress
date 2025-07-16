const { pool } = require('../db/mysql')

var reserva = {}

reserva.insertReserva = (reservaData,callback) => {
    pool.query('call sp_addReserva(?,?,?,?,?)', [reservaData.usuarioid,reservaData.departamentoid,reservaData.fecha_inicio,reservaData.fecha_fin,reservaData.estado], (error, result) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

reserva.insertReservaPago = (reservaData,callback) => {
    pool.query('call sp_insertar_reserva_con_pago(?,?,?,?,?,?)', [reservaData.usuarioid,reservaData.departamentoid,reservaData.fecha_inicio,reservaData.fecha_fin,reservaData.estado,reservaData.precio], (error, result) => {
        if(error){
            throw error;
        }else{
            callback(null, true);
        }
    });
}

reserva.getReservaPagos = (callback) => {
    pool.query(`SELECT 
            pr.pagoreservaid,
            r.reservaid,
            u.nombres AS nombre_usuario,
            u.apellidos AS apellido_usuario,
            r.departamentoid,
            pr.fecha_pago,
            pr.monto,
            pr.metodo_pago
            FROM pago_reserva pr
            JOIN reserva r ON pr.reservaid = r.reservaid
            JOIN usuario u ON r.usuarioid = u.usuarioid;
        `, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
} 

reserva.getReservaPagosPorFecha = (year, month, callback) => {
        pool.query(`SELECT 
            pr.pagoreservaid,
            r.reservaid,
            u.nombres AS nombre_usuario,
            u.apellidos AS apellido_usuario,
            r.departamentoid,
            pr.fecha_pago,
            pr.monto,
            pr.metodo_pago
            FROM pago_reserva pr
            JOIN reserva r ON pr.reservaid = r.reservaid
            JOIN usuario u ON r.usuarioid = u.usuarioid
            WHERE MONTH(pr.fecha_pago) = ${month}
            AND YEAR(pr.fecha_pago) = ${year};
        `, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
} 

reserva.getReservaPagosStatsPorFecha = (year, month, callback) => {
        pool.query(`SELECT 
            MAX(pr.monto) AS max_monto,
            MIN(pr.monto) AS min_monto,
            AVG(pr.monto) AS promedio_monto
        FROM pago_reserva pr
        WHERE MONTH(pr.fecha_pago) = ${month}
        AND YEAR(pr.fecha_pago) = ${year};
        `, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
} 

reserva.getReservaPagosStats = (callback) => {
        pool.query(`SELECT 
            MAX(pr.monto) AS max_monto,
            MIN(pr.monto) AS min_monto,
            AVG(pr.monto) AS promedio_monto
        FROM pago_reserva pr
        `, (error,rows) => {
        if(error){
            throw error;
        }else{
            res = rows
            callback(null,res);
        }
    });
} 

module.exports = reserva;