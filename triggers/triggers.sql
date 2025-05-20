DELIMITER //
CREATE TRIGGER trg_actualizar_stock_despues_de_compra
AFTER INSERT ON Detalle_Compra_Proveedor
FOR EACH ROW
BEGIN
  UPDATE Producto
  SET stock = stock + NEW.cantidad
  WHERE id_producto = NEW.id_producto;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_desactivar_producto_sin_stock
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
  IF NEW.stock = 0 AND NEW.activo = TRUE THEN
    UPDATE Producto
    SET activo = FALSE
    WHERE id_producto = NEW.id_producto;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_verificar_calificacion_resena
BEFORE INSERT ON Resena
FOR EACH ROW
BEGIN
  IF NEW.calificacion < 1 OR NEW.calificacion > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_guardar_fecha_modificacion_producto
BEFORE UPDATE ON Producto
FOR EACH ROW
BEGIN
  SET NEW.fecha_creacion = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_evitar_eliminacion_proveedor_principal
BEFORE DELETE ON Proveedor
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Producto
    WHERE id_proveedor_principal = OLD.id_proveedor
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede eliminar el proveedor porque es proveedor principal de uno o más productos.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_verificar_email_duplicado_cliente_vendedor
BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Vendedor
    WHERE email = NEW.email
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El email ya está registrado como vendedor.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_verificar_email_duplicado_vendedor_cliente
BEFORE INSERT ON Vendedor
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Cliente
    WHERE email = NEW.email
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El email ya está registrado como cliente.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_evitar_eliminacion_cliente_con_ordenes
BEFORE DELETE ON Cliente
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Orden
    WHERE id_cliente = OLD.id_cliente
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede eliminar el cliente porque tiene órdenes asociadas.';
  END IF;
END;
//
DELIMITER ;