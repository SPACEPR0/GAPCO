# GAPCO - Manual de Instalación

Puesto que GAPCO es una aplicación web, esta ha sido desarrollado a través de un framework, en este caso _Ruby on Rails_. Por lo tanto para poder montar esta aplicación es necesario primero instalar las dependecias de este framework, así como el mismo. La instalación consta de los siguientes pasos:

1. Instalar RVM
2. Configurar la versión requerida de Ruby
3. Instalar Nodejs y Yarn
4. Configurar Rails y gems
5. Configurar GAPCO
6. Ejecutar el servidor



A través de este manual se instalarán las dependecias:

- RVM (manejador de versiones de ruby)
- ruby v2.6.4
- nodejs v10.17.0
- gem v3.0.6
- rails v6.0.0
- yarn v1.19.2
- sqlite3 v3.22.0

__**NOTA:__ Debido a que el propósito de esta aplicación web es que se monte en un servidor con un sistema operativo de alguna distrubución de Linux, los siguientes pasos están tomados en cuenta para llevar a cabo una instalación en dicha distribución. Si se desea instalar esta aplicación en OS X o Windows bastaría con instalar las dependencias listadas anteriormente de la forma que se requiera en su sistema operativo.

## Paso 1: Instalar RVM

Para poder instalar el manejador de versiones de ruby, es necesario primero instalar _curl_, que es una utilidad de línea de comandos para realizar solicitudes HTTP y obtener datos de servidores web:

```
sudo apt install curl
```
Agrega la clave de rvm al servidor:

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

Instala la versión estable más reciente de rvm ejecutando:

```
curl -sSL https://get.rvm.io | bash -s stable --ruby
```
Después será necesario correr el comando, reemplazando _usuario_ por el nombre del usuario administrador de su servidor:

```
source /home/usuario/.rvm/scripts/rvm
```
Ahora, para asegurarse de que la instalación se ha realizado correctamente puede correr:

```
rvm version
```
deberá ver en la consola el número de la versión instalada de rvm.

## Paso 2: Configurar la versión requerida de Ruby

Primero deberá ingregar el comando:

```
rvm get stable --autolibs=enable
```
Ahora, instale la versión requerida para el sistema con el siguiente comando:

```
rvm install ruby-2.6.4
```
Una vez completada la instalación, configure ruby 2.6.4 como versión predeterminada de ruby:

```
rvm --default use ruby-2.6.4
```

Verifique que se halla establecido ruby 2.6.4 como default en su servidor:

```
ruby -v
```
## Paso 3: Instalar Nodejs y yarn

Agregue el repositorio de Nodejs, nodeource al sistema:
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
```
Instale Nodejs y los demás dependencias descritas a continuación, con el comando:
```
sudo apt install -y nodejs
```
```
sudo apt install gcc g++ make
```
Ahora, agregue el repositorio de yarn al sistema:

```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
```
```
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```
Instale yarn con el comando:
```
sudo apt update

sudo apt install yarn
```
Verifique que se haya realizado exitosamente su instalación:
```
yarn
```

## Paso 4: Configurar Rails y gems
Puesto que rvm ya instaló previamente _gem_, solo es necesario actualizar:
```
gem update --system
```
Instale rails con la versión 6.0.0:
```
gem install rails -v 6.0.0
```

Verifique que se haya instalado correctamente:

```
rails -v
```
Ahora, instale postresql para poder utilizar su manejador de base de datos en la aplicación:
```
sudo apt install postgresql postgresql-contrib libpq-dev -y
```
Instale _pg_, el manejador el base de datos:
```
gem install pg -v '1.1.4' --source 'https://rubygems.org/
```

## Paso 5: Configurar GAPCO

Primero debe descargar o clonar este repositorio hacia su servidor. Ya sea a través de la instrucción `Descargar zip` de la página de github: https://github.com/FernandaDguez/GAPCO o a través de la instrucción:

```
git clone https://github.com/FernandaDguez/GAPCO.git
```
Cambie la ruta de directorio de su terminal hacia la ruta de la carpeta _GAPCO_

Ahora dentro de la carpeta de la aplicación es necesario que agregue el siguiente archivo en la carpeta _config_

```
cd ./config/
nano application.yml
```
Ahora dentro del editor de texto pegue la siguiente información en el archivo y guárdelo:

```
gmail_username: verificacionccuson@gmail.com
gmail_password: nbteaioidjvqgixx
```
__**NOTA:__ Por seguridad es altamente recomendado que utilice otra cuenta de correo electrónico y llene esos campos con su información correspondiente.

Ahora vuelva a la carpeta de _GAPCO_ y ejecute:

```
bundle install
```
Está instrucción instalará todas las _gems_ que requiere el sistema GAPCO para funcionar.

Ahora, es importante ejecutar las migraciones para su base de datos:

```
rake db:migrate
```

## Paso 6: Ejecutar el servidor
Finalmente, puede poner en marcha el servidor ejecutando:

```
rails s
```
__Importante:__ El usuario administrador (con el rol de coordinador) por default en la base de datos es:
```
admin@test.com
spacepro
```
Es necesario que cuando entre al sistema por primera vez, cambie tanto como el correo como la contraseña.
