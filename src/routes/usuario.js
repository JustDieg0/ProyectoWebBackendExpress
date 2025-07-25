const { Router } = require("express");
const joi = require("joi");

const usuarioModel = require("../models/usuario");
const {  autenticarToken, soloAdmin, mismoUsuarioOAdmin } = require("../auth/auth");

const router = Router();

router.get("/usuario", autenticarToken, soloAdmin, async (req,res) =>{
    try{
        await usuarioModel.getUsuario((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
                data: data,
            });
        });
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/usuario/:id", autenticarToken, mismoUsuarioOAdmin, async (req,res) =>{
    const { id } = req.params;
    try{
        await usuarioModel.getUsuarioById(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontró usuario.",
                });
            }

            return res.status(200).json({
                message: "Usuario obtenido exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }

});

router.post("/usuario", async (req,res) =>{


    const schema = joi.object({
        nombres: joi.string().min(3).max(50).required(),
        apellidos: joi.string().min(3).max(50).required(),
        telefono: joi.string().pattern(/^\d{9}$/).required(),
        nacionalidad: joi.string().min(3).max(50).required(),
        doc_ident: joi.string().min(3).max(50).required(),
        correo: joi.string().min(3).max(50).required(),
        contrasena: joi.string().min(3).max(50).required(),
    });

    usuarioData = {
        nombres: req.body.nombres,
        apellidos: req.body.apellidos,
        telefono: req.body.telefono,
        nacionalidad: req.body.nacionalidad,
        doc_ident: req.body.doc_ident,
        correo: req.body.correo,
        contrasena: req.body.contrasena
    }

    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await usuarioModel.insertUsuario(usuarioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(500).json({
                    message: "No pudo registrar usuario.",
                });
            }

            return res.status(201).json({
                message: "Usuario registrado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/usuario/:id", autenticarToken, mismoUsuarioOAdmin, async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        nombres: joi.string().min(3).max(50).required(),
        apellidos: joi.string().min(3).max(50).required(),
        telefono: joi.string().pattern(/^\d{9}$/).required(),
        nacionalidad: joi.string().min(3).max(50).required(),
        doc_ident: joi.string().min(3).max(50).required(),
        correo: joi.string().min(3).max(50).required(),
        contrasena: joi.string().min(3).max(50).required(),
        activo: joi.boolean().required()
    });

    usuarioData = {
        nombres: req.body.nombres,
        apellidos: req.body.apellidos,
        telefono: req.body.telefono,
        nacionalidad: req.body.nacionalidad,
        doc_ident: req.body.doc_ident,
        correo: req.body.correo,
        contrasena: req.body.contrasena,
        activo: req.body.activo
    }

    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    try{
        await usuarioModel.updateUsuario(id,usuarioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar usuario."
                });
            }

            return res.status(200).json({
                message: "Usuario actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.patch("/usuario/:id", autenticarToken, mismoUsuarioOAdmin, async (req,res) =>{
    const { id } = req.params;

    const schema = joi.object({
        nombres: joi.string().min(3).max(50),
        apellidos: joi.string().min(3).max(50),
        telefono: joi.string().pattern(/^\d{9}$/),
        nacionalidad: joi.string().min(3).max(50),
        doc_ident: joi.string().min(3).max(50),
        correo: joi.string().min(3).max(50),
        contrasena: joi.string().min(3).max(50),
        activo: joi.boolean()
    });

    usuarioData = {
        nombres: req.body.nombres,
        apellidos: req.body.apellidos,
        telefono: req.body.telefono,
        nacionalidad: req.body.nacionalidad,
        doc_ident: req.body.doc_ident,
        correo: req.body.correo,
        contrasena: req.body.contrasena,
        activo: req.body.activo
    }

    const { error } = schema.validate(req.body);
    if (error) {
        return res.status(400).json({ 
            message: "Ingrese todos los datos correctamente."
        })
    }

    let cleanUsuarioData = {}

    Object.keys(usuarioData).forEach((key) => {
        if (req.body[key] !== undefined && req.body[key] !== null && req.body[key] !== "") {
            cleanUsuarioData[key] = usuarioData[key];
        }
    });

    if(Object.keys(cleanUsuarioData).length === 0){
        return res.status(400).json({ 
            message: "No hay campos para actualizar"
        })
    }
    
    try{
        await usuarioModel.updateUsuario(id,cleanUsuarioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo actualizar usuario."
                });
            }

            return res.status(200).json({
                message: "Usuario actualizado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/usuario/:id", autenticarToken, soloAdmin, async (req,res) =>{
    const { id } = req.params;
    try{
        await usuarioModel.deleteUsuario(id,(error,affectedRows)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            
            if(affectedRows === 0) {
                return res.status(404).json({
                    message: "Usuario no encontrado"
                })
            }

            return res.status(200).json({
                message: "Usuario eliminado exitosamente."
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});


router.get("/cantidad/usuario", async (req,res) =>{
    try{
        await usuarioModel.getCountUsuario((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/cantidad/contrato", async (req,res) =>{
    try{
        await usuarioModel.getCountContrato((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/cantidad/pagos", async (req,res) =>{
    try{
        await usuarioModel.getCountPagos((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/cantidad/reservas", async (req,res) =>{
    try{
        await usuarioModel.getCountReservas((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/dashboard/pagos", async (req,res) =>{
    try{
        await usuarioModel.getCountPagosPorMes((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.get("/dashboard/pagos/proximos/5", async (req,res) =>{
    try{
        await usuarioModel.getListProximosPagos((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }
            return res.status(200).json({
                message: "Usuarios obtenidos exitosamente.",
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