#Documentacion de comandos de contenedores de SGBD
##Contenedores sin volumen
**comando para creacion de contenedor con nombre de imagen**

'''shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1438:1433 --name servidorsqlserverDev \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
   
'''

**comando para creacion de contenedor con nombre de id**

'''shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1438:1433 --name servidorsqlserverDev \
   -d \
   e7ef
   
'''
**contenedores con volume Volumen**
'''shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1439:1433 --name servidorsqlserverDev2 -v volume-sqlserverdev:/var/opt/mysql/ \
   -d \
   e7ef
'''

docker run -e "ACCEPT_EULA=Y=

docker run --name server-mariadb -d  -p 3340:3306 -v volume-mariadb:/var/lib/mysql --env MARIADB_ROOT_PASSWORD=123456 mariadb:10.11.15-jammy