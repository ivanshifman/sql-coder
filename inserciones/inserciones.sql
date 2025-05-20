INSERT INTO Cliente (nombre, apellido, email, telefono) VALUES
('Lucas', 'Pérez', 'lucas.perez@gmail.com', '1122334455'),
('María', 'Gómez', 'maria.gomez@yahoo.com', '1133445566'),
('Carlos', 'Sosa', 'csosa@hotmail.com', '1144556677');

INSERT INTO Vendedor (nombre, apellido, email, telefono) VALUES
('Ana', 'Ramírez', 'ana.ramirez@empresa.com', '1155667788'),
('Jorge', 'López', 'jorge.lopez@empresa.com', '1166778899');

INSERT INTO Categoria (nombre_categoria, descripcion_categoria) VALUES
('Electrónica', 'Dispositivos electrónicos en general'),
('Ropa', 'Prendas de vestir'),
('Hogar', 'Artículos para el hogar');

INSERT INTO Proveedor (nombre, telefono, email, direccion) VALUES
('Tech Supplies S.A.', '1234567890', 'contacto@techsupplies.com', 'Av. Siempre Viva 123'),
('ModaExpress', '0987654321', 'ventas@modaexpress.com', 'Calle 45 #23'),
('HogarPlus', '1122334455', 'soporte@hogarplus.com', 'Av. Las Rosas 777');

INSERT INTO Producto (nombre_producto, descripcion, precio, stock, id_categoria, id_proveedor_principal) VALUES
('Smartphone X1', 'Teléfono inteligente 5G', 299.99, 50, 1, 1),
('Camisa Slim Fit', 'Camisa algodón talla M', 25.00, 100, 2, 2),
('Lámpara LED', 'Lámpara bajo consumo', 18.50, 200, 3, 3);

INSERT INTO Producto_Proveedor (id_producto, id_proveedor, precio_compra, tiempo_entrega_dias, es_principal) VALUES
(1, 1, 220.00, 5, TRUE),
(1, 3, 230.00, 6, FALSE),
(2, 2, 15.00, 3, TRUE),
(3, 3, 10.00, 2, TRUE);

INSERT INTO Orden (id_cliente, id_vendedor, estado) VALUES
(1, 1, 'pagado'),
(2, 2, 'pendiente');

INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 299.99),
(2, 2, 1, 25.00),
(2, 3, 1, 18.50);

INSERT INTO Direccion_Entrega (id_orden, calle, ciudad, estado, codigo_postal, pais, instrucciones_entrega) VALUES
(1, 'Calle Falsa 123', 'Buenos Aires', 'CABA', '1000', 'Argentina', 'Dejar en recepción'),
(2, 'Av. Libertador 456', 'Córdoba', 'Córdoba', '5000', 'Argentina', NULL);

INSERT INTO Resena (id_cliente, id_producto, calificacion, comentario) VALUES
(1, 1, 5, 'Excelente calidad'),
(2, 2, 4, 'Buena tela y diseño'),
(3, 3, 3, 'Ilumina bien pero es frágil');

INSERT INTO Compra_Proveedor (id_proveedor, estado, numero_factura) VALUES
(1, 'recibida', 'F001-1001'),
(2, 'pendiente', 'F001-1002');

INSERT INTO Detalle_Compra_Proveedor (id_compra, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 20, 220.00),
(2, 2, 60, 25.00);
