const { Router } = require("express");
const joi = require("joi");

const contratoModel = require("../models/contrato");

const router = Router();

router.get("/contrato", async (req,res) =>{
    try{
        await contratoModel.getContrato((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Contratos obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/contrato/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await contratoModel.getContratoById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró contrato.",
                });
            }

            return res.status(200).json({
                message: "Contrato obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/contrato", async (req,res) =>{

    const schema = joi.object({
        usuarioid: joi.string().length(5).required(),
        administradorid: joi.string().length(5).required(),
        departamentoid: joi.string().length(5).required(),
        garantiaid: joi.string().length(5).required(),
        fecha_inicio: joi.string().isoDate().required(),
        fecha_fin: joi.string().isoDate().required(),
        estado: joi.valid('por confirmar','activo','terminado').required(),
        monto: joi.number().precision(2).min(0).max(9999.99).required()
    });

    contratoData = {
        usuarioid: req.body.usuarioid,
        administradorid: req.body.administradorid,
        departamentoid: req.body.departamentoid,
        garantiaid: req.body.garantiaid,
        fecha_inicio: req.body.fecha_inicio,
        fecha_fin: req.body.fecha_fin,
        estado: req.body.estado,
        monto: req.body.monto
    }

    const { error } = schema.validate(req.body);
    if (error) {
        console.log(error);
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await contratoModel.insertContrato(contratoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar contrato.",
                });
            }

            return res.status(201).json({
                message: "Contrato registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/contrato/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        usuarioid: joi.string().length(5).required(),
        administradorid: joi.string().length(5).required(),
        departamentoid: joi.string().length(5).required(),
        garantiaid: joi.string().length(5).required(),
        fecha_inicio: joi.string().isoDate().required(),
        fecha_fin: joi.string().isoDate().required(),
        estado: joi.valid('por confirmar','activo','terminado').required(),
        monto: joi.number().precision(2).min(0).max(9999.99).required()
    });

    contratoData = {
        usuarioid: req.body.usuarioid,
        administradorid: req.body.administradorid,
        departamentoid: req.body.departamentoid,
        garantiaid: req.body.garantiaid,
        fecha_inicio: req.body.fecha_inicio,
        fecha_fin: req.body.fecha_fin,
        estado: req.body.estado,
        monto: req.body.monto
    }

    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await contratoModel.updateContrato(id,contratoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar contrato."
                });
            }

            return res.status(200).json({
                message: "Contrato actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/contrato/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        usuarioid: joi.string().length(5),
        administradorid: joi.string().length(5),
        departamentoid: joi.string().length(5),
        garantiaid: joi.string().length(5),
        fecha_inicio: joi.string().isoDate(),
        fecha_fin: joi.string().isoDate(),
        estado: joi.valid('por confirmar','activo','terminado'),
        monto: joi.number().precision(2).min(0).max(9999.99)
    });

    contratoData = {
        usuarioid: req.body.usuarioid,
        administradorid: req.body.administradorid,
        departamentoid: req.body.departamentoid,
        garantiaid: req.body.garantiaid,
        fecha_inicio: req.body.fecha_inicio,
        fecha_fin: req.body.fecha_fin,
        estado: req.body.estado,
        monto: req.body.monto
    }

    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanContratoData = {}

    Object.keys(contratoData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanContratoData[key] = contratoData[key];
        }
    });

    if(Object.keys(cleanContratoData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await contratoModel.updateContrato(id,cleanContratoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar contrato."
                });
            }

            return res.status(200).json({
                message: "Contrato actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/contrato/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await contratoModel.deleteContrato(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Contrato no encontrado"
                })
            }

            return res.status(200).json({
                message: "Contrato eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/contratopago", async (req,res) =>{
    try{
        await contratoModel.getContratoTipoPago((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Contratos obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});


module.exports = router;