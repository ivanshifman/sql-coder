CREATE DATABASE SHIFMAN_CODER;
USE SHIFMAN_CODER;

CREATE TABLE Cliente (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE Vendedor (
    id_vendedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE Categoria (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion_categoria VARCHAR(255)
);

CREATE TABLE Proveedor (
    id_proveedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Producto (
    id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT UNSIGNED NOT NULL,
    id_proveedor_principal INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_proveedor_principal) REFERENCES Proveedor(id_proveedor)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Producto_Proveedor (
    id_producto INT UNSIGNED NOT NULL,
    id_proveedor INT UNSIGNED NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    tiempo_entrega_dias INT,
    es_principal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_producto, id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Orden (
    id_orden INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_vendedor INT UNSIGNED NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'pagado', 'cancelado', 'enviado') DEFAULT 'pendiente',
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Detalle_Orden (
    id_detalle INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_orden INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES Orden(id_orden)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Direccion_Entrega (
    id_direccion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_orden INT UNSIGNED NOT NULL,
    calle VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    estado VARCHAR(50),
    codigo_postal VARCHAR(20),
    pais VARCHAR(50) NOT NULL,
    instrucciones_entrega TEXT,
    FOREIGN KEY (id_orden) REFERENCES Orden(id_orden)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Resena (
    id_resena INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    calificacion TINYINT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Compra_Proveedor (
    id_compra INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT UNSIGNED NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'recibida', 'cancelada') DEFAULT 'pendiente',
    numero_factura VARCHAR(50),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Detalle_Compra_Proveedor (
    id_detalle_compra INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_compra INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compra_Proveedor(id_compra)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);