#Comandos basicos


```SQL
CREATE DATABASE pruebadb;
GO

use pruebadb;
GO

CREATE TABLE tbl1(
	id int not null identity (1,1),
	nombre nvarchar(100) not null,
	constraint pk_tbl1
	primary key (id)
);
GO

INSERT INTO tbl1 
VALUES('Docker'),
	  ('Git'),
	  ('GITHUB'),
	  ('SQLSERVER');
GO

SELECT * FROM tbl1;

```