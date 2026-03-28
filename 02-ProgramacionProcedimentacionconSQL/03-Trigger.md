## Triggers(disparadores)

## ¿Que es un trigger

Es un bloque de codigo SQL que se ejucta automaticamente cuando ocurre un evento en una tabla

(*/ω＼*) Eventos

-INSERT
-UPDATE
-DELETE

(￣o￣) . z Z No se ejecutan manualmente, se activam solos


## 🐖![alt text](image.png) ¿Para que sirven
-Validacions
-Auditoria (guardar un historial de algo)
-Reglas del negocio
-Automatizacion

## ᓚᘏᗢ Tipos de Triggers en SQL SERVER

-AFTER TRIGGERS
Se ejecuta despues del evento

-INSTED OF
Remplaza la operacion original


## ✪ ω ✪ Sintaxis Basica

```sql
    CREATE TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
        --codigo
    END;
```

## Tablas especiales
| Tabla    | Contenido |
---------------------
| INSERTED | Nuevos datos     |
| DELETED  | Datos Anteriores |

