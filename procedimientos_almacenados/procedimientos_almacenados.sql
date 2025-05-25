DELIMITER //
CREATE PROCEDURE sp_insertar_orden (
    IN p_id_cliente INT,
    IN p_id_vendedor INT
)
BEGIN
    INSERT INTO Orden (id_cliente, id_vendedor)
    VALUES (p_id_cliente, p_id_vendedor);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_actualizar_stock_producto (
    IN p_id_producto INT,
    IN p_cantidad_vendida INT
)
BEGIN
    UPDATE Producto
    SET stock = stock - p_cantidad_vendida
    WHERE id_producto = p_id_producto
      AND stock >= p_cantidad_vendida;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_registrar_compra_proveedor (
    IN p_id_proveedor INT,
    IN p_numero_factura VARCHAR(50)
)
BEGIN
    INSERT INTO Compra_Proveedor (id_proveedor, numero_factura)
    VALUES (p_id_proveedor, p_numero_factura);
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE sp_insertar_resena (
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_calificacion TINYINT,
    IN p_comentario TEXT
)
BEGIN
    INSERT INTO Resena (id_cliente, id_producto, calificacion, comentario)
    VALUES (p_id_cliente, p_id_producto, p_calificacion, p_comentario);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_orden (
  IN p_id_orden INT,
  IN p_estado VARCHAR(20)
)
BEGIN
  IF p_estado IN ('pendiente', 'pagado', 'cancelado', 'enviado') THEN
    UPDATE Orden
    SET estado = p_estado
    WHERE id_orden = p_id_orden;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Estado inválido.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_eliminar_producto (
    IN p_id_producto INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_producto = p_id_producto)
       AND NOT EXISTS (SELECT 1 FROM Detalle_Compra_Proveedor WHERE id_producto = p_id_producto)
    THEN
        DELETE FROM Producto
        WHERE id_producto = p_id_producto;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_asociar_producto_a_proveedor (
    IN p_id_producto INT,
    IN p_id_proveedor INT,
    IN p_precio_compra DECIMAL(10,2),
    IN p_tiempo_entrega INT
)
BEGIN
    INSERT INTO Producto_Proveedor (
        id_producto, id_proveedor, precio_compra, tiempo_entrega_dias, es_principal
    ) VALUES (
        p_id_producto, p_id_proveedor, p_precio_compra, p_tiempo_entrega, FALSE
    );
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_aplicar_descuento_por_categoria (
  IN p_categoria VARCHAR(50),
  IN p_porcentaje_descuento DECIMAL(5,2)
)
BEGIN
  IF p_porcentaje_descuento > 0 AND p_porcentaje_descuento <= 50 THEN
    UPDATE Producto p
    JOIN Categoria c ON p.id_categoria = c.id_categoria
    SET p.precio = p.precio - (p.precio * p_porcentaje_descuento / 100)
    WHERE c.nombre_categoria = p_categoria;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Porcentaje de descuento inválido. Debe estar entre 1 y 50.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_obtener_estado_orden_descripcion (
    IN p_id_orden INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Orden WHERE id_orden = p_id_orden) THEN
        SELECT 
            id_orden,
            estado,
            CASE estado
                WHEN 'pendiente' THEN 'La orden está pendiente de pago.'
                WHEN 'pagado' THEN 'La orden ha sido pagada.'
                WHEN 'enviado' THEN 'La orden fue enviada al cliente.'
                WHEN 'cancelado' THEN 'La orden fue cancelada.'
                ELSE 'Estado desconocido.'
            END AS descripcion_estado
        FROM Orden
        WHERE id_orden = p_id_orden;
    ELSE
        SELECT 
            NULL AS id_orden,
            NULL AS estado,
            'La orden no existe.' AS descripcion_estado;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_registrar_orden_con_detalle (
  IN p_id_cliente INT,
  IN p_id_vendedor INT,
  IN p_id_producto INT,
  IN p_cantidad INT
)
BEGIN
  DECLARE v_precio_unitario DECIMAL(10,2);
  DECLARE v_id_orden INT;

  SELECT precio INTO v_precio_unitario
  FROM Producto
  WHERE id_producto = p_id_producto;

  INSERT INTO Orden (id_cliente, id_vendedor)
  VALUES (p_id_cliente, p_id_vendedor);

  SET v_id_orden = LAST_INSERT_ID();

  INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario)
  VALUES (v_id_orden, p_id_producto, p_cantidad, v_precio_unitario);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_obtener_total_compras_cliente (
    IN p_id_cliente INT,
    OUT p_total_gastado DECIMAL(10,2)
)
BEGIN
    DECLARE v_existe_orden_pagada INT;

    SELECT COUNT(*) INTO v_existe_orden_pagada
    FROM Orden
    WHERE id_cliente = p_id_cliente
      AND estado = 'pagado';

    IF v_existe_orden_pagada = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no tiene órdenes pagadas o no existe.';
    ELSE
        SELECT SUM(do.cantidad * do.precio_unitario)
        INTO p_total_gastado
        FROM Orden o
        JOIN Detalle_Orden do ON o.id_orden = do.id_orden
        WHERE o.id_cliente = p_id_cliente
          AND o.estado = 'pagado';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_ordenes_antiguas(IN dias INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_orden INT;

    DECLARE cur CURSOR FOR
        SELECT id_orden
        FROM Orden
        WHERE estado = 'pendiente' AND fecha < NOW() - INTERVAL dias DAY;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_orden;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Orden
        SET estado = 'cancelado'
        WHERE id_orden = v_id_orden;
    END LOOP;

    CLOSE cur;
END;
//
DELIMITER ;