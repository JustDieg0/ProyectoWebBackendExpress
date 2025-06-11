const { Router } = require("express");
const joi = require("joi");

const departamentoModel = require("../models/departamento");

const router = Router();

router.get("/departamento", async (req,res) =>{
    try{
        await departamentoModel.getDepartamento((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Departamentos obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/departamento/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await departamentoModel.getDepartamentoById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró departamento.",
                });
            }

            return res.status(200).json({
                message: "Departamento obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/departamento", async (req,res) =>{


    const schema = joi.object({
        nombre: joi.string().max(100).required(),
        descripcion: joi.string().required(),
        tipo: joi.string().valid("departamento", "minidepartamento", "cuarto").required(),
        precio_mensual: joi.number().precision(2).min(0).max(99999.99).required(),
        estado: joi.string().valid("disponible", "ocupado", "mantenimiento").required(),
        aforo: joi.number().integer().min(0).max(99).required(),
        ubicacion: joi.string().max(100).required()
    });


    departamentoData = {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        tipo: req.body.tipo,
        precio_mensual: req.body.precio_mensual,
        estado: req.body.estado,
        aforo: req.body.aforo,
        ubicacion: req.body.ubicacion
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."+ error
        })
    }

    try{
        await departamentoModel.insertDepartamento(departamentoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar departamento.",
                });
            }

            return res.status(201).json({
                message: "Departamento registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/departamento/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        nombre: joi.string().max(100).required(),
        descripcion: joi.string().required(),
        tipo: joi.string().valid("departamento", "minidepartamento", "cuarto").required(),
        precio_mensual: joi.number().precision(2).min(0).max(99999.99).required(),
        estado: joi.string().valid("disponible", "ocupado", "mantenimiento").required(),
        aforo: joi.number().integer().min(0).max(99).required(),
        ubicacion: joi.string().max(100).required(),
        activo: joi.boolean().required(),
    });

    departamentoData = {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        tipo: req.body.tipo,
        precio_mensual: req.body.precio_mensual,
        estado: req.body.estado,
        aforo: req.body.aforo,
        ubicacion: req.body.ubicacion,
        activo : req.body.activo
    }
    const { error } = schema.validate(req.body);
    if (error) {
        console.log(error);
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await departamentoModel.updateDepartamento(id,departamentoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar departamento."
                });
            }

            return res.status(200).json({
                message: "Departamento actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/departamento/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        nombre: joi.string().max(100).required(),
        descripcion: joi.string().required(),
        tipo: joi.string().valid("departamento", "minidepartamento", "cuarto").required(),
        precio_mensual: joi.number().precision(2).min(0).max(99999.99).required(),
        estado: joi.string().valid("disponible", "ocupado", "mantenimiento").required(),
        aforo: joi.number().integer().min(0).max(99).required(),
        ubicacion: joi.string().max(100).required()
    });

    departamentoData = {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        tipo: req.body.tipo,
        precio_mensual: req.body.precio_mensual,
        estado: req.body.estado,
        aforo: req.body.aforo,
        ubicacion: req.body.ubicacion
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanDepartamentoData = {}

    Object.keys(departamentoData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanDepartamentoData[key] = departamentoData[key];
        }
    });

    if(Object.keys(cleanDepartamentoData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await departamentoModel.updateDepartamento(id,cleanDepartamentoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar departamento."
                });
            }

            return res.status(200).json({
                message: "Departamento actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/departamento/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await departamentoModel.deleteDepartamento(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Departamento no encontrado"
                })
            }

            return res.status(200).json({
                message: "Departamento eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

module.exports = router;