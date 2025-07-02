const jwt = require("jsonwebtoken");

function createToken(id,correo,rol){
    const token = jwt.sign(
        { id: id, correo: correo, rol: rol }, // payload
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || "1h" } // duración
    );
    return token;
}

function autenticarToken(req, res, next) {
    let token = req.cookies?.token;
    // Si no hay token en cookies, lo intentamos desde el header Authorization
    if (!token && req.headers['authorization']) {
        const authHeader = req.headers['authorization']; // e.g. 'Bearer eyJhbGciOi...'
        if (authHeader.startsWith('Bearer ')) {
            token = authHeader.split(' ')[1];
        }
    }

    if (!token) return res.status(401).json({ mensaje: 'Token no proporcionado' });

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.usuario = decoded;
        next();
    } catch (err) {
        return res.status(403).json({ mensaje: 'Token inválido' });
    }
}

function soloAdmin(req, res, next) {
    if (req.usuario.rol !== 'administrador') {
        return res.status(403).json({ mensaje: 'Acceso denegado' });
    }
    next();
}

function mismoUsuarioOAdmin(req, res, next) {
    const id = req.params.id; // ID del usuario que intenta consultar/modificar
    if (req.usuario.rol === 'administrador' || req.usuario.id === id) {
        return next();
    }
    return res.status(403).json({ mensaje: 'No autorizado' });
}
module.exports = {
    createToken,
    autenticarToken,
    soloAdmin,
    mismoUsuarioOAdmin
}