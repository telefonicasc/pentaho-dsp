# Pentaho Dynamic Schema Processor
  
pentaho-dsp es una librería que extiende Pentaho y que permite reutilizar esquemas Mondrian para acceder a diferentes esquemas de una base de datos.  
  
La librería reemplaza al vuelo el esquema de la base de datos por el nombre de usuario de la sesión de Pentaho.  
  
# Build

Para generar el fichero `.jar` únicamente es necesario ejecutar los siguientes comandos Maven en el orden indicado:

 1. `mvn initialize`
 1. `mvn clean`
 2. `mvn compile`
 3. `mvn clean package`

# Directorios

 - **lib**: Almacena una copia de las librerias necesarias para el desarrollo que no se encuentran en el repositorio Maven.
 - **src**: Almacena el código java

# Releases

Este proyecto utiliza [Github Actions](https://github.com/features/actions) para construir automáticamente un archivo jar con cada release. Para liberar una nueva versión, es necesario:

- Modificar el número de versión en el atributo <Version> del fichero pom.xml:

```xml
<version>A.B.C</version>
```

- Hacer commit y push de los cambios
- Crear un tag git con el número de versión

```bash
git tag -a A.B.C -m "Versión A.B.C"
git push --tags
```

El número de versión y el nombre del tag deben coincidir, para que la accion automática se complete con éxito.
