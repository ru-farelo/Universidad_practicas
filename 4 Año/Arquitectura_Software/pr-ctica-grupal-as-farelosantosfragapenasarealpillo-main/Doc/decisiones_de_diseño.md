## ADR-01: Incorporar el encriptado de las contraseñas para mejorar la seguridad de los usuarios

**Contexto:** Actualmente, el sistema no cuenta con un mecanismo adecuado para proteger las contraseñas de los usuarios, lo que podría exponer datos sensibles en caso de una vulnerabilidad de seguridad. Esto es crítico dado el requisito no funcional de seguridad. El equipo ha identificado la necesidad de incorporar un mecanismo de encriptado robusto para cumplir con los estándares de protección de datos y evitar riesgos como accesos no autorizados o el robo de información sensible.

**Decisión:** Implementar un esquema de encriptado utilizando un algoritmo de cifrado por bloques con padding. Las contraseñas serán encriptadas antes de almacenarse en la base de datos, y se utilizarán claves y vectores de inicialización (IV) generados y almacenados de manera segura. El texto encriptado se codificará en Base64 para facilitar su almacenamiento y transmisión.

**Ventajas:**

Aumenta significativamente la seguridad de los usuarios al proteger sus contraseñas contra accesos no autorizados.

Mejora la confianza de los usuarios en la aplicación al cumplir con mejores prácticas de seguridad.

Facilita el cumplimiento de normativas de protección de datos, como el GDPR o leyes locales de privacidad.

**Desventajas:**

Incrementa la complejidad del sistema al añadir un nuevo nivel de cifrado y requisitos adicionales para el manejo seguro de claves y vectores de inicialización.

Podría requerir más recursos computacionales para el proceso de cifrado y descifrado, aunque esto es manejable dado el enfoque específico en contraseñas.

La implementación del encriptado garantiza que incluso en el caso de un ataque o brecha de seguridad, las contraseñas no estarán expuestas en texto plano, reduciendo el impacto potencial del incidente.

## ADR-02 - Utilización de dos tipos de usuarios (Cliente y Admin)

**Contexto:**
Durante el diseño del sistema, se identificó la necesidad de implementar dos tipos de roles principales de usuario: Cliente y Admin. Esta distinción surge para garantizar que las funcionalidades críticas y sensibles (como la eliminación de usuarios o la visualización de todas las reservas activas) estén restringidas a usuarios con mayores privilegios, mientras que los clientes mantengan acceso limitado únicamente a sus propios datos (por ejemplo, sus reservas). Esta segregación de roles busca mejorar la organización del sistema, la seguridad de los datos y la experiencia de usuario al proporcionar accesos diferenciados según sus responsabilidades.

**Decisión:**
Se decidió implementar dos tipos de usuarios con las siguientes capacidades:

    Cliente:
        Visualizar y gestionar exclusivamente sus propias reservas.
        Acceso limitado únicamente a funcionalidades relacionadas con su interacción directa en la aplicación.

    Admin:
        Capacidad de eliminar usuarios de la base de datos (en casos necesarios, como usuarios inactivos o malintencionados).
        Visualización de todas las reservas activas del sistema, para facilitar tareas de monitoreo y gestión.

Esta separación se implementará a través de un sistema de roles en la base de datos, donde cada usuario tiene asociado un rol específico que determina sus permisos.

**Consecuencias:**

    **Ventajas:**
        Mejora la seguridad del sistema al restringir acciones críticas (como eliminar usuarios) a roles específicos.
        Facilita el mantenimiento y la gestión del sistema, ya que los administradores pueden realizar tareas globales sin afectar directamente la experiencia de los clientes.
        Incrementa la claridad en la interacción de los usuarios con el sistema, al ofrecerles solo las funcionalidades relevantes según su rol.

    **Desventajas:**
        Incremento en la complejidad de la implementación inicial, ya que será necesario desarrollar y probar el sistema de gestión de roles y permisos.
        Mayor carga administrativa para los desarrolladores y administradores en caso de gestionar roles adicionales en el futuro.

**Conclusión:**
La implementación de dos tipos de usuarios (Cliente y Admin) establece un marco robusto y escalable que prioriza la seguridad y la organización del sistema. Aunque requiere un esfuerzo adicional en el desarrollo inicial, este diseño ofrece una clara separación de responsabilidades que favorece tanto la usabilidad como el mantenimiento a largo plazo.

## ADR-03 - Diferencia en las bases de datos

**Contexto:**El diseño inicial del sistema requería almacenar información sobre los usuarios y las reservas de las pistas en una única base de datos. Sin embargo, se detectaron riesgos y limitaciones al mantener un esquema unificado, especialmente en términos de escalabilidad, organización y rendimiento. Para mejorar la claridad y reducir el acoplamiento entre las funcionalidades del sistema, se ha considerado necesario dividir los datos en dos espacios diferenciados.

**Decisión:**Se optó por separar la información de la base de datos en dos espacios independientes:

Espacio para usuarios:

Este espacio almacenará toda la información relacionada con los usuarios, como credenciales (contraseñas, nombres de usuario) y datos personales necesarios para la autenticación y autorización.

Implementará mecanismos de seguridad, como el encriptado de contraseñas.

Espacio para pistas:

Este espacio contendrá información relacionada con las reservas, como qué usuario tiene asignada una pista en un momento determinado, horarios y detalles de la disponibilidad.

Está diseñado para manejar un mayor volumen de transacciones y garantizar la integridad de los datos sobre las reservas.

Esta separación no implica el uso de sistemas de bases de datos distintos, sino la creación de dos esquemas o espacios de datos lógicos dentro del mismo sistema de gestión de bases de datos.

**Consecuencias:**

**Ventajas:**

Mejora la escalabilidad, ya que ambos espacios pueden optimizarse independientemente según sus necesidades específicas de rendimiento.

Facilita el mantenimiento y la comprensión del esquema de datos al separar claramente la información relacionada con usuarios y pistas.

Incrementa la seguridad al poder aplicar reglas de acceso diferenciadas a cada espacio.

**Desventajas:**

Aumenta la complejidad inicial del diseño de la base de datos, así como la implementación y configuración del sistema.

Puede requerir la implementación de mecanismos de integración entre los espacios de datos para sincronizar información relevante.

**Conclusión:**Dividir la información en dos espacios diferenciados dentro de la base de datos es una decisión que favorece la organización, el rendimiento y la seguridad del sistema. Aunque requiere un mayor esfuerzo inicial de implementación, proporciona una estructura más robusta y preparada para futuras ampliaciones.

## ADR-04 - Utilización de una arquitectura cliente-servidor distribuido

**Contexto:** El sistema diseñado para la reserva de pistas de pádel requiere manejar múltiples interacciones simultáneas, garantizar disponibilidad y escalabilidad, y proteger la información de los usuarios. Dado este contexto, la arquitectura cliente-servidor distribuida resulta una solución adecuada. Esta arquitectura separa las responsabilidades entre los clientes (usuarios finales) y los servidores (encargados de procesar solicitudes y manejar datos). Además, permite la distribución de la carga de trabajo entre múltiples servidores, mejorando el rendimiento y la resiliencia del sistema.

**Decisión:**
Implementar una arquitectura cliente-servidor distribuida, en la cual:

**Clientes:**

Envían solicitudes relacionadas con la autenticación, la gestión de reservas y la visualización de datos.

Funcionan como interfaces ligeras que interactúan con los servidores a través de una API.

Servidores distribuidos:

Gestionan diferentes funciones del sistema (por ejemplo, autenticación, reservas, manejo de datos de usuarios).

Utilizan técnicas de balanceo de carga para distribuir las solicitudes y evitar sobrecargas.

Incluyen redundancia para garantizar disponibilidad incluso en caso de fallos.

**Consecuencias:**

**Ventajas:**

Escalabilidad: Los servidores pueden escalar horizontalmente al añadir más nodos para manejar un mayor número de solicitudes o usuarios.

Disponibilidad: La redundancia y la distribución minimizan el impacto de fallos en un único servidor.

Rendimiento: El balanceo de carga permite distribuir eficientemente las tareas, reduciendo los tiempos de respuesta.

Flexibilidad: Es más sencillo realizar actualizaciones o implementar nuevas funcionalidades sin interrumpir el servicio completo.

**Desventajas:**

Complejidad: La configuración y gestión de una arquitectura distribuida es más compleja que en sistemas centralizados.

Costo inicial: Requiere infraestructura adicional para implementar servidores redundantes y mecanismos de balanceo de carga.

Sincronización: Es necesario implementar mecanismos para garantizar la consistencia de los datos entre los servidores distribuidos.

Conclusión:La arquitectura cliente-servidor distribuida es la mejor opción para satisfacer los requisitos funcionales y no funcionales del sistema de reservas de pistas de pádel. Aunque implica una mayor complejidad inicial, sus ventajas en términos de escalabilidad, rendimiento y disponibilidad justifican plenamente su adopción.



