const { Router } = require("express");
const joi = require("joi");

const garantiaModel = require("../models/garantia");

const router = Router();

router.get("/garantia", async (req,res) =>{
    try{
        await garantiaModel.getGarantia((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Garantias obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/garantia/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await garantiaModel.getGarantiaById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró garantia.",
                });
            }

            return res.status(200).json({
                message: "Garantia obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/garantia", async (req,res) =>{


    const schema = joi.object({
        monto: joi.number().precision(2).min(0).min(99999.99).required(),
        estado: joi.string().valid("pagado","rembolsado","en espera").required()
    })

    garantiaData = {
        monto: req.body.monto,
        estado: req.body.estado
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await garantiaModel.insertGarantia(garantiaData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar garantia.",
                });
            }

            return res.status(201).json({
                message: "Garantia registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/garantia/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        monto: joi.number().precision(2).min(0).min(99999.99).required(),
        estado: joi.string().valid("pagado","rembolsado","en espera").required()
    })

    garantiaData = {
        monto: req.body.monto,
        estado: req.body.estado
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await garantiaModel.updateGarantia(id,garantiaData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar garantia."
                });
            }

            return res.status(200).json({
                message: "Garantia actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/garantia/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        monto: joi.number().precision(2).min(0).min(99999.99).required(),
        estado: joi.string().valid("pagado","rembolsado","en espera").required()
    })

    garantiaData = {
        monto: req.body.monto,
        estado: req.body.estado
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanGarantiaData = {}

    Object.keys(garantiaData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanGarantiaData[key] = garantiaData[key];
        }
    });

    if(Object.keys(cleanGarantiaData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await garantiaModel.updateGarantia(id,cleanGarantiaData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar garantia."
                });
            }

            return res.status(200).json({
                message: "Garantia actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/garantia/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await garantiaModel.deleteGarantia(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Garantia no encontrado"
                })
            }

            return res.status(200).json({
                message: "Garantia eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

module.exports = router;