DROP DATABASE IF EXISTS bd_ges_tom;
CREATE DATABASE bd_ges_tom;
USE bd_ges_tom;

DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE `sp_addAdministrador` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_telefono` VARCHAR(9), IN `p_rol` VARCHAR(50), IN `p_correo` VARCHAR(50), IN `p_contrasena` VARCHAR(50))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último usuarioid
  SELECT administradorid
  INTO ultimo_id
  FROM administrador
  WHERE administradorid LIKE 'A%'
  ORDER BY administradorid DESC
  LIMIT 1;

  -- Generar número correlativo
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Crear nuevo usuarioid
  SET nuevo_id = CONCAT('A', LPAD(num, 4, '0'));

  -- Insertar nuevo administrador
  INSERT INTO administrador (
    administradorid, nombres, apellidos, telefono, rol, correo, contrasena
  ) VALUES (
    nuevo_id, p_nombres, p_apellidos, p_telefono, p_rol, p_correo, p_contrasena
  );
  END$$

DELIMITER $$

CREATE PROCEDURE `sp_addReserva` (
  IN `p_usuarioid` VARCHAR(5),
  IN `p_departamentoid` VARCHAR(5),
  IN `p_fecha_inicio` DATE,
  IN `p_fecha_fin` DATE,
  IN `p_estado` VARCHAR(20)
)
BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  SELECT reservaid INTO ultimo_id
  FROM reserva
  WHERE reservaid LIKE 'R%'
  ORDER BY reservaid DESC
  LIMIT 1;

  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  SET nuevo_id = CONCAT('R', LPAD(num, 4, '0'));

  INSERT INTO reserva (
    reservaid, usuarioid, departamentoid, fecha_inicio, fecha_fin, estado
  ) VALUES (
    nuevo_id, p_usuarioid, p_departamentoid, p_fecha_inicio, p_fecha_fin, p_estado
  );
END$$

CREATE PROCEDURE `sp_addPagoReserva` (
  IN `p_reservaid` VARCHAR(5),
  IN `p_monto` DECIMAL(6,2),
  IN `p_metodo_pago` VARCHAR(30)
)
BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  SELECT pagoreservaid INTO ultimo_id
  FROM pago_reserva
  WHERE pagoreservaid LIKE 'PR%'
  ORDER BY pagoreservaid DESC
  LIMIT 1;

  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 3) AS UNSIGNED) + 1;
  END IF;

  SET nuevo_id = CONCAT('PR', LPAD(num, 3, '0'));

  INSERT INTO pago_reserva (
    pagoreservaid, reservaid, monto, metodo_pago
  ) VALUES (
    nuevo_id, p_reservaid, p_monto, p_metodo_pago
  );
END$$


CREATE PROCEDURE `sp_addContrato` (IN `p_administradorid` VARCHAR(5), IN `p_usuarioid` VARCHAR(5), IN `p_departamentoid` VARCHAR(5), IN `p_garantiaid` VARCHAR(5), IN `p_fecha_inicio` DATE, IN `p_fecha_fin` DATE, IN `p_estado` VARCHAR(20), IN `p_monto` DECIMAL(6,2))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último contratoid
  SELECT contratoid
  INTO ultimo_id
  FROM contrato
  WHERE contratoid LIKE 'C%'
  ORDER BY contratoid DESC
  LIMIT 1;

  -- Generar número correlativo
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Crear nuevo contratoid
  SET nuevo_id = CONCAT('C', LPAD(num, 4, '0'));

  -- Insertar nuevo contrato
  INSERT INTO contrato (
    contratoid, administradorid, usuarioid, departamentoid, garantiaid,
    fecha_inicio, fecha_fin, estado, monto
  ) VALUES (
    nuevo_id, p_administradorid, p_usuarioid, p_departamentoid, p_garantiaid,
    p_fecha_inicio, p_fecha_fin, p_estado, p_monto
  );
END$$

CREATE PROCEDURE `sp_addDepartamento` (IN `p_nombre` VARCHAR(100), IN `p_descripcion` TEXT, IN `p_tipo` VARCHAR(50), IN `p_precio_mensual` DECIMAL(6,2), IN `p_estado` VARCHAR(20), IN `p_aforo` INT, IN `p_ubicacion` VARCHAR(100))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último ID insertado
  SELECT departamentoid
  INTO ultimo_id
  FROM departamento
  WHERE departamentoid LIKE 'D%'
  ORDER BY departamentoid DESC
  LIMIT 1;

  -- Si no hay registros, iniciar en 1
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Generar el nuevo ID con formato D0001
  SET nuevo_id = CONCAT('D', LPAD(num, 4, '0'));

  -- Insertar el nuevo registro
  INSERT INTO departamento (departamentoid, nombre, descripcion, tipo, precio_mensual, estado, aforo, ubicacion)
  VALUES (nuevo_id, p_nombre, p_descripcion, p_tipo, p_precio_mensual, p_estado, p_aforo, p_ubicacion);
END$$

CREATE PROCEDURE `sp_addGarantia` (IN `p_monto` DECIMAL(6,2), IN `p_estado` VARCHAR(20))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último garantiaid
  SELECT garantiaid
  INTO ultimo_id
  FROM garantia
  WHERE garantiaid LIKE 'G%'
  ORDER BY garantiaid DESC
  LIMIT 1;

  -- Generar número correlativo
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Crear nuevo garantiaid
  SET nuevo_id = CONCAT('G', LPAD(num, 4, '0'));

  -- Insertar nuevo registro
  INSERT INTO garantia (garantiaid, monto, estado)
  VALUES (nuevo_id, p_monto, p_estado);
END$$

CREATE PROCEDURE `sp_addPago` (IN `p_contratoid` VARCHAR(5), IN `p_fecha_pago` DATE, IN `p_monto` DECIMAL(6,2), IN `p_tipo_pago` VARCHAR(30), IN `p_metodo_pago` VARCHAR(30))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último pagoid
  SELECT pagoid
  INTO ultimo_id
  FROM pago
  WHERE pagoid LIKE 'P%'
  ORDER BY pagoid DESC
  LIMIT 1;

  -- Generar número correlativo
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Crear nuevo pagoid
  SET nuevo_id = CONCAT('P', LPAD(num, 4, '0'));

  -- Insertar nuevo pago
  INSERT INTO pago (
    pagoid, contratoid, fecha_pago, monto, tipo_pago, metodo_pago
  ) VALUES (
    nuevo_id, p_contratoid, p_fecha_pago, p_monto, p_tipo_pago, p_metodo_pago
  );
END$$

CREATE PROCEDURE `sp_addServicio` (IN `p_nombre` VARCHAR(50), IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(6,2))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último servicioid
  SELECT servicioid
  INTO ultimo_id
  FROM servicio
  WHERE servicioid LIKE 'S%'
  ORDER BY servicioid DESC
  LIMIT 1;

  -- Generar número correlativo
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Crear nuevo servicioid
  SET nuevo_id = CONCAT('S', LPAD(num, 4, '0'));

  -- Insertar nuevo servicio
  INSERT INTO servicio (
    servicioid, nombre, descripcion, precio
  ) VALUES (
    nuevo_id, p_nombre, p_descripcion, p_precio
  );
END$$

CREATE PROCEDURE `sp_addUsuario` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_telefono` VARCHAR(9), IN `p_nacionalidad` VARCHAR(50), IN `p_doc_ident` VARCHAR(50), IN `p_correo` VARCHAR(50), IN `p_contrasena` VARCHAR(50))   BEGIN
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Obtener el último usuarioid
  SELECT usuarioid
  INTO ultimo_id
  FROM usuario
  WHERE usuarioid LIKE 'U%'
  ORDER BY usuarioid DESC
  LIMIT 1;

  -- Generar número correlativo
  IF ultimo_id IS NULL THEN
    SET num = 1;
  ELSE
    SET num = CAST(SUBSTRING(ultimo_id, 2) AS UNSIGNED) + 1;
  END IF;

  -- Crear nuevo usuarioid
  SET nuevo_id = CONCAT('U', LPAD(num, 4, '0'));

  -- Insertar nuevo usuario
  INSERT INTO usuario (
    usuarioid, nombres, apellidos, telefono, nacionalidad, doc_ident, correo, contrasena
  ) VALUES (
    nuevo_id, p_nombres, p_apellidos, p_telefono, p_nacionalidad, p_doc_ident, p_correo, p_contrasena
  );
END$$

DELIMITER $$

CREATE PROCEDURE sp_proximos_pagos_pendientes()
BEGIN
  SELECT *
  FROM (
    -- Pagos mensuales pendientes
    SELECT 
      p.monto,
      u.nombres AS usuario,
      'mensual' AS tipo_pago,
      p.fecha_pago,
      CASE
        WHEN p.fecha_pago < CURDATE() THEN 'vencido'
        ELSE 'por pagar'
      END AS estado
    FROM pago p
    JOIN contrato c ON p.contratoid = c.contratoid
    JOIN usuario u ON c.usuarioid = u.usuarioid
    WHERE p.tipo_pago = 'pendiente'

    UNION ALL

    -- Pagos de reserva pendientes
    SELECT 
      pr.monto,
      u.nombres AS usuario,
      'reserva' AS tipo_pago,
      pr.fecha_pago,
      CASE
        WHEN pr.fecha_pago < CURDATE() THEN 'vencido'
        ELSE 'por pagar'
      END AS estado
    FROM pago_reserva pr
    JOIN reserva r ON pr.reservaid = r.reservaid
    JOIN usuario u ON r.usuarioid = u.usuarioid
    WHERE r.estado = 'pendiente'
  ) AS pagos_pendientes
  ORDER BY fecha_pago
  LIMIT 5;
END $$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador`
--

CREATE TABLE `administrador` (
  `administradorid` varchar(5) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `telefono` varchar(9) NOT NULL,
  `rol` varchar(50) NOT NULL,
  `correo` varchar(50) NOT NULL,
  `contrasena` varchar(50) NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contrato`
--

CREATE TABLE `contrato` (
  `contratoid` varchar(5) NOT NULL,
  `administradorid` varchar(5) NOT NULL,
  `usuarioid` varchar(5) NOT NULL,
  `departamentoid` varchar(5) NOT NULL,
  `garantiaid` varchar(5) NOT NULL,
  `fecha_inicio` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_fin` timestamp NULL DEFAULT NULL,
  `estado` enum('por confirmar','activo','terminado') NOT NULL,
  `monto` decimal(6,2) NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contrato_servicio`
--

CREATE TABLE `contrato_servicio` (
  `contratoid` varchar(5) NOT NULL,
  `servicioid` varchar(5) NOT NULL,
  `cantidad` int(4) NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE `departamento` (
  `departamentoid` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text NOT NULL,
  `tipo` enum('departamento','minidepartamento','cuarto') NOT NULL,
  `precio_mensual` decimal(6,2) NOT NULL,
  `estado` enum('disponible','ocupado','mantenimiento') NOT NULL,
  `aforo` int(2) NOT NULL,
  `ubicacion` varchar(100) NOT NULL,
  `activo` BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `garantia`
--

CREATE TABLE `garantia` (
  `garantiaid` varchar(5) NOT NULL,
  `monto` decimal(6,2) NOT NULL,
  `estado` enum('pendiente','pagado','cancelado') NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `pagoid` varchar(5) NOT NULL,
  `contratoid` varchar(5) NOT NULL,
  `fecha_pago` timestamp NOT NULL DEFAULT current_timestamp(),
  `monto` decimal(6,2) NOT NULL,
  `tipo_pago` enum('pendiente','atrasado','pagado') NOT NULL,
  `metodo_pago` enum('yape','tranferencia','efectivo','paypal','mercado pago') NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `servicioid` varchar(5) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `precio` decimal(6,2) NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `usuarioid` varchar(5) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `telefono` varchar(9) NOT NULL,
  `nacionalidad` varchar(50) NOT NULL,
  `doc_ident` varchar(50) NOT NULL,
  `correo` varchar(50) NOT NULL,
  `contrasena` varchar(50) NOT NULL,
  `activo` BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva`
--

CREATE TABLE `reserva` (
  `reservaid` VARCHAR(5) NOT NULL,
  `usuarioid` VARCHAR(5) NOT NULL,
  `departamentoid` VARCHAR(5) NOT NULL,
  `fecha_reserva` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `estado` ENUM('pendiente','confirmada','cancelada','vencida') NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_reserva`
--

CREATE TABLE `pago_reserva` (
  `pagoreservaid` VARCHAR(5) NOT NULL,
  `reservaid` VARCHAR(5) NOT NULL,
  `fecha_pago` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `monto` DECIMAL(6,2) NOT NULL,
  `metodo_pago` ENUM('yape','tranferencia','efectivo','paypal','mercado pago') NOT NULL
);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`administradorid`);

--
-- Indices de la tabla `contrato`
--
ALTER TABLE `contrato`
  ADD PRIMARY KEY (`contratoid`),
  ADD KEY `administradorid` (`administradorid`),
  ADD KEY `departamentoid` (`departamentoid`),
  ADD KEY `usuarioid` (`usuarioid`),
  ADD KEY `garantiaid` (`garantiaid`);

--
-- Indices de la tabla `contrato_servicio`
--
ALTER TABLE `contrato_servicio`
  ADD PRIMARY KEY (`contratoid`, `servicioid`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`departamentoid`);

--
-- Indices de la tabla `garantia`
--
ALTER TABLE `garantia`
  ADD PRIMARY KEY (`garantiaid`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`pagoid`),
  ADD KEY `contratoid` (`contratoid`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`servicioid`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`usuarioid`);

--
-- Indices de la tabla `reserva`
--

ALTER TABLE `reserva`
  ADD PRIMARY KEY (`reservaid`);

--
-- Indices de la tabla `pago_reserva`
--
ALTER TABLE `pago_reserva`
  ADD PRIMARY KEY (`pagoreservaid`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `contrato`
--
ALTER TABLE `contrato`
  ADD CONSTRAINT `contrato_ibfk_1` FOREIGN KEY (`administradorid`) REFERENCES `administrador` (`administradorid`),
  ADD CONSTRAINT `contrato_ibfk_2` FOREIGN KEY (`departamentoid`) REFERENCES `departamento` (`departamentoid`),
  ADD CONSTRAINT `contrato_ibfk_3` FOREIGN KEY (`usuarioid`) REFERENCES `usuario` (`usuarioid`),
  ADD CONSTRAINT `contrato_ibfk_4` FOREIGN KEY (`garantiaid`) REFERENCES `garantia` (`garantiaid`);

--
-- Filtros para la tabla `contrato_servicio`
--
ALTER TABLE `contrato_servicio`
  ADD CONSTRAINT `contrato_servicio_ibfk_1` FOREIGN KEY (`contratoid`) REFERENCES `contrato` (`contratoid`),
  ADD CONSTRAINT `contrato_servicio_ibfk_2` FOREIGN KEY (`servicioid`) REFERENCES `servicio` (`servicioid`);

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`contratoid`) REFERENCES `contrato` (`contratoid`);

--
-- Filtros para la tabla `reserva`
--

ALTER TABLE `reserva`
  ADD CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`usuarioid`) REFERENCES `usuario`(`usuarioid`),
  ADD CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`departamentoid`) REFERENCES `departamento`(`departamentoid`);

--
-- Filtros para la tabla `pago_reserva`
--

ALTER TABLE `pago_reserva`
  ADD CONSTRAINT `pago_reserva_ibfk_1` FOREIGN KEY (`reservaid`) REFERENCES `reserva`(`reservaid`);
COMMIT;

