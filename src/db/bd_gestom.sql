DROP DATABASE IF EXISTS bd_ges_tom;
CREATE DATABASE bd_ges_tom;
USE bd_ges_tom;

--
-- Base de datos: `bd_ges_tom`
--

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

CREATE PROCEDURE `sp_addPagoReserva` (IN `p_reservaid` VARCHAR(5), IN `p_monto` DECIMAL(6,2), IN `p_metodo_pago` VARCHAR(30))   BEGIN
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

CREATE PROCEDURE `sp_addReserva` (IN `p_usuarioid` VARCHAR(5), IN `p_departamentoid` VARCHAR(5), IN `p_fecha_inicio` DATE, IN `p_fecha_fin` DATE, IN `p_estado` VARCHAR(20))   BEGIN
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

CREATE PROCEDURE `sp_ganancias_ultimos_12_meses` ()   BEGIN
  WITH meses AS (
    SELECT
      DATE_FORMAT(DATE_SUB(LAST_DAY(CURDATE()), INTERVAL seq MONTH), '%Y-%m-01') AS fecha_mes
    FROM (
      SELECT 0 AS seq UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
      UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
      UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11
    ) AS seqs
  ),
  ganancias AS (
    SELECT
      DATE_FORMAT(p.fecha_pago, '%Y-%m-01') AS fecha_mes,
      SUM(p.monto) AS monto
    FROM pago p
    WHERE p.tipo_pago = 'pagado'
      AND p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
    GROUP BY DATE_FORMAT(p.fecha_pago, '%Y-%m-01')

    UNION ALL

    SELECT
      DATE_FORMAT(pr.fecha_pago, '%Y-%m-01') AS fecha_mes,
      SUM(pr.monto) AS monto
    FROM pago_reserva pr
      JOIN reserva r ON pr.reservaid = r.reservaid
    WHERE r.estado = 'confirmada'
      AND pr.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
    GROUP BY DATE_FORMAT(pr.fecha_pago, '%Y-%m-01')
  )
  SELECT
    CASE MONTH(m.fecha_mes)
      WHEN 1 THEN 'Ene'
      WHEN 2 THEN 'Feb'
      WHEN 3 THEN 'Mar'
      WHEN 4 THEN 'Abr'
      WHEN 5 THEN 'May'
      WHEN 6 THEN 'Jun'
      WHEN 7 THEN 'Jul'
      WHEN 8 THEN 'Ago'
      WHEN 9 THEN 'Sep'
      WHEN 10 THEN 'Oct'
      WHEN 11 THEN 'Nov'
      WHEN 12 THEN 'Dic'
    END AS mes,
    IFNULL(SUM(g.monto), 0) AS ganancia
  FROM meses m
  LEFT JOIN ganancias g ON m.fecha_mes = g.fecha_mes
  GROUP BY m.fecha_mes
  ORDER BY m.fecha_mes;
END$$

CREATE PROCEDURE `sp_proximos_pagos_pendientes` ()   BEGIN
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
END$$

CREATE PROCEDURE `sp_insertar_reserva_con_pago`(IN `p_usuarioid` VARCHAR(5), IN `p_departamentoid` VARCHAR(5), IN `p_fecha_inicio` DATE, IN `p_fecha_fin` DATE, IN `p_estado` VARCHAR(20), IN `p_precio` DECIMAL(6,2))
BEGIN
  -- Variables para ID de reserva
  DECLARE ultimo_id VARCHAR(5);
  DECLARE nuevo_id VARCHAR(5);
  DECLARE num INT;

  -- Variables para ID de pago_reserva
  DECLARE pr_ultimo_id VARCHAR(6);
  DECLARE pr_nuevo_id VARCHAR(6);
  DECLARE pr_num INT;

  -- Obtener último ID de reserva
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

  -- Generar nuevo ID de reserva (R0001)
  SET nuevo_id = CONCAT('R', LPAD(num, 4, '0'));

  -- Insertar nueva reserva
  INSERT INTO reserva (
    reservaid, usuarioid, departamentoid, fecha_inicio, fecha_fin, estado
  ) VALUES (
    nuevo_id, p_usuarioid, p_departamentoid, p_fecha_inicio, p_fecha_fin, p_estado
  );

  -- Obtener último ID de pago_reserva
  SELECT pagoreservaid INTO pr_ultimo_id
  FROM pago_reserva
  WHERE pagoreservaid LIKE 'PR%'
  ORDER BY pagoreservaid DESC
  LIMIT 1;

  IF pr_ultimo_id IS NULL THEN
    SET pr_num = 1;
  ELSE
    SET pr_num = CAST(SUBSTRING(pr_ultimo_id, 3) AS UNSIGNED) + 1;
  END IF;

  -- Generar nuevo ID de pago_reserva (PR0001)
  SET pr_nuevo_id = CONCAT('PR', LPAD(pr_num, 3, '0'));

  -- Insertar pago asociado
  INSERT INTO pago_reserva (
    pagoreservaid, reservaid, fecha_pago, monto, metodo_pago
  ) VALUES (
    pr_nuevo_id, nuevo_id, p_fecha_inicio, p_precio, 'tranferencia'
  );
END$$

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contrato_servicio`
--

CREATE TABLE `contrato_servicio` (
  `contratoid` varchar(5) NOT NULL,
  `servicioid` varchar(5) NOT NULL,
  `cantidad` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `garantia`
--

CREATE TABLE `garantia` (
  `garantiaid` varchar(5) NOT NULL,
  `monto` decimal(6,2) NOT NULL,
  `estado` enum('pendiente','pagado','cancelado') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_reserva`
--

CREATE TABLE `pago_reserva` (
  `pagoreservaid` varchar(5) NOT NULL,
  `reservaid` varchar(5) NOT NULL,
  `fecha_pago` timestamp NOT NULL DEFAULT current_timestamp(),
  `monto` decimal(6,2) NOT NULL,
  `metodo_pago` enum('yape','tranferencia','efectivo','paypal','mercado pago') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva`
--

CREATE TABLE `reserva` (
  `reservaid` varchar(5) NOT NULL,
  `usuarioid` varchar(5) NOT NULL,
  `departamentoid` varchar(5) NOT NULL,
  `fecha_reserva` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `estado` enum('pendiente','confirmada','cancelada','vencida') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `servicioid` varchar(5) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `precio` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  ADD PRIMARY KEY (`contratoid`,`servicioid`),
  ADD KEY `contrato_servicio_ibfk_2` (`servicioid`);

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
-- Indices de la tabla `pago_reserva`
--
ALTER TABLE `pago_reserva`
  ADD PRIMARY KEY (`pagoreservaid`),
  ADD KEY `pago_reserva_ibfk_1` (`reservaid`);

--
-- Indices de la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`reservaid`),
  ADD KEY `reserva_ibfk_1` (`usuarioid`),
  ADD KEY `reserva_ibfk_2` (`departamentoid`);

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
-- Filtros para la tabla `pago_reserva`
--
ALTER TABLE `pago_reserva`
  ADD CONSTRAINT `pago_reserva_ibfk_1` FOREIGN KEY (`reservaid`) REFERENCES `reserva` (`reservaid`);

--
-- Filtros para la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`usuarioid`) REFERENCES `usuario` (`usuarioid`),
  ADD CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`departamentoid`) REFERENCES `departamento` (`departamentoid`);
COMMIT;


-- --------------------------------------------------------
--
-- Volcado de datos para la tabla `administrador`
--

INSERT INTO `administrador` (`administradorid`, `nombres`, `apellidos`, `telefono`, `rol`, `correo`, `contrasena`) VALUES
('A0001', 'Carlos', 'Perez', '987112233', 'Gerente', 'carlos@admin.com', 'admin123'),
('A0002', 'Lucia', 'Lopez', '934567891', 'Asistente', 'lucia@admin.com', 'admin456');

-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`departamentoid`, `nombre`, `descripcion`, `tipo`, `precio_mensual`, `estado`, `aforo`, `ubicacion`, `activo`) VALUES
('D0001', 'Altissima', 'Un departamento grande y luminoso ubicado en un piso alto, con cuatro amplias habitaciones y cuatro baños elegantes. Cuenta con dos cocheras privadas y ofrece vistas panorámicas únicas al mar y a la ciudad, ideal para quienes buscan lujo y altura en cada momento.', 'departamento', 2454.00, 'disponible', 5, 'San Isidro', 1),
('D0002', 'The Icon', 'Espacioso y moderno, con tres habitaciones sofisticadas y tres baños y medio diseñados con acabados premium. Tiene dos cocheras y está situado en un piso alto, destacando por su diseño vanguardista y su terraza perfecta para recibir invitados.', 'departamento', 966.00, 'disponible', 3, 'Barranco', 1),
('D0003', 'Vittoria', 'Un departamento mediano con tres cómodas habitaciones y tres baños funcionales, ubicado en un piso alto con una cochera. Combina calidez y distinción, ideal para familias modernas que valoran el diseño europeo y la elegancia.', 'departamento', 1249.00, 'disponible', 4, 'San Borja', 1),
('D0004', 'Aurora Prime', 'Este gran departamento ofrece cuatro habitaciones y cuatro baños, dos cocheras y se encuentra en uno de los pisos más altos. Destaca por su luz natural y vistas despejadas que hacen sentir cada día como un amanecer exclusivo.', 'departamento', 920.00, 'disponible', 2, 'La Molina', 1),
('D0005', 'Mirador Imperial', 'Un departamento muy grande y majestuoso, con cinco habitaciones y cinco baños que transmiten la sensación de un palacio moderno. Con tres cocheras y ubicado en el último piso, ofrece una sala de estar de doble altura y un rooftop privado con vistas de ensueño.', 'departamento', 1494.00, 'disponible', 1, 'Surco', 1),
('D0006', 'Lumière', 'Mediano y acogedor, con tres habitaciones y dos baños y medio, una cochera y ubicado en un piso intermedio. Su diseño se centra en la luz y la apertura, logrando un ambiente cálido y elegante perfecto para relajarse.', 'departamento', 2231.00, 'disponible', 1, 'Lince', 1),
('D0007', 'Aria Residences', 'Amplio y sofisticado, con tres habitaciones y tres baños y medio, dos cocheras y ubicado en un piso alto. Su diseño fluido y armónico lo hace ideal para quienes buscan espacios elegantes inspirados en la música y el arte.', 'departamento', 2402.00, 'disponible', 5, 'Magdalena', 1),
('D0008', 'Elite', 'Este departamento mediano ofrece tres habitaciones y tres baños, una cochera y se encuentra en un piso medio. Su estilo minimalista y sus acabados de alta gama lo convierten en la opción perfecta para quienes aman la exclusividad discreta.', 'departamento', 912.00, 'disponible', 4, 'San Miguel', 1),
('D0009', 'Magnolia Grand', 'Un gran departamento con cuatro habitaciones y tres baños y medio, dos cocheras y ubicado en un piso alto. Inspirado en la naturaleza, combina balcones amplios y ambientes verdes para brindar paz y frescura.', 'departamento', 1566.00, 'disponible', 5, 'Pueblo Libre', 1),
('D0010', 'Palazzo', 'Muy grande y clásico, con cinco habitaciones y cinco baños, tres cocheras y ubicado en uno de los pisos más altos. Este espacio majestuoso está diseñado para quienes desean vivir como en un palacio moderno, lleno de detalles elegantes.', 'departamento', 1490.00, 'disponible', 2, 'Jesús María', 1),
('D0011', 'Majestic', 'Un gran departamento con cuatro habitaciones y cuatro baños, dos cocheras y ubicado en un piso alto con vistas de 360°. Perfecto para quienes disfrutan de ambientes amplios y una vista sin límites de la ciudad y el mar.', 'departamento', 2472.00, 'disponible', 3, 'Breña', 1),
('D0012', 'Alto Zenith', 'Mediano y cómodo, con tres habitaciones y tres baños, dos cocheras y situado en un piso alto. Su diseño moderno y equilibrado lo convierte en un espacio ideal para quienes valoran la altura y la tranquilidad.', 'departamento', 1348.00, 'disponible', 4, 'Chorrillos', 1),
('D0013', 'Infinity Lima', 'Gran departamento con cuatro habitaciones y tres baños y medio, dos cocheras y ubicado en un piso alto. Sus ambientes abiertos y modernos transmiten una sensación de amplitud y libertad constante.', 'departamento', 929.00, 'disponible', 5, 'Callao', 1),
('D0014', 'Signature', 'Mediano, con tres habitaciones y tres baños, una cochera y situado en un piso intermedio. Diseñado como una pieza única, este departamento ofrece un estilo artístico y personalizado en cada rincón.', 'departamento', 2449.00, 'disponible', 2, 'Villa El Salvador', 1),
('D0015', 'Crown Residences', 'Amplio y distinguido, con cuatro habitaciones y cuatro baños, dos cocheras y ubicado en un piso alto. Un espacio pensado para quienes desean vivir rodeados de lujo y comodidad, sintiéndose siempre en la cima.', 'departamento', 1382.00, 'disponible', 5, 'Villa María del Triunfo', 1),
('D0016', 'Oro Verde', 'Mediano y elegante, con tres habitaciones y tres baños, una cochera y en un piso medio. Inspirado en el lujo natural, ofrece un ambiente sofisticado que conecta con la exclusividad y el confort.', 'departamento', 2361.00, 'disponible', 1, 'Ate', 1),
('D0017', 'Astoria', 'Grande y moderno, con tres habitaciones y tres baños y medio, dos cocheras y ubicado en un piso alto. Inspirado en la sofisticación cosmopolita, ideal para quienes buscan un estilo urbano y contemporáneo.', 'departamento', 2371.00, 'disponible', 4, 'Los Olivos', 1),
('D0018', 'Prime One', 'Amplio y lujoso, con cuatro habitaciones y cuatro baños, dos cocheras y en un piso alto. Diseñado para quienes exigen lo mejor en ubicación, diseño y comodidad, siendo el lugar perfecto para una vida premium.', 'departamento', 2387.00, 'disponible', 3, 'Independencia', 1),
('D0019', 'Le Grand', 'Muy grande y señorial, con cinco habitaciones y cinco baños, tres cocheras y en un piso alto. Inspirado en la elegancia francesa, combina amplitud y detalles clásicos en un entorno sofisticado.', 'departamento', 2347.00, 'disponible', 1, 'Comas', 1),
('D0020', 'Skyline Exclusive', 'Gran departamento con cuatro habitaciones y tres baños y medio, dos cocheras y ubicado en un piso alto. Su terraza privada y la vista al horizonte limeño convierten cada atardecer en un espectáculo único.', 'departamento', 811.00, 'disponible', 3, 'El Agustino', 1),
('D0021', 'Regency', 'Mediano y elegante, con tres habitaciones y tres baños, una cochera y situado en un piso intermedio. Mezcla el estilo clásico con un toque moderno para ofrecer un ambiente distinguido y acogedor.', 'departamento', 2332.00, 'mantenimiento', 5, 'Carabayllo', 0),
('D0022', 'Ocean Pearl', 'Mediano y armonioso, con tres habitaciones y dos baños y medio, una cochera y en un piso medio. Inspirado en el mar, su ambiente transmite calma, frescura y sofisticación costera.', 'departamento', 1132.00, 'mantenimiento', 2, 'Rímac', 0),
('D0023', 'Qori Luxury', 'Grande y refinado, con cuatro habitaciones y tres baños y medio, dos cocheras y en un piso alto. Fusiona la riqueza de la cultura peruana con la elegancia moderna, creando un espacio exclusivo y único.', 'departamento', 2213.00, 'mantenimiento', 4, 'San Juan de Lurigancho', 0),
('D0024', 'Opus One', 'Mediano y artístico, con tres habitaciones y tres baños, una cochera y en un piso intermedio. Cada detalle ha sido pensado para ofrecer una experiencia elegante, como una sinfonía perfectamente compuesta.', 'departamento', 2487.00, 'mantenimiento', 3, 'San Juan de Miraflores', 0),
('D0025', 'Eterna', 'Amplio y atemporal, con cuatro habitaciones y cuatro baños, dos cocheras y ubicado en un piso alto. Diseñado para brindar confort y elegancia duradera, es un lugar donde el lujo se siente para siempre.', 'departamento', 881.00, 'mantenimiento', 3, 'Miraflores', 0);


--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`usuarioid`, `nombres`, `apellidos`, `telefono`, `nacionalidad`, `doc_ident`, `correo`, `contrasena`, `activo`) VALUES
('U0001', 'Alejandro', 'Fernández', '920280256', 'Peruana', '02432244', 'alejandro11@gmail.com', '9tnXuDss', 1),
('U0002', 'Valeria', 'Rodríguez', '927917615', 'Peruana', '46580526', 'valeria22@gmail.com', 'vpHuiYP5', 1),
('U0003', 'Santiago', 'González', '991547671', 'Peruana', '34232641', 'santiago33@gmail.com', 'VNQihCaO', 1),
('U0004', 'Camila', 'Pérez', '913054796', 'Peruana', '07107718', 'camila44@gmail.com', '9GqmxFG1', 1),
('U0005', 'Mateo', 'López', '971301771', 'Peruana', '13781990', 'mateo55@gmail.com', 'HnS5Ubqk', 1),
('U0006', 'Isabella', 'Sánchez', '912357801', 'Peruana', '12018530', 'isabella66@gmail.com', 'q1Nskg9O', 1),
('U0007', 'Nicolás', 'Ramírez', '938738407', 'Peruana', '66546778', 'nicolas77@gmail.com', 'R1t8B61y', 1),
('U0008', 'Sofía', 'Torres', '993697054', 'Peruana', '65953913', 'sofia88@gmail.com', 'ATT0Q3fN', 1),
('U0009', 'Daniel', 'Flores', '951614119', 'Peruana', '73689095', 'daniel99@gmail.com', '2lpCSzB2', 1),
('U0010', 'Martina', 'Díaz', '962101358', 'Peruana', '51548278', 'martina1010@gmail.com', 'tR0kgOoQ', 1),
('U0011', 'Diego', 'Herrera', '964216706', 'Peruana', '73412420', 'diego1111@gmail.com', 'tkwgJNAy', 1),
('U0012', 'Lucía', 'Castro', '941797011', 'Peruana', '49408936', 'lucia1212@gmail.com', 'bdDtzKh7', 1),
('U0013', 'Sebastián', 'Morales', '949410908', 'Peruana', '90419164', 'sebastian1313@gmail.com', 'Gsvhab9G', 1),
('U0014', 'Antonella', 'Romero', '998808031', 'Peruana', '53651063', 'antonella1414@gmail.com', '73be1cYi', 1),
('U0015', 'Gabriel', 'Vargas', '918556617', 'Peruana', '03491693', 'gabriel1515@gmail.com', 'Zq16GNw3', 1),
('U0016', 'Emma', 'Jiménez', '996933692', 'Peruana', '88092931', 'emma1616@gmail.com', 'PZJoReVz', 1),
('U0017', 'Andrés', 'Mendoza', '975707987', 'Peruana', '28490322', 'andres1717@gmail.com', '7n4cBa2j', 1),
('U0018', 'Victoria', 'Rojas', '956049777', 'Peruana', '55701776', 'victoria1818@gmail.com', 'suLQlIYp', 1),
('U0019', 'Juan', 'Guerrero', '952778494', 'Peruana', '55068029', 'juan1919@gmail.com', 'fdM3pd9L', 1),
('U0020', 'Renata', 'Silva', '999186111', 'Peruana', '54473863', 'renata2020@gmail.com', 'cyUC4lxG', 1),
('U0021', 'Tomás', 'Ortega', '924158139', 'Peruana', '22956176', 'tomas2121@gmail.com', 'x1ZGeywG', 0),
('U0022', 'Paula', 'Navarro', '964087175', 'Peruana', '44737999', 'paula2222@gmail.com', 'PNt5IJwf', 0),
('U0023', 'Rodrigo', 'Delgado', '928717966', 'Peruana', '52605215', 'rodrigo2323@gmail.com', 'c3dx1H1y', 0),
('U0024', 'Ana', 'Cruz', '915041413', 'Peruana', '31198324', 'ana2424@gmail.com', 'y3kFtUD1', 0),
('U0025', 'Javier', 'Reyes', '942204327', 'Peruana', '00226291', 'javier2525@gmail.com', 'bC8RQGIm', 0);


-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `garantia`
--

INSERT INTO `garantia` (`garantiaid`, `monto`, `estado`) VALUES
('G0001', 1382.00, 'pendiente'),
('G0002', 2361.00, 'pendiente'),
('G0003', 811.00, 'pendiente'),
('G0004', 2449.00, 'pendiente'),
('G0005', 2371.00, 'pendiente'),
('G0006', 1382.00, 'pendiente'),
('G0007', 912.00, 'pendiente'),
('G0008', 2371.00, 'pendiente'),
('G0009', 920.00, 'pendiente'),
('G0010', 2347.00, 'pendiente'),
('G0011', 2347.00, 'pendiente'),
('G0012', 2387.00, 'pendiente'),
('G0013', 2402.00, 'pendiente'),
('G0014', 1382.00, 'pendiente'),
('G0015', 2347.00, 'pendiente');


-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `reserva`
--

INSERT INTO `reserva` (`reservaid`, `usuarioid`, `departamentoid`, `fecha_reserva`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
('R0001', 'U0012', 'D0015', '2025-07-13 16:51:02', '2024-07-14', '2024-08-13', 'confirmada'),
('R0002', 'U0009', 'D0016', '2025-07-13 16:51:02', '2024-07-15', '2024-08-14', 'confirmada'),
('R0003', 'U0001', 'D0020', '2025-07-13 16:51:02', '2024-07-16', '2024-08-15', 'confirmada'),
('R0004', 'U0002', 'D0014', '2025-07-13 16:51:02', '2024-08-13', '2024-09-12', 'confirmada'),
('R0005', 'U0015', 'D0017', '2025-07-13 16:51:02', '2024-08-14', '2024-09-13', 'confirmada'),
('R0006', 'U0013', 'D0015', '2025-07-13 16:51:02', '2024-08-15', '2024-09-14', 'confirmada'),
('R0007', 'U0007', 'D0008', '2025-07-13 16:51:02', '2024-09-12', '2024-10-12', 'confirmada'),
('R0008', 'U0009', 'D0017', '2025-07-13 16:51:02', '2024-09-13', '2024-10-13', 'confirmada'),
('R0009', 'U0019', 'D0004', '2025-07-13 16:51:02', '2024-09-14', '2024-10-14', 'confirmada'),
('R0010', 'U0002', 'D0019', '2025-07-13 16:51:02', '2024-10-12', '2024-11-11', 'confirmada'),
('R0011', 'U0010', 'D0019', '2025-07-13 16:51:02', '2024-10-13', '2024-11-12', 'confirmada'),
('R0012', 'U0005', 'D0018', '2025-07-13 16:51:02', '2024-10-14', '2024-11-13', 'confirmada'),
('R0013', 'U0006', 'D0007', '2025-07-13 16:51:02', '2024-11-11', '2024-12-11', 'confirmada'),
('R0014', 'U0018', 'D0015', '2025-07-13 16:51:02', '2024-11-12', '2024-12-12', 'confirmada'),
('R0015', 'U0009', 'D0019', '2025-07-13 16:51:02', '2024-11-13', '2024-12-13', 'confirmada'),
('R0016', 'U0010', 'D0012', '2025-07-13 16:51:02', '2024-12-11', '2025-01-10', 'confirmada'),
('R0017', 'U0008', 'D0014', '2025-07-13 16:51:02', '2024-12-12', '2025-01-11', 'confirmada'),
('R0018', 'U0014', 'D0011', '2025-07-13 16:51:02', '2024-12-13', '2025-01-12', 'confirmada'),
('R0019', 'U0012', 'D0006', '2025-07-13 16:51:02', '2025-01-10', '2025-02-09', 'confirmada'),
('R0020', 'U0006', 'D0016', '2025-07-13 16:51:02', '2025-01-11', '2025-02-10', 'confirmada'),
('R0021', 'U0001', 'D0007', '2025-07-13 16:51:02', '2025-01-12', '2025-02-11', 'confirmada'),
('R0022', 'U0016', 'D0015', '2025-07-13 16:51:02', '2025-02-09', '2025-03-11', 'confirmada'),
('R0023', 'U0018', 'D0009', '2025-07-13 16:51:02', '2025-02-10', '2025-03-12', 'confirmada'),
('R0024', 'U0020', 'D0017', '2025-07-13 16:51:02', '2025-02-11', '2025-03-13', 'confirmada'),
('R0025', 'U0014', 'D0002', '2025-07-13 16:51:02', '2025-03-11', '2025-04-10', 'confirmada'),
('R0026', 'U0008', 'D0009', '2025-07-13 16:51:02', '2025-03-12', '2025-04-11', 'confirmada'),
('R0027', 'U0017', 'D0020', '2025-07-13 16:51:02', '2025-03-13', '2025-04-12', 'confirmada'),
('R0028', 'U0003', 'D0015', '2025-07-13 16:51:02', '2025-04-10', '2025-05-10', 'confirmada'),
('R0029', 'U0010', 'D0017', '2025-07-13 16:51:02', '2025-04-11', '2025-05-11', 'confirmada'),
('R0030', 'U0007', 'D0003', '2025-07-13 16:51:02', '2025-04-12', '2025-05-12', 'confirmada'),
('R0031', 'U0012', 'D0001', '2025-07-13 16:51:02', '2025-05-10', '2025-06-09', 'confirmada'),
('R0032', 'U0004', 'D0020', '2025-07-13 16:51:02', '2025-05-11', '2025-06-10', 'confirmada'),
('R0033', 'U0005', 'D0009', '2025-07-13 16:51:02', '2025-05-12', '2025-06-11', 'confirmada'),
('R0034', 'U0012', 'D0007', '2025-07-13 16:51:02', '2025-06-09', '2025-07-09', 'confirmada'),
('R0035', 'U0006', 'D0014', '2025-07-13 16:51:02', '2025-06-10', '2025-07-10', 'confirmada'),
('R0036', 'U0006', 'D0002', '2025-07-13 16:51:02', '2025-06-11', '2025-07-11', 'confirmada');

-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `pago_reserva`
--

INSERT INTO `pago_reserva` (`pagoreservaid`, `reservaid`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
('PR001', 'R0001', '2025-07-13 16:51:02', 691.00, 'yape'),
('PR002', 'R0002', '2025-07-13 16:51:02', 1180.50, 'yape'),
('PR003', 'R0003', '2025-07-13 16:51:02', 405.50, 'yape'),
('PR004', 'R0004', '2025-07-13 16:51:02', 1224.50, 'yape'),
('PR005', 'R0005', '2025-07-13 16:51:02', 1185.50, 'yape'),
('PR006', 'R0006', '2025-07-13 16:51:02', 691.00, 'yape'),
('PR007', 'R0007', '2025-07-13 16:51:02', 456.00, 'yape'),
('PR008', 'R0008', '2025-07-13 16:51:02', 1185.50, 'yape'),
('PR009', 'R0009', '2025-07-13 16:51:02', 460.00, 'yape'),
('PR010', 'R0010', '2025-07-13 16:51:02', 1173.50, 'yape'),
('PR011', 'R0011', '2025-07-13 16:51:02', 1173.50, 'yape'),
('PR012', 'R0012', '2025-07-13 16:51:02', 1193.50, 'yape'),
('PR013', 'R0013', '2025-07-13 16:51:02', 1201.00, 'yape'),
('PR014', 'R0014', '2025-07-13 16:51:02', 691.00, 'yape'),
('PR015', 'R0015', '2025-07-13 16:51:02', 1173.50, 'yape'),
('PR016', 'R0016', '2025-07-13 16:51:02', 674.00, 'yape'),
('PR017', 'R0017', '2025-07-13 16:51:02', 1224.50, 'yape'),
('PR018', 'R0018', '2025-07-13 16:51:02', 1236.00, 'yape'),
('PR019', 'R0019', '2025-07-13 16:51:02', 1115.50, 'yape'),
('PR020', 'R0020', '2025-07-13 16:51:02', 1180.50, 'yape'),
('PR021', 'R0021', '2025-07-13 16:51:02', 1201.00, 'yape'),
('PR022', 'R0022', '2025-07-13 16:51:02', 691.00, 'yape'),
('PR023', 'R0023', '2025-07-13 16:51:02', 783.00, 'yape'),
('PR024', 'R0024', '2025-07-13 16:51:02', 1185.50, 'yape'),
('PR025', 'R0025', '2025-07-13 16:51:02', 483.00, 'yape'),
('PR026', 'R0026', '2025-07-13 16:51:02', 783.00, 'yape'),
('PR027', 'R0027', '2025-07-13 16:51:02', 405.50, 'yape'),
('PR028', 'R0028', '2025-07-13 16:51:02', 691.00, 'yape'),
('PR029', 'R0029', '2025-07-13 16:51:02', 1185.50, 'yape'),
('PR030', 'R0030', '2025-07-13 16:51:02', 624.50, 'yape'),
('PR031', 'R0031', '2025-07-13 16:51:02', 1227.00, 'yape'),
('PR032', 'R0032', '2025-07-13 16:51:02', 405.50, 'yape'),
('PR033', 'R0033', '2025-07-13 16:51:02', 783.00, 'yape'),
('PR034', 'R0034', '2025-07-13 16:51:02', 1201.00, 'yape'),
('PR035', 'R0035', '2025-07-13 16:51:02', 1224.50, 'yape'),
('PR036', 'R0036', '2025-07-13 16:51:02', 483.00, 'yape');

-- Agosto 2025
INSERT INTO `reserva` (`reservaid`, `usuarioid`, `departamentoid`, `fecha_reserva`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
('R0037', 'U0021', 'D0021', '2025-07-20 10:15:00', '2025-08-01', '2025-08-31', 'confirmada'),
('R0038', 'U0003', 'D0005', '2025-07-21 14:30:00', '2025-08-05', '2025-09-04', 'confirmada'),
('R0039', 'U0017', 'D0023', '2025-07-22 16:45:00', '2025-08-10', '2025-09-09', 'confirmada'),
('R0040', 'U0024', 'D0010', '2025-07-25 11:20:00', '2025-08-15', '2025-09-14', 'confirmada');

INSERT INTO `pago_reserva` (`pagoreservaid`, `reservaid`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
('PR037', 'R0037', '2025-07-20 10:15:00', 850.00, 'tranferencia'),
('PR038', 'R0038', '2025-07-21 14:30:00', 720.50, 'yape'),
('PR039', 'R0039', '2025-07-22 16:45:00', 950.75, 'tranferencia'),
('PR040', 'R0040', '2025-07-25 11:20:00', 680.25, 'yape');

-- Septiembre 2025
INSERT INTO `reserva` (`reservaid`, `usuarioid`, `departamentoid`, `fecha_reserva`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
('R0041', 'U0005', 'D0022', '2025-08-10 09:00:00', '2025-09-01', '2025-09-30', 'confirmada'),
('R0042', 'U0011', 'D0003', '2025-08-12 13:45:00', '2025-09-05', '2025-10-05', 'confirmada'),
('R0043', 'U0023', 'D0018', '2025-08-15 17:30:00', '2025-09-10', '2025-10-10', 'confirmada'),
('R0044', 'U0008', 'D0024', '2025-08-18 10:20:00', '2025-09-15', '2025-10-15', 'confirmada');

INSERT INTO `pago_reserva` (`pagoreservaid`, `reservaid`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
('PR041', 'R0041', '2025-08-10 09:00:00', 890.50, 'tranferencia'),
('PR042', 'R0042', '2025-08-12 13:45:00', 625.00, 'yape'),
('PR043', 'R0043', '2025-08-15 17:30:00', 1120.75, 'tranferencia'),
('PR044', 'R0044', '2025-08-18 10:20:00', 950.25, 'yape');

-- Octubre 2025
INSERT INTO `reserva` (`reservaid`, `usuarioid`, `departamentoid`, `fecha_reserva`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
('R0045', 'U0019', 'D0025', '2025-09-05 11:10:00', '2025-10-01', '2025-10-31', 'confirmada'),
('R0046', 'U0002', 'D0006', '2025-09-10 14:25:00', '2025-10-05', '2025-11-04', 'confirmada'),
('R0047', 'U0020', 'D0013', '2025-09-12 16:40:00', '2025-10-10', '2025-11-09', 'confirmada'),
('R0048', 'U0014', 'D0004', '2025-09-15 10:15:00', '2025-10-15', '2025-11-14', 'confirmada'),
('R0049', 'U0007', 'D0001', '2025-09-18 12:30:00', '2025-10-20', '2025-11-19', 'confirmada');

INSERT INTO `pago_reserva` (`pagoreservaid`, `reservaid`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
('PR045', 'R0045', '2025-09-05 11:10:00', 1100.00, 'tranferencia'),
('PR046', 'R0046', '2025-09-10 14:25:00', 750.50, 'yape'),
('PR047', 'R0047', '2025-09-12 16:40:00', 980.75, 'tranferencia'),
('PR048', 'R0048', '2025-09-15 10:15:00', 860.25, 'yape'),
('PR049', 'R0049', '2025-09-18 12:30:00', 720.00, 'tranferencia');

-- Noviembre 2025
INSERT INTO `reserva` (`reservaid`, `usuarioid`, `departamentoid`, `fecha_reserva`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
('R0050', 'U0022', 'D0007', '2025-10-01 09:45:00', '2025-11-01', '2025-11-30', 'confirmada'),
('R0051', 'U0009', 'D0012', '2025-10-05 13:20:00', '2025-11-05', '2025-12-05', 'confirmada'),
('R0052', 'U0016', 'D0020', '2025-10-10 16:10:00', '2025-11-10', '2025-12-10', 'confirmada'),
('R0053', 'U0004', 'D0008', '2025-10-15 11:35:00', '2025-11-15', '2025-12-15', 'confirmada');

INSERT INTO `pago_reserva` (`pagoreservaid`, `reservaid`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
('PR050', 'R0050', '2025-10-01 09:45:00', 1025.50, 'yape'),
('PR051', 'R0051', '2025-10-05 13:20:00', 880.00, 'tranferencia'),
('PR052', 'R0052', '2025-10-10 16:10:00', 945.75, 'yape'),
('PR053', 'R0053', '2025-10-15 11:35:00', 790.25, 'tranferencia');

-- Diciembre 2025
INSERT INTO `reserva` (`reservaid`, `usuarioid`, `departamentoid`, `fecha_reserva`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
('R0054', 'U0025', 'D0009', '2025-11-05 10:50:00', '2025-12-01', '2025-12-31', 'confirmada'),
('R0055', 'U0013', 'D0011', '2025-11-10 14:15:00', '2025-12-05', '2026-01-04', 'confirmada'),
('R0056', 'U0006', 'D0014', '2025-11-15 17:25:00', '2025-12-10', '2026-01-09', 'confirmada'),
('R0057', 'U0018', 'D0016', '2025-11-20 11:40:00', '2025-12-15', '2026-01-14', 'confirmada'),
('R0058', 'U0021', 'D0019', '2025-11-25 09:30:00', '2025-12-20', '2026-01-19', 'confirmada');

INSERT INTO `pago_reserva` (`pagoreservaid`, `reservaid`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
('PR054', 'R0054', '2025-11-05 10:50:00', 1250.00, 'tranferencia'),
('PR055', 'R0055', '2025-11-10 14:15:00', 910.50, 'yape'),
('PR056', 'R0056', '2025-11-15 17:25:00', 1050.75, 'tranferencia'),
('PR057', 'R0057', '2025-11-20 11:40:00', 1180.25, 'yape'),
('PR058', 'R0058', '2025-11-25 09:30:00', 1320.00, 'tranferencia');

-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `contrato`
--

INSERT INTO `contrato` (`contratoid`, `administradorid`, `usuarioid`, `departamentoid`, `garantiaid`, `fecha_inicio`, `fecha_fin`, `estado`, `monto`) VALUES
('C0001', 'A0001', 'U0012', 'D0015', 'G0001', '2024-07-14 05:00:00', '2024-08-13 05:00:00', 'activo', 1382.00),
('C0002', 'A0001', 'U0009', 'D0016', 'G0002', '2024-07-15 05:00:00', '2024-08-14 05:00:00', 'activo', 2361.00),
('C0003', 'A0001', 'U0001', 'D0020', 'G0003', '2024-07-16 05:00:00', '2024-08-15 05:00:00', 'activo', 811.00),
('C0004', 'A0001', 'U0002', 'D0014', 'G0004', '2024-08-13 05:00:00', '2024-09-12 05:00:00', 'activo', 2449.00),
('C0005', 'A0001', 'U0015', 'D0017', 'G0005', '2024-08-14 05:00:00', '2024-09-13 05:00:00', 'activo', 2371.00),
('C0006', 'A0001', 'U0013', 'D0015', 'G0006', '2024-08-15 05:00:00', '2024-09-14 05:00:00', 'activo', 1382.00),
('C0007', 'A0001', 'U0007', 'D0008', 'G0007', '2024-09-12 05:00:00', '2024-10-12 05:00:00', 'activo', 912.00),
('C0008', 'A0001', 'U0009', 'D0017', 'G0008', '2024-09-13 05:00:00', '2024-10-13 05:00:00', 'activo', 2371.00),
('C0009', 'A0001', 'U0019', 'D0004', 'G0009', '2024-09-14 05:00:00', '2024-10-14 05:00:00', 'activo', 920.00),
('C0010', 'A0001', 'U0002', 'D0019', 'G0010', '2024-10-12 05:00:00', '2024-11-11 05:00:00', 'activo', 2347.00),
('C0011', 'A0001', 'U0010', 'D0019', 'G0011', '2024-10-13 05:00:00', '2024-11-12 05:00:00', 'activo', 2347.00),
('C0012', 'A0001', 'U0005', 'D0018', 'G0012', '2024-10-14 05:00:00', '2024-11-13 05:00:00', 'activo', 2387.00),
('C0013', 'A0001', 'U0006', 'D0007', 'G0013', '2024-11-11 05:00:00', '2024-12-11 05:00:00', 'activo', 2402.00),
('C0014', 'A0001', 'U0018', 'D0015', 'G0014', '2024-11-12 05:00:00', '2024-12-12 05:00:00', 'activo', 1382.00),
('C0015', 'A0001', 'U0009', 'D0019', 'G0015', '2024-11-13 05:00:00', '2024-12-13 05:00:00', 'activo', 2347.00);

-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`pagoid`, `contratoid`, `fecha_pago`, `monto`, `tipo_pago`, `metodo_pago`) VALUES
('P0001', 'C0001', '2024-08-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0002', 'C0001', '2024-09-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0003', 'C0001', '2024-10-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0004', 'C0001', '2024-11-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0005', 'C0001', '2024-12-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0006', 'C0001', '2025-01-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0007', 'C0001', '2025-02-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0008', 'C0001', '2025-03-05 05:00:00', 1000.00, 'pagado', 'efectivo'),
('P0009', 'C0001', '2025-04-05 05:00:00', 1000.00, 'atrasado', 'efectivo'),
('P0010', 'C0001', '2025-05-05 05:00:00', 1000.00, 'atrasado', 'efectivo'),
('P0011', 'C0001', '2025-06-05 05:00:00', 1000.00, 'pendiente', 'efectivo'),
('P0012', 'C0002', '2024-09-12 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0013', 'C0002', '2024-10-12 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0014', 'C0002', '2024-11-11 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0015', 'C0002', '2024-12-11 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0016', 'C0002', '2025-01-10 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0017', 'C0002', '2025-02-09 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0018', 'C0002', '2025-03-11 05:00:00', 1520.00, 'pagado', 'tranferencia'),
('P0019', 'C0002', '2025-04-10 05:00:00', 1520.00, 'atrasado', 'tranferencia'),
('P0020', 'C0002', '2025-05-10 05:00:00', 1520.00, 'atrasado', 'tranferencia'),
('P0021', 'C0002', '2025-06-09 05:00:00', 1520.00, 'pendiente', 'tranferencia'),
('P0022', 'C0002', '2025-07-09 05:00:00', 1520.00, 'pendiente', 'tranferencia'),
('P0023', 'C0003', '2024-05-17 05:00:00', 811.00, 'pagado', 'efectivo'),
('P0024', 'C0003', '2024-06-16 05:00:00', 811.00, 'pagado', 'efectivo'),
('P0025', 'C0003', '2024-07-16 05:00:00', 811.00, 'pagado', 'efectivo'),
('P0026', 'C0003', '2024-08-15 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0027', 'C0003', '2024-09-14 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0028', 'C0003', '2024-10-14 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0029', 'C0003', '2024-11-13 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0030', 'C0003', '2024-12-13 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0031', 'C0003', '2025-01-12 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0032', 'C0003', '2025-02-11 05:00:00', 811.00, 'pagado', 'tranferencia'),
('P0033', 'C0003', '2025-03-13 05:00:00', 811.00, 'atrasado', 'tranferencia'),
('P0034', 'C0003', '2025-04-12 05:00:00', 811.00, 'atrasado', 'tranferencia'),
('P0035', 'C0003', '2025-05-12 05:00:00', 811.00, 'pendiente', 'tranferencia'),
('P0036', 'C0003', '2025-06-11 05:00:00', 811.00, 'pendiente', 'tranferencia'),
('P0037', 'C0004', '2024-10-07 05:00:00', 1622.00, 'pagado', 'efectivo'),
('P0038', 'C0004', '2024-11-06 05:00:00', 1622.00, 'pagado', 'efectivo'),
('P0039', 'C0004', '2024-12-06 05:00:00', 1622.00, 'pagado', 'efectivo'),
('P0040', 'C0004', '2025-01-05 05:00:00', 1622.00, 'pagado', 'efectivo'),
('P0041', 'C0004', '2025-02-04 05:00:00', 1622.00, 'pagado', 'efectivo'),
('P0042', 'C0004', '2025-03-06 05:00:00', 1622.00, 'pagado', 'efectivo'),
('P0043', 'C0004', '2025-04-05 05:00:00', 1622.00, 'atrasado', 'efectivo'),
('P0044', 'C0004', '2025-05-05 05:00:00', 1622.00, 'atrasado', 'efectivo'),
('P0045', 'C0004', '2025-06-04 05:00:00', 1622.00, 'pendiente', 'efectivo'),
('P0046', 'C0004', '2025-07-04 05:00:00', 1622.00, 'pendiente', 'efectivo'),
('P0047', 'C0005', '2024-11-05 05:00:00', 1302.00, 'pagado', 'efectivo'),
('P0048', 'C0005', '2024-12-05 05:00:00', 1302.00, 'pagado', 'efectivo'),
('P0049', 'C0005', '2025-01-04 05:00:00', 1302.00, 'pagado', 'efectivo'),
('P0050', 'C0005', '2025-02-03 05:00:00', 1302.00, 'pagado', 'efectivo'),
('P0051', 'C0005', '2025-03-05 05:00:00', 1302.00, 'pagado', 'efectivo'),
('P0052', 'C0005', '2025-04-04 05:00:00', 1302.00, 'atrasado', 'efectivo'),
('P0053', 'C0005', '2025-05-04 05:00:00', 1302.00, 'atrasado', 'efectivo'),
('P0054', 'C0005', '2025-06-03 05:00:00', 1302.00, 'pendiente', 'efectivo'),
('P0055', 'C0005', '2025-07-03 05:00:00', 1302.00, 'pendiente', 'efectivo'),
('P0056', 'C0006', '2024-07-18 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0057', 'C0006', '2024-08-17 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0058', 'C0006', '2024-09-16 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0059', 'C0006', '2024-10-16 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0060', 'C0006', '2024-11-15 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0061', 'C0006', '2024-12-15 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0062', 'C0006', '2025-01-14 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0063', 'C0006', '2025-02-13 05:00:00', 1453.00, 'pagado', 'efectivo'),
('P0064', 'C0006', '2025-03-15 05:00:00', 1453.00, 'atrasado', 'efectivo'),
('P0065', 'C0006', '2025-04-14 05:00:00', 1453.00, 'atrasado', 'efectivo'),
('P0066', 'C0006', '2025-05-14 05:00:00', 1453.00, 'pendiente', 'efectivo'),
('P0067', 'C0006', '2025-06-13 05:00:00', 1453.00, 'pendiente', 'efectivo'),
('P0068', 'C0006', '2025-03-13 05:00:00', 1382.00, 'atrasado', 'tranferencia'),
('P0069', 'C0006', '2025-04-12 05:00:00', 1382.00, 'atrasado', 'tranferencia'),
('P0070', 'C0006', '2025-05-12 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0071', 'C0006', '2025-06-11 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0072', 'C0006', '2025-07-11 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0073', 'C0007', '2024-09-12 05:00:00', 912.00, 'pagado', 'tranferencia'),
('P0074', 'C0007', '2024-10-12 05:00:00', 912.00, 'pagado', 'tranferencia'),
('P0075', 'C0007', '2024-11-11 05:00:00', 912.00, 'pagado', 'tranferencia'),
('P0076', 'C0007', '2024-12-11 05:00:00', 912.00, 'pagado', 'tranferencia'),
('P0077', 'C0007', '2025-01-10 05:00:00', 912.00, 'pagado', 'tranferencia'),
('P0078', 'C0007', '2025-02-09 05:00:00', 912.00, 'pagado', 'tranferencia'),
('P0079', 'C0007', '2025-03-11 05:00:00', 912.00, 'atrasado', 'tranferencia'),
('P0080', 'C0007', '2025-04-10 05:00:00', 912.00, 'atrasado', 'tranferencia'),
('P0081', 'C0007', '2025-05-10 05:00:00', 912.00, 'pendiente', 'tranferencia'),
('P0082', 'C0007', '2025-06-09 05:00:00', 912.00, 'pendiente', 'tranferencia'),
('P0083', 'C0007', '2025-07-09 05:00:00', 912.00, 'pendiente', 'tranferencia'),
('P0084', 'C0007', '2025-08-08 05:00:00', 912.00, 'pendiente', 'tranferencia'),
('P0085', 'C0008', '2024-09-13 05:00:00', 2371.00, 'pagado', 'tranferencia'),
('P0086', 'C0008', '2024-10-13 05:00:00', 2371.00, 'pagado', 'tranferencia'),
('P0087', 'C0008', '2024-11-12 05:00:00', 2371.00, 'pagado', 'tranferencia'),
('P0088', 'C0008', '2024-12-12 05:00:00', 2371.00, 'pagado', 'tranferencia'),
('P0089', 'C0008', '2025-01-11 05:00:00', 2371.00, 'pagado', 'tranferencia'),
('P0090', 'C0008', '2025-02-10 05:00:00', 2371.00, 'pagado', 'tranferencia'),
('P0091', 'C0008', '2025-03-12 05:00:00', 2371.00, 'atrasado', 'tranferencia'),
('P0092', 'C0008', '2025-04-11 05:00:00', 2371.00, 'atrasado', 'tranferencia'),
('P0093', 'C0008', '2025-05-11 05:00:00', 2371.00, 'pendiente', 'tranferencia'),
('P0094', 'C0008', '2025-06-10 05:00:00', 2371.00, 'pendiente', 'tranferencia'),
('P0095', 'C0008', '2025-07-10 05:00:00', 2371.00, 'pendiente', 'tranferencia'),
('P0096', 'C0008', '2025-08-09 05:00:00', 2371.00, 'pendiente', 'tranferencia'),
('P0097', 'C0009', '2024-09-14 05:00:00', 920.00, 'pagado', 'tranferencia'),
('P0098', 'C0009', '2024-10-14 05:00:00', 920.00, 'pagado', 'tranferencia'),
('P0099', 'C0009', '2024-11-13 05:00:00', 920.00, 'pagado', 'tranferencia'),
('P0100', 'C0009', '2024-12-13 05:00:00', 920.00, 'pagado', 'tranferencia'),
('P0101', 'C0009', '2025-01-12 05:00:00', 920.00, 'pagado', 'tranferencia'),
('P0102', 'C0009', '2025-02-11 05:00:00', 920.00, 'pagado', 'tranferencia'),
('P0103', 'C0009', '2025-03-13 05:00:00', 920.00, 'atrasado', 'tranferencia'),
('P0104', 'C0009', '2025-04-12 05:00:00', 920.00, 'atrasado', 'tranferencia'),
('P0105', 'C0009', '2025-05-12 05:00:00', 920.00, 'pendiente', 'tranferencia'),
('P0106', 'C0009', '2025-06-11 05:00:00', 920.00, 'pendiente', 'tranferencia'),
('P0107', 'C0009', '2025-07-11 05:00:00', 920.00, 'pendiente', 'tranferencia'),
('P0108', 'C0009', '2025-08-10 05:00:00', 920.00, 'pendiente', 'tranferencia'),
('P0109', 'C0010', '2024-10-12 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0110', 'C0010', '2024-11-11 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0111', 'C0010', '2024-12-11 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0112', 'C0010', '2025-01-10 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0113', 'C0010', '2025-02-09 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0114', 'C0010', '2025-03-11 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0115', 'C0010', '2025-04-10 05:00:00', 2347.00, 'atrasado', 'tranferencia'),
('P0116', 'C0010', '2025-05-10 05:00:00', 2347.00, 'atrasado', 'tranferencia'),
('P0117', 'C0010', '2025-06-09 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0118', 'C0010', '2025-07-09 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0119', 'C0010', '2025-08-08 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0120', 'C0010', '2025-09-07 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0121', 'C0011', '2024-10-13 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0122', 'C0011', '2024-11-12 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0123', 'C0011', '2024-12-12 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0124', 'C0011', '2025-01-11 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0125', 'C0011', '2025-02-10 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0126', 'C0011', '2025-03-12 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0127', 'C0011', '2025-04-11 05:00:00', 2347.00, 'atrasado', 'tranferencia'),
('P0128', 'C0011', '2025-05-11 05:00:00', 2347.00, 'atrasado', 'tranferencia'),
('P0129', 'C0011', '2025-06-10 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0130', 'C0011', '2025-07-10 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0131', 'C0011', '2025-08-09 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0132', 'C0011', '2025-09-08 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0133', 'C0012', '2024-10-14 05:00:00', 2387.00, 'pagado', 'tranferencia'),
('P0134', 'C0012', '2024-11-13 05:00:00', 2387.00, 'pagado', 'tranferencia'),
('P0135', 'C0012', '2024-12-13 05:00:00', 2387.00, 'pagado', 'tranferencia'),
('P0136', 'C0012', '2025-01-12 05:00:00', 2387.00, 'pagado', 'tranferencia'),
('P0137', 'C0012', '2025-02-11 05:00:00', 2387.00, 'pagado', 'tranferencia'),
('P0138', 'C0012', '2025-03-13 05:00:00', 2387.00, 'pagado', 'tranferencia'),
('P0139', 'C0012', '2025-04-12 05:00:00', 2387.00, 'atrasado', 'tranferencia'),
('P0140', 'C0012', '2025-05-12 05:00:00', 2387.00, 'atrasado', 'tranferencia'),
('P0141', 'C0012', '2025-06-11 05:00:00', 2387.00, 'pendiente', 'tranferencia'),
('P0142', 'C0012', '2025-07-11 05:00:00', 2387.00, 'pendiente', 'tranferencia'),
('P0143', 'C0012', '2025-08-10 05:00:00', 2387.00, 'pendiente', 'tranferencia'),
('P0144', 'C0012', '2025-09-09 05:00:00', 2387.00, 'pendiente', 'tranferencia'),
('P0145', 'C0013', '2024-11-11 05:00:00', 2402.00, 'pagado', 'tranferencia'),
('P0146', 'C0013', '2024-12-11 05:00:00', 2402.00, 'pagado', 'tranferencia'),
('P0147', 'C0013', '2025-01-10 05:00:00', 2402.00, 'pagado', 'tranferencia'),
('P0148', 'C0013', '2025-02-09 05:00:00', 2402.00, 'pagado', 'tranferencia'),
('P0149', 'C0013', '2025-03-11 05:00:00', 2402.00, 'pagado', 'tranferencia'),
('P0150', 'C0013', '2025-04-10 05:00:00', 2402.00, 'pagado', 'tranferencia'),
('P0151', 'C0013', '2025-05-10 05:00:00', 2402.00, 'atrasado', 'tranferencia'),
('P0152', 'C0013', '2025-06-09 05:00:00', 2402.00, 'atrasado', 'tranferencia'),
('P0153', 'C0013', '2025-07-09 05:00:00', 2402.00, 'pendiente', 'tranferencia'),
('P0154', 'C0013', '2025-08-08 05:00:00', 2402.00, 'pendiente', 'tranferencia'),
('P0155', 'C0013', '2025-09-07 05:00:00', 2402.00, 'pendiente', 'tranferencia'),
('P0156', 'C0013', '2025-10-07 05:00:00', 2402.00, 'pendiente', 'tranferencia'),
('P0157', 'C0014', '2024-11-12 05:00:00', 1382.00, 'pagado', 'tranferencia'),
('P0158', 'C0014', '2024-12-12 05:00:00', 1382.00, 'pagado', 'tranferencia'),
('P0159', 'C0014', '2025-01-11 05:00:00', 1382.00, 'pagado', 'tranferencia'),
('P0160', 'C0014', '2025-02-10 05:00:00', 1382.00, 'pagado', 'tranferencia'),
('P0161', 'C0014', '2025-03-12 05:00:00', 1382.00, 'pagado', 'tranferencia'),
('P0162', 'C0014', '2025-04-11 05:00:00', 1382.00, 'pagado', 'tranferencia'),
('P0163', 'C0014', '2025-05-11 05:00:00', 1382.00, 'atrasado', 'tranferencia'),
('P0164', 'C0014', '2025-06-10 05:00:00', 1382.00, 'atrasado', 'tranferencia'),
('P0165', 'C0014', '2025-07-10 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0166', 'C0014', '2025-08-09 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0167', 'C0014', '2025-09-08 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0168', 'C0014', '2025-10-08 05:00:00', 1382.00, 'pendiente', 'tranferencia'),
('P0169', 'C0015', '2024-11-13 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0170', 'C0015', '2024-12-13 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0171', 'C0015', '2025-01-12 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0172', 'C0015', '2025-02-11 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0173', 'C0015', '2025-03-13 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0174', 'C0015', '2025-04-12 05:00:00', 2347.00, 'pagado', 'tranferencia'),
('P0175', 'C0015', '2025-05-12 05:00:00', 2347.00, 'atrasado', 'tranferencia'),
('P0176', 'C0015', '2025-06-11 05:00:00', 2347.00, 'atrasado', 'tranferencia'),
('P0177', 'C0015', '2025-07-11 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0178', 'C0015', '2025-08-10 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0179', 'C0015', '2025-09-09 05:00:00', 2347.00, 'pendiente', 'tranferencia'),
('P0180', 'C0015', '2025-10-09 05:00:00', 2347.00, 'pendiente', 'tranferencia');