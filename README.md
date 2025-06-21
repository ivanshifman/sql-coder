# 🛍️ Sistema de Gestión de Ventas y Compras - Proyecto Final SQL

Este proyecto es el resultado del trabajo final para el curso de SQL en Coderhouse. Consiste en el diseño e implementación de una **base de datos relacional completa** orientada a un comercio minorista o mayorista, con gestión integral de **clientes, productos, vendedores, compras, ventas, stock, reseñas** y mucho más.

## 📌 Temática

Sistema de gestión de ventas y compras para negocios físicos u online que requieran:

- Control de stock en tiempo real
- Manejo de clientes y proveedores
- Registro de ventas y compras
- Reportes dinámicos
- Mejora de la experiencia del cliente

## 🎯 Objetivos

- Registrar y organizar información crítica: clientes, vendedores, productos, proveedores.
- Automatizar procesos como actualización de stock tras ventas y compras.
- Facilitar la toma de decisiones mediante reportes.
- Garantizar la integridad y trazabilidad de los datos.

## 🧱 Estructura del Proyecto

El sistema cuenta con:

### 🗃️ Tablas principales

- `Cliente`
- `Vendedor`
- `Producto`
- `Proveedor`
- `Categoria`
- `Orden`
- `Detalle_Orden`
- `Direccion_Entrega`
- `Resena`
- `Compra_Proveedor`
- `Detalle_Compra_Proveedor`
- `Producto_Proveedor` (relación N:M)

### 🔍 Vistas SQL

- `vista_productos_detallados`
- `vista_ordenes_clientes_vendedores`
- `vista_detalle_ordenes`
- `vista_resenas_productos`
- `vista_compras_proveedor`
- `vista_totales_orden`

### ⚙️ Funciones SQL

- `fn_calcular_total_orden`
- `fn_stock_disponible`
- `fn_promedio_calificacion_producto`
- `fn_total_compras_proveedor`
- `fn_cantidad_productos_por_categoria`
- `fn_obtener_nombre_cliente`
- `fn_cantidad_ordenes_cliente`
- `fn_proveedor_principal_producto`
- `fn_tiempo_entrega_promedio_producto`

### 🛠️ Procedimientos Almacenados

- `sp_insertar_orden`
- `sp_actualizar_stock_producto`
- `sp_registrar_compra_proveedor`
- `sp_insertar_resena`
- `sp_actualizar_estado_orden`
- `sp_eliminar_producto`
- `sp_asociar_producto_a_proveedor`
- `sp_aplicar_descuento_por_categoria`
- `sp_obtener_estado_orden_descripcion`
- `sp_registrar_orden_con_detalle`
- `sp_obtener_total_compras_cliente`
- `sp_actualizar_estado_ordenes_antiguas`

### 🚦 Triggers

- `trg_actualizar_stock_despues_de_compra`
- `trg_desactivar_producto_sin_stock`
- `trg_verificar_calificacion_resena`
- `trg_guardar_fecha_modificacion_producto`
- `trg_evitar_eliminacion_proveedor_principal`
- `trg_verificar_email_duplicado_cliente_vendedor`
- `trg_verificar_email_duplicado_vendedor_cliente`
- `trg_evitar_eliminacion_cliente_con_ordenes`
- `trg_validar_stock_detalle_orden`
- `trg_descuento_stock_detalle_orden`
- `trg_actualizar_stock_orden_pagada_update`
- `trg_revertir_stock_orden_cancelada`

## 🛠️ Herramientas Utilizadas

- **MySQL Workbench**: diseño y pruebas de la base de datos.
- **draw.io**: para el modelo entidad-relación.
- **GitHub**: control de versiones y respaldo de código.
- **Power BI**: visualización de KPIs como stock, ventas y calificaciones.

## 📊 Ejemplos de Reportes Power BI

- Calificación promedio por producto.
- Stock actual por producto.
- Órdenes totales filtradas por estado y vendedor.

## 🚀 Proyección Futura

- Integración con API REST o aplicación web.
- Reportes automatizados con agendamiento.
- Control de accesos y roles por usuarios.
- Escalabilidad para nuevos procesos o módulos.

📬 Para consultas, sugerencias o mejoras, no dudes en abrir un issue o hacer un pull request.
