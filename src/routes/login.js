const { Router } = require("express");
const joi = require("joi");

const administradorModel = require("../models/administrador");
const usuarioModel = require("../models/usuario");
const { createToken } = require("../auth/auth");

const router = Router();

router.post("/login", async (req, res) => {
  const schema = joi.object({
    correo: joi.string().min(3).max(50).required(),
    contrasena: joi.string().min(3).max(50).required()
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return res.status(400).json({
      message: "Ingrese todos los datos correctamente."
    });
  }

  const { correo, contrasena } = req.body;
  const loginData = { correo, contrasena };

  try {
    // Intentar con administrador primero
    await administradorModel.loginAdministrador(loginData, async (adminError, adminData) => {
      if (adminError) {
        return res.status(500).json({ message: "Error interno del servidor." });
      }

      if (adminData && adminData.length > 0) {
        const administrador = adminData[0];
        const token = createToken(administrador.id, administrador.correo, "administrador");

        return res.status(200).json({
          message: "Administrador logueado exitosamente.",
          token,
          user: {
            administradorid: administrador.administradorid,
            correo: administrador.correo,
            nombres: administrador.nombres,
            rol: "administrador"
          }
        });
      }

      // Si no es administrador, probar como usuario
      await usuarioModel.loginUsuario(loginData, (userError, userData) => {
        if (userError) {
          return res.status(500).json({ message: "Error interno del servidor." });
        }

        if (!userData || userData.length === 0) {
          return res.status(401).json({ message: "Correo o contraseña incorrectos." });
        }

        const usuario = userData[0];
        const token = createToken(usuario.id, usuario.correo, "usuario");

        return res.status(200).json({
          message: "Usuario logueado exitosamente.",
          token,
          user: {
            usuarioid: usuario.usuarioid,
            correo: usuario.correo,
            nombres: usuario.nombres,
            rol: "usuario"
          }
        });
      });
    });
  } catch (err) {
    return res.status(500).json({
      message: "Ocurrió un error inesperado."
    });
  }
});

module.exports = router;
