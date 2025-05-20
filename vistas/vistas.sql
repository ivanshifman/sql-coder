CREATE OR REPLACE VIEW vista_productos_detallados AS
SELECT 
  p.id_producto,
  p.nombre_producto,
  p.descripcion,
  p.precio,
  p.stock,
  c.nombre_categoria,
  pr.nombre AS proveedor_principal,
  p.activo,
  p.fecha_creacion
FROM Producto p
JOIN Categoria c ON p.id_categoria = c.id_categoria
JOIN Proveedor pr ON p.id_proveedor_principal = pr.id_proveedor;

CREATE OR REPLACE VIEW vista_ordenes_clientes_vendedores AS
SELECT 
  o.id_orden,
  o.fecha,
  COALESCE(SUM(d.cantidad * d.precio_unitario), 0) AS total,
  o.estado,
  c.nombre AS nombre_cliente,
  c.apellido AS apellido_cliente,
  v.nombre AS nombre_vendedor,
  v.apellido AS apellido_vendedor
FROM Orden o
JOIN Cliente c ON o.id_cliente = c.id_cliente
JOIN Vendedor v ON o.id_vendedor = v.id_vendedor
LEFT JOIN Detalle_Orden d ON o.id_orden = d.id_orden
GROUP BY o.id_orden;

CREATE OR REPLACE VIEW vista_detalle_ordenes AS
SELECT 
  do.id_detalle,
  do.id_orden,
  p.nombre_producto,
  do.cantidad,
  do.precio_unitario,
  (do.cantidad * do.precio_unitario) AS subtotal
FROM Detalle_Orden do
JOIN Producto p ON do.id_producto = p.id_producto;

CREATE OR REPLACE VIEW vista_resenas_productos AS
SELECT 
  r.id_resena,
  c.nombre AS nombre_cliente,
  c.apellido AS apellido_cliente,
  p.nombre_producto,
  r.calificacion,
  r.comentario,
  r.fecha
FROM Resena r
JOIN Cliente c ON r.id_cliente = c.id_cliente
JOIN Producto p ON r.id_producto = p.id_producto;

CREATE OR REPLACE VIEW vista_compras_proveedor AS
SELECT 
  cp.id_compra,
  cp.fecha,
  pr.nombre AS proveedor,
  p.nombre_producto,
  dcp.cantidad,
  dcp.precio_unitario,
  (dcp.cantidad * dcp.precio_unitario) AS subtotal,
  cp.estado
FROM Compra_Proveedor cp
JOIN Detalle_Compra_Proveedor dcp ON cp.id_compra = dcp.id_compra
JOIN Producto p ON dcp.id_producto = p.id_producto
JOIN Proveedor pr ON cp.id_proveedor = pr.id_proveedor;

CREATE OR REPLACE VIEW Vista_Totales_Orden AS
SELECT 
    o.id_orden,
    c.nombre AS cliente_nombre,
    c.apellido AS cliente_apellido,
    o.fecha,
    o.estado,
    SUM(d.cantidad * d.precio_unitario) AS total_calculado
FROM Orden o
JOIN Cliente c ON o.id_cliente = c.id_cliente
JOIN Detalle_Orden d ON o.id_orden = d.id_orden
GROUP BY o.id_orden, c.nombre, c.apellido, o.fecha, o.estado;