const { Router } = require("express");

const usuarioModel = require("../models/usuario");

const router = Router();

router.get("/usuario", async (req,res) =>{
    try{
        await usuarioModel.getUsuario((error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data || data.length === 0) {
                return res.status(404).json({
                    message: "No se encontraron usuarios.",
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

router.get("/usuario/:id", async (req,res) =>{
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
    usuarioData = {
        nombres: req.body.nombres,
        apellidos: req.body.apellidos,
        telefono: req.body.telefono,
        nacionalidad: req.body.nacionalidad,
        doc_ident: req.body.doc_ident
    }

    try{
        await usuarioModel.insertUsuario(usuarioData,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo registrar usuario.",
                });
            }

            return res.status(200).json({
                message: "Usuario registrado exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.put("/usuario/:id", async (req,res) =>{
    const { id } = req.params;

    usuarioData = {
        nombres: req.body.nombres,
        apellidos: req.body.apellidos,
        telefono: req.body.telefono,
        nacionalidad: req.body.nacionalidad,
        doc_ident: req.body.doc_ident
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
                    message: "No pudo actualizar usuario.",
                });
            }

            return res.status(200).json({
                message: "Usuario actualizado exitosamente.",
                data: data,
            });
        })
    } catch (err){
        return res.status(500).json({
            message: "Ocurrió un error inesperado."
        });
    }
});

router.delete("/usuario/:id", async (req,res) =>{
    const { id } = req.params;
    try{
        await usuarioModel.deleteUsuario(id,(error,data)=>{
            if (error) {
                return res.status(500).json({
                    message: "Error interno del servidor"
                });
            }

            if (!data) {
                return res.status(404).json({
                    message: "No pudo eliminar usuario.",
                });
            }

            return res.status(200).json({
                message: "Usuario eliminado exitosamente.",
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