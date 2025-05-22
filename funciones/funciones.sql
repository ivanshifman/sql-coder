DELIMITER //
CREATE FUNCTION fn_calcular_total_orden(p_id_orden INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(cantidad * precio_unitario)
  INTO total
  FROM Detalle_Orden
  WHERE id_orden = p_id_orden;
  RETURN total;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_stock_disponible(p_id_producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE stock_actual INT;
  SELECT stock INTO stock_actual
  FROM Producto
  WHERE id_producto = p_id_producto;
  RETURN stock_actual;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_promedio_calificacion_producto(p_id_producto INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(3,2);
  SELECT AVG(calificacion)
  INTO promedio
  FROM Resena
  WHERE id_producto = p_id_producto;
  RETURN IFNULL(promedio, 0.00);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_total_compras_proveedor(p_id_proveedor INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);

  SELECT SUM(d.cantidad * d.precio_unitario)
  INTO total
  FROM Compra_Proveedor c
  JOIN Detalle_Compra_Proveedor d ON c.id_compra = d.id_compra
  WHERE c.id_proveedor = p_id_proveedor;

  RETURN IFNULL(total, 0.00);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_cantidad_productos_por_categoria(p_id_categoria INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE cantidad INT;
  SELECT COUNT(*)
  INTO cantidad
  FROM Producto
  WHERE id_categoria = p_id_categoria;
  RETURN cantidad;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_obtener_nombre_cliente(p_id_cliente INT)
RETURNS VARCHAR(101)
DETERMINISTIC
BEGIN
  DECLARE nombre_completo VARCHAR(101);
  SELECT CONCAT(nombre, ' ', apellido)
  INTO nombre_completo
  FROM Cliente
  WHERE id_cliente = p_id_cliente;
  RETURN IFNULL(nombre_completo, 'Cliente no encontrado');
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_cantidad_ordenes_cliente(p_id_cliente INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE cantidad INT;
  SELECT COUNT(*) INTO cantidad
  FROM Orden
  WHERE id_cliente = p_id_cliente;
  RETURN cantidad;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_proveedor_principal_producto(p_id_producto INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE proveedor_nombre VARCHAR(100);
  SELECT pr.nombre
  INTO proveedor_nombre
  FROM Producto p
  JOIN Proveedor pr ON p.id_proveedor_principal = pr.id_proveedor
  WHERE p.id_producto = p_id_producto;
  RETURN proveedor_nombre;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_tiempo_entrega_promedio_producto(p_id_producto INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(5,2);
  SELECT AVG(tiempo_entrega_dias)
  INTO promedio
  FROM Producto_Proveedor
  WHERE id_producto = p_id_producto;
  RETURN IFNULL(promedio, 0.00);
END;
//
DELIMITER ;