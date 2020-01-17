# Pentaho Dynamic Schema Processor
  
pentaho-dsp es una librería que extiende Pentaho y que permite reutilizar esquemas Mondrian para acceder a diferentes esquemas de una base de datos.  
  
La librería reemplaza al vuelo el esquema de la base de datos por el nombre de usuario de la sesión de Pentaho.  

# Local repo

Algunas de las dependencias requeridas no estan publicadas en el repo de Maven. Para poder utilizarlas, se ha construido un repo local en el directorio **lib**, como se indica a continuacion.

**NOTA**: Esto se documenta solo como referencia, no es necesario volver a hacerlo (a menos que se cambien las versiones de las librerias)

## Mondrian 3.0

```bash
mvn install:install-file -DlocalRepositoryPath=./lib -Dfile=mondrian-3.0.jar -DgroupId=mondrian -DartifactId=mondrian -Dversion=3.0 -Dpackaging=jar -DgeneratePom=true
mvn install:install-file -DlocalRepositoryPath=./lib -Dfile=pentaho-platform-api-8.2.0.1-427.jar -DgroupId=pentaho -DartifactId=pentaho-platform-api -Dversion=8.2.0.1-427 -Dpackaging=jar -DgeneratePom=true
mvn install:install-file -DlocalRepositoryPath=./lib -Dfile=pentaho-platform-core-8.2.0.0-342.jar -DgroupId=pentaho -DartifactId=pentaho-platform-core -Dversion=8.2.0.0-342 -Dpackaging=jar -DgeneratePom=true
```

# Build

Para generar el fichero `.jar` únicamente es necesario ejecutar los siguientes comandos Maven en el orden indicado:
  
 1. `mvn clean`  
 2. `mvn compile`  
 3. `mvn clean package`

# Directorios

 - **lib**: Almacena una copia de las librerias necesarias para el desarrollo que no se encuentran en el repositorio Maven.
 - **src**: Almacena el cógido java
