#Subqueris(subconsultas)

una subconsultaes una consulta anidada entro de una consulta que permite resolver 
problemas en varios niveles de informacion

Dependiendo de donde se coloque y retorne, cambia su comportamiento

**clasificacion**

1.Subconsultas escalaeres
2.Subconsultas con IN, ANY, ALL
3.Subconsultas en SELECT
4.Subconsultas correlacionadas
5.Subconsultas en FRO (tablas Derivadas)

##Escalares
Devuelven un unico valor, es por ello que se pueden utilizar con operadores =,<,>

Ejemplo:
SELECT *
FROM pedidos
WHERE total =(
    SELECT MAX(total)FROM pedidos
);


Orden de ejecucion
1.Se ejecuta la subconsulta
2.Devuelve 1500
3.La consulta prinipal ocupa ese valor

##Subconsultas de una columna (IN, ANY ALL)

Devuelve varios valores pero una sola columna

1.Clientes que han hecho pedidos

**Instruccion ANY**

>Compara un valor de una **lista**, la condicion se cumple si almenos uno se cumple

'''sql
valor > ANY (subconsulta) 
'''
Es como decir

"Moyor que al menos uno de los valores"