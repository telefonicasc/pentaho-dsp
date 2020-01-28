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
 - **hooks**: Almacena los scripts de configuración para la imagen Docker

# Releases

Este proyecto utiliza [Github Actions](https://github.com/features/actions) para construir automáticamente un archivo jar con cada release. Para liberar una nueva versión, es necesario:

- Modificar el número de versión en el atributo `<version>` del fichero pom.xml:

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

# Docker

Adicionalmente, a partir de este repositorio se puede construir una imagen base conteniendo openjdk 8 y todas las dependencias necesarias para ejecutar Pentaho 8 CE, incluyendo este código.

Esta imagen incluye dos personalizaciones sobre la imagen base, añadidas en forma de scripts de configuración en la carpeta **hooks**:

- **hooks/pentaho-dsp.sh**: Garantiza que la versión de pentaho-dsp.jar instalada es compatible con las librerías incluidas en el volumen de Pentaho.
- **hooks/url-auth.sh**: Permite incluir widgets de Pentaho en iframes.

La imagen puede construirse con:

```bash
docker build --rm -t pentaho-env:latest .
```

Una vez construida, el siguiente comando muestra las instrucciones para utilizar dicha imagen:

```bash
docker run --rm pentaho-env:latest cat /opt/usage.txt
```
