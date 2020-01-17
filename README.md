# Pentaho Dynamic Schema Processor
  
pentaho-dsp es una librería que extiende Pentaho y que permite reutilizar esquemas Mondrian para acceder a diferentes esquemas de una base de datos.  
  
La librería reemplaza al vuelo el esquema de la base de datos por el nombre de usuario de la sesión de Pentaho.  

Para generar el fichero `.jar` únicamente es necesario ejecutar los siguientes comandos Maven en el orden indicado:

 1. `mvn clean`
 2. `mvn compile`
 3. `mvn clean package`

# Directorios

 - **lib**: Almacena una copia de las librerias necesarias para el desarrollo que no se encuentran en el repositorio Maven. Para facilitar la compilacion, estan librerias se han almacenado en forma de un **repositorio local maven**, con los comandos que se muestran a continuacion:

(**NOTA**: Esto se documenta solo como referencia, no es necesario volver a hacerlo a menos que se cambien las versiones de las librerias)

```bash
mvn install:install-file -DlocalRepositoryPath=./lib -Dfile=mondrian-3.0.jar -DgroupId=mondrian -DartifactId=mondrian -Dversion=3.0 -Dpackaging=jar -DgeneratePom=true
mvn install:install-file -DlocalRepositoryPath=./lib -Dfile=pentaho-platform-api-8.2.0.1-427.jar -DgroupId=pentaho -DartifactId=pentaho-platform-api -Dversion=8.2.0.1-427 -Dpackaging=jar -DgeneratePom=true
mvn install:install-file -DlocalRepositoryPath=./lib -Dfile=pentaho-platform-core-8.2.0.0-342.jar -DgroupId=pentaho -DartifactId=pentaho-platform-core -Dversion=8.2.0.0-342 -Dpackaging=jar -DgeneratePom=true
```

 - **src**: Almacena el código java
