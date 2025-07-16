const { Router } = require("express");
const joi = require("joi");

const { autenticarToken, mismoUsuarioOAdmin } = require("../auth/auth");
const reservaModel = require("../models/reserva");

const router = Router()

router.post("/reserva",autenticarToken ,mismoUsuarioOAdmin, async (req,res) =>{


    const schema = joi.object({
        usuarioid: joi.string().max(5).required(),
        departamentoid: joi.string().max(5).required(),
        fecha_inicio: joi.date().required(),
        fecha_fin: joi.date().required(),
        estado: joi.string().valid("pendiente", "confirmada", "cancelada", "vencida").required(),
    });


    reservaData = {
        usuarioid: req.body.usuarioid,
        departamentoid: req.body.departamentoid,
        fecha_inicio: req.body.fecha_inicio,
        fecha_fin: req.body.fecha_fin,
        estado: req.body.estado,
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."+ error
        })
    }

    try{
        await reservaModel.insertReserva(reservaData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar reserva.",
                });
            }

            return res.status(201).json({
                message: "Reserva registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.post("/reserva/pago",autenticarToken ,mismoUsuarioOAdmin, async (req,res) =>{


    const schema = joi.object({
        usuarioid: joi.string().max(5).required(),
        departamentoid: joi.string().max(5).required(),
        fecha_inicio: joi.date().required(),
        fecha_fin: joi.date().required(),
        estado: joi.string().valid("pendiente", "confirmada", "cancelada", "vencida").required(),
        precio: joi.number().precision(2).min(0).max(99999.99).required(),
    });


    reservaData = {
        usuarioid: req.body.usuarioid,
        departamentoid: req.body.departamentoid,
        fecha_inicio: req.body.fecha_inicio,
        fecha_fin: req.body.fecha_fin,
        estado: req.body.estado,
        precio: req.body.precio,
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."+ error
        })
    }

    try{
        await reservaModel.insertReservaPago(reservaData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar reserva.",
                });
            }

            return res.status(201).json({
                message: "Reserva registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/reserva/periodo", async (req, res) => {
    try {
        await reservaModel.getReservaPagos((error, data) => {
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Reservas obtenidos exitosamente.",
                data: data,
            });
        });
    } catch (err) {
        console.log(err)
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/reserva/periodo/:year/:month", async (req, res) => {
    const year = parseInt(req.params.year);
    const month = parseInt(req.params.month);
    if (isNaN(year) || isNaN(month)) {
        return res.status(400).json({
            message: "Año y mes deben ser números válidos."
        });
    }
    try {
        if(year == 0 || month == 0){
            await reservaModel.getReservaPagos((error, data) => {
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Reservas obtenidos exitosamente.",
                data: data,
            });
        });
        }else{
            await reservaModel.getReservaPagosPorFecha(year, month, (error, data) => {
                if (error) {
                    return res.status(500).json({
                        message: "Error interno del servidor"
                    });
                }
                return res.status(200).json({
                    message: "Reservas obtenidos exitosamente.",
                    data: data,
                });
            });
        }
    } catch (err) {
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/reserva/periodo/stats/:year/:month", async (req, res) => {
    const year = parseInt(req.params.year);
    const month = parseInt(req.params.month);
    if (isNaN(year) || isNaN(month)) {
        return res.status(400).json({
            message: "Año y mes deben ser números válidos."
        });
    }
    try {
        if(year == 0 || month == 0){
            await reservaModel.getReservaPagosStats((error, data) => {
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Reservas obtenidos exitosamente.",
                data: data,
            });
        });
        }else{
            await reservaModel.getReservaPagosStatsPorFecha(year, month, (error, data) => {
                if (error) {
                    return res.status(500).json({
                        message: "Error interno del servidor"
                    });
                }
                return res.status(200).json({
                    message: "Reservas obtenidos exitosamente.",
                    data: data,
                });
            });
        }
    } catch (err) {
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});


module.exports = router;