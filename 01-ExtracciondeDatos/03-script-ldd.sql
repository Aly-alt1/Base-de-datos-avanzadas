--Restricciones SQL
CREATE DATABASE restricciones;
GO

USE restricciones;
GO

CREATE TABLE clientes(
cliente_id int not null primary key, --primary key
nombre nvarchar(50)not null,
apellido_paterno nvarchar(20) not null,
apellido_materno nvarchar(20),
)
GO

INSERT INTO clientes
VALUES(1,'Panfilo Pancracio','Bad Bunny','Good Bunny');
GO

INSERT INTO clientes
VALUES(2,'Arcadia','Lorenza','Loca');
GO

INSERT INTO clientes
(apellido_paterno, nombre, cliente_id, apellido_materno)
VALUES('Aguilar', 'Toribio',3 ,'Cow');
GO

INSERT INTO clientes
VALUES(4, 'Monico', 'Buena vista','Del ojo'),
(5,'Ricarda', 'De la pared', 'Pintada'),
(6,'Angel Guadalupe','Guerrero', 'Hernández'),
(7, 'Jose Angel Ethan','Danielo', 'LinuxCen');
GO

SELECT * FROM clientes;
GO

CREATE TABLE clientes_2(
cliente_id int not null identity(1,1),
nombre nvarchar(50),
edad int not null,
CONSTRAINT pk_clientes_2
PRIMARY KEY(cliente_id)
);
GO







SELECT GETDATE()



SELECT *
FROM pedidos;
go

drop table clientes_2;
drop table pedidos;

--eliminacion DELETE NO ACTION	

--Eliminar a los hijos
DELETE pedidos
WHERE pedido_id= 9;
--Eliminar al padre
DELETE FROM clientes_2
Where cliente_id = 6;

--update no action
CREATE TABLE pedidos(
	pedido_id INT not null,
	fecha_pedido DATE not null,
	cliente_id INT,
	CONSTRAINT pk_pedidos
	PRIMARY KEY(pedido_id),
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KEY (cliente_id)
	REFERENCES clientes_2(cliente_id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

SELECT *
FROM clientes_2;

SELECT *
FROM pedidos;

INSERT INTO pedidos
Values (1,GETDATE(),1),
(2,'2026-01-19',1),
(3,'2026-04-06', 2),
(4,'2026-12-12', 2);

INSERT INTO clientes_2
VALUES  ('coca-cola', 100),
		('pecsi', 80),
		('chicharrones pork', 34);

SELECT *
FROM clientes_2;

UPDATE clientes_2
SET cliente_id =3
WHERE cliente_id =2;



--delete dlete y update set null

CREATE TABLE proveedor(
	proveedor_id int not null,
	nombre nvarchar(60) not null,
	tipo nchar(1) not null,
	limite_credito money not null,

	CONSTRAINT pk_proveedor
	PRIMARY KEY (proveedor_id),
	CONSTRAINT unique_nombre
	UNIQUE(nombre),
	CONSTRAINT chk_tipo
	CHECK (tipo in ('g','s','b')),
	CONSTRAINT chk_limite_credito
	CHECK(limite_credito between 0 and 30000)

);
go

CREATE TABLE productos(
	producto_id int not null identity(1,1),
	nombre nvarchar(50) not null,
	precio money not null,
	stock_maximo int not null,
	stock_minimo int not null,
	cantidad int not null,
	proveedor_id int,

	CONSTRAINT pk_productos
	PRIMARY KEY (producto_id),
	CONSTRAINT unique_nombre_pr
	UNIQUE (nombre),
	CONSTRAINT chk_stock_maximo
	CHECK(stock_maximo >=5 and stock_maximo <=400),--verifica que si cumpla, como un if
	CONSTRAINT chk_stock_minimo
	CHECK (stock_minimo >=1 and stock_minimo < stock_maximo),
	CONSTRAINT chk_cantidad_pr
	CHECK(cantidad>0),
	CONSTRAINT fk_productos_proveedor
	FOREIGN KEY (proveedor_id) 
	REFERENCES proveedor(proveedor_id)

	ON DELETE SET NULL
	ON UPDATE SET NULL
);
go
--fk va en N
--delete y update set default

--Delete y update cascade

--restriccion check
--restriccion unique
