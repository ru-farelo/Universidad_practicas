## INSTRUCCIONES DE USO DEL PROYECTO
Este documento describe los pasos necesarios para compilar, desplegar, utilizar, y ejecutar los tests del proyecto utilizando la terminal.

## Inicializar el servicio
Para poder arrancar el entorno interactivo de Elixir y cargar la aplicación hay que utilizar el siguiente comando en la terminal:

>iex -S mix

Después, se procede con la inicialización de la aplicación con el comando:

>Easycourt.start(:normal, [])

Una vez inicializado el servicio, se debe seleccionar explícitamente el rol con el que se desea interactuar con el sistema: Cliente o Administrador.

1. Modo Cliente

Para interactuar como usuario cliente, se debe ejecutar el siguiente comando:

>Easycourt.start_cliente()


2. Modo Administrador

Para operar en el modo administrador, se debe ejecutar el siguiente comando:

>Easycourt.start_admin()

Ambos modos, Cliente y Administrador, generan menús interactivos en los cuales el usuario debe seleccionar una opción utilizando el teclado numérico. Cada opción corresponde a una funcionalidad específica dentro del sistema y ,en ciertas opciones, además de seleccionar con el teclado numérico, se solicitará introducir información adicional como texto, nombres de usuario o contraseñas, las cuales deben ser ingresadas y confirmadas según corresponda. Para navegar por el menú, basta con introducir el número correspondiente a la opción deseada y presionar Enter. En cualquier momento, es posible salir del menú y finalizar la ejecución de la aplicación introduciendo la tecla "q".

## Ejecución de tests

Para ejecutar las pruebas automatizadas de la aplicación, se utiliza el siguiente comando:

>mix test

Permite ejecutar todos los tests definidos en el proyecto de forma simultánea, asegurando que todas las funcionalidades sean validadas de manera eficiente.


## Limpiar el proyecto

Si en algún momento se requiere limpiar archivos compilados antes de reiniciar la aplicación, se debe ejecutar:

>mix clean














