const { Router } = require("express");
const joi = require("joi");

const contrato_servicioModel = require("../models/contrato_servicio");

const router = Router();

router.get("/contrato_servicio", async (req,res) =>{
    try{
        await contrato_servicioModel.getContrato_servicio((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Contrato_servicios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/contrato_servicio/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await contrato_servicioModel.getContrato_servicioById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró contrato_servicio.",
                });
            }

            return res.status(200).json({
                message: "Contrato_servicio obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/contrato_servicio", async (req,res) =>{


    const schema = joi.object({
        servicioid: joi.string().length(4).required(),
        cantidad: joi.number().min(0).max(99).required()
    })

    contrato_servicioData = {
        servicioid: req.body.servicioid,
        cantidad: req.body.cantidad
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await contrato_servicioModel.insertContrato_servicio(contrato_servicioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar contrato_servicio.",
                });
            }

            return res.status(201).json({
                message: "Contrato_servicio registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/contrato_servicio/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        servicioid: joi.string().length(4).required(),
        cantidad: joi.number().min(0).max(99).required()
    })

    contrato_servicioData = {
        servicioid: req.body.servicioid,
        cantidad: req.body.cantidad
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await contrato_servicioModel.updateContrato_servicio(id,contrato_servicioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar contrato_servicio."
                });
            }

            return res.status(200).json({
                message: "Contrato_servicio actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/contrato_servicio/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        servicioid: joi.string().length(4),
        cantidad: joi.number().min(0).max(99)
    })

    contrato_servicioData = {
        servicioid: req.body.servicioid,
        cantidad: req.body.cantidad
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanContrato_servicioData = {}

    Object.keys(contrato_servicioData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanContrato_servicioData[key] = contrato_servicioData[key];
        }
    });

    if(Object.keys(cleanContrato_servicioData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await contrato_servicioModel.updateContrato_servicio(id,cleanContrato_servicioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar contrato_servicio."
                });
            }

            return res.status(200).json({
                message: "Contrato_servicio actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/contrato_servicio/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await contrato_servicioModel.deleteContrato_servicio(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Contrato_servicio no encontrado"
                })
            }

            return res.status(200).json({
                message: "Contrato_servicio eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

module.exports = router;