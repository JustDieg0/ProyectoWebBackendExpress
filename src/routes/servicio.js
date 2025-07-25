const { Router } = require("express");
const joi = require("joi");

const servicioModel = require("../models/servicio");

const router = Router();

router.get("/servicio", async (req,res) =>{
    try{
        await servicioModel.getServicio((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Servicios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/servicio/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await servicioModel.getServicioById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró servicio.",
                });
            }

            return res.status(200).json({
                message: "Servicio obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/servicio", async (req,res) =>{


    const schema = joi.object({
        nombre: joi.string().max(50).required(),
        descripcion: joi.string().max(255).required(),
        precio: joi.number().precision(2).min(0).max(99999.99).required()
    })

    servicioData = {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        precio: req.body.precio
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await servicioModel.insertServicio(servicioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar servicio.",
                });
            }

            return res.status(201).json({
                message: "Servicio registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/servicio/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        nombre: joi.string().max(50).required(),
        descripcion: joi.string().max(255).required(),
        precio: joi.number().precision(2).min(0).max(99999.99).required()
    })

    servicioData = {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        precio: req.body.precio
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await servicioModel.updateServicio(id,servicioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar servicio."
                });
            }

            return res.status(200).json({
                message: "Servicio actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/servicio/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        nombre: joi.string().max(50).required(),
        descripcion: joi.string().max(255).required(),
        precio: joi.number().precision(2).min(0).max(99999.99).required()
    })

    servicioData = {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        precio: req.body.precio
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanServicioData = {}

    Object.keys(servicioData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanServicioData[key] = servicioData[key];
        }
    });

    if(Object.keys(cleanServicioData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await servicioModel.updateServicio(id,cleanServicioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar servicio."
                });
            }

            return res.status(200).json({
                message: "Servicio actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/servicio/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await servicioModel.deleteServicio(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Servicio no encontrado"
                })
            }

            return res.status(200).json({
                message: "Servicio eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

module.exports = router;