const { Router } = require("express");
const joi = require("joi");

const pagoModel = require("../models/pago");

const router = Router();

router.get("/pago", async (req,res) =>{
    try{
        await pagoModel.getPago((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Pagos obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/pago/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await pagoModel.getPagoById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró pago.",
                });
            }

            return res.status(200).json({
                message: "Pago obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/pago", async (req,res) =>{


    const schema = joi.object({
        contratoid: joi.string().length(4).required(),
        fecha_pago: joi.string().isoDate().required(),
        monto: joi.number().precision(2).min(0).max(99999.99).required(),
        tipo_pago: joi.string().min(3).max(50).required(),
        metodo_pago: joi.string().min(3).max(50).required()
    })

    pagoData = {
        contratoid: req.body.contratoid,
        fecha_pago: req.body.fecha_pago,
        monto: req.body.monto,
        tipo_pago: req.body.tipo_pago,
        metodo_pago: req.body.metodo_pago
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await pagoModel.insertPago(pagoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar pago.",
                });
            }

            return res.status(201).json({
                message: "Pago registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/pago/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        contratoid: joi.string().length(4).required(),
        fecha_pago: joi.string().isoDate().required(),
        monto: joi.number().precision(2).min(0).max(99999.99).required(),
        tipo_pago: joi.string().min(3).max(50).required(),
        metodo_pago: joi.string().min(3).max(50).required()
    })

    pagoData = {
        contratoid: req.body.contratoid,
        fecha_pago: req.body.fecha_pago,
        monto: req.body.monto,
        tipo_pago: req.body.tipo_pago,
        metodo_pago: req.body.metodo_pago
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await pagoModel.updatePago(id,pagoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar pago."
                });
            }

            return res.status(200).json({
                message: "Pago actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/pago/:id", async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        contratoid: joi.string().length(4),
        fecha_pago: joi.string().isoDate(),
        monto: joi.number().precision(2).min(0).max(99999.99),
        tipo_pago: joi.string().min(3).max(50),
        metodo_pago: joi.string().min(3).max(50)
    })

    pagoData = {
        contratoid: req.body.contratoid,
        fecha_pago: req.body.fecha_pago,
        monto: req.body.monto,
        tipo_pago: req.body.tipo_pago,
        metodo_pago: req.body.metodo_pago
    }
    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanPagoData = {}

    Object.keys(pagoData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanPagoData[key] = pagoData[key];
        }
    });

    if(Object.keys(cleanPagoData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await pagoModel.updatePago(id,cleanPagoData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar pago."
                });
            }

            return res.status(200).json({
                message: "Pago actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/pago/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await pagoModel.deletePago(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Pago no encontrado"
                })
            }

            return res.status(200).json({
                message: "Pago eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

module.exports = router;