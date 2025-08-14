# ⚡ Arquitectura de Software - Sistemas Distribuidos Escalables con Elixir/OTP

📌 Desarrollo de sistemas distribuidos tolerantes a fallos con **Elixir/OTP** y el modelo de actores, capaces de escalar a millones de procesos concurrentes con alta disponibilidad y actualización en caliente.  
Incluye desde ejercicios de concurrencia avanzada hasta una **plataforma distribuida completa** para reservas deportivas (EasyCourt), aplicando patrones arquitectónicos y supervisión jerárquica.

## 📋 Descripción del Proyecto
El proyecto **Arquitectura de Software** constituye una implementación completa de **sistemas distribuidos escalables** utilizando el ecosistema **Elixir/OTP**. El desarrollo abarca desde ejercicios fundamentales de programación concurrente hasta la construcción de una plataforma distribuida completa, demostrando competencias avanzadas en arquitecturas robustas, tolerancia a fallos y escalabilidad masiva.


### Objetivos Principales
- **Desarrollo de sistemas distribuidos** con arquitecturas tolerantes a fallos
- **Dominio del modelo Actor** y patrones avanzados de concurrencia
- **Implementación con Elixir/OTP** para sistemas críticos y escalables
- **Aplicación de tácticas arquitectónicas** para requisitos no funcionales

## 🛠️ Tecnologías y Herramientas

### Entorno de Desarrollo
- **Lenguaje Principal:** Elixir (programación funcional con Actor model)
- **Runtime:** Erlang/OTP (plataforma industrial probada para sistemas críticos)
- **Máquina Virtual:** BEAM VM (lightweight processes, hot code swapping)
- **Paradigma:** Functional programming, immutable data, message passing

### Abstracciones OTP
- **GenServer:** Encapsulación de estado mutable y sincronización
- **Supervisor:** Tolerancia a fallos con estrategias de recovery automático
- **Application:** Gestión de ciclo de vida y coordinación de servicios
- **Task:** Patrones async/await para concurrencia simple

## 🔧 Arquitectura del Sistema

### Pipeline de Desarrollo
1. **Ejercicios Fundamentales**
   - Algoritmos concurrentes (Criba de Eratóstenes distribuida)
   - Pool de trabajadores con balanceado de carga
   - Gestión de recursos compartidos con evolución iterativa

2. **Sistema Bancario (Micro-Bank)**
   - Transacciones atómicas con GenServer
   - Estado inmutable y consistencia de datos
   - API síncrona para operaciones críticas

3. **Plataforma Distribuida (EasyCourt)**
   - Sistema completo de reservas deportivas
   - Arquitectura multi-componente con supervisión
   - Service discovery y load balancing

4. **Tolerancia a Fallos Avanzada**
   - Supervision trees jerárquicos
   - Let it crash philosophy con aislamiento de errores
   - Recovery automático y estrategias de restart

### Características Técnicas
- **Escalabilidad:** Millones de procesos lightweight concurrentes
- **Performance:** Copy-on-write, garbage collection per-process
- **Disponibilidad:** Hot code swapping, distributed clustering
- **Seguridad:** Encriptación, autenticación y control de acceso

## 📁 Estructura del Proyecto

```
Arquitectura_Software/
├── ejercicios-de-elixir-as-farelo-santos-fraga-main/    # Ejercicios Fundamentales
│   ├── 10-eratostenes/                                  # Algoritmos Concurrentes
│   │   ├── secuencial/                                  # Baseline de rendimiento
│   │   │   └── lib/eratostenes.ex                       # Implementación clásica
│   │   └── concurrente/                                 # Pipeline de procesos
│   │       └── lib/primos.ex                           # Actor model con paso de mensajes
│   │
│   ├── 20-pool_de_trabajadores/                        # Concurrencia Gestionada
│   │   └── lib/                                        # Worker pool con load balancing
│   │       ├── servidor.ex                            # Gestión de workers disponibles
│   │       └── trabajador.ex                          # Procesamiento de tareas
│   │
│   ├── 30-gestor_recursos/                             # Evolución Iterativa
│   │   ├── gestor_recursos_it1/                        # Gestión básica de recursos
│   │   ├── gestor_recursos_it2/                        # Concurrencia avanzada
│   │   └── gestor_recursos_it3/                        # Alta disponibilidad
│   │
│   └── 40-micro-bank/                                  # Sistema Bancario Distribuido
│       └── micro_bank/
│           ├── lib/
│           │   ├── micro_bank_server.ex                # GenServer para transacciones
│           │   └── micro_bank_supervisor.ex            # Supervisión de procesos
│           └── test/                                   # Test suites comprehensivos
│
└── pr-ctica-grupal-as-farelosantosfragapenasarealpillo-main/  # Proyecto Integrador
    ├── easycourt/                                      # Plataforma de Reservas Distribuida
    │   ├── lib/
    │   │   ├── easycourt.ex                           # Punto de entrada principal
    │   │   ├── supervisor.ex                          # Árbol de supervisión jerárquico
    │   │   ├── directorio.ex                          # Service discovery y registry
    │   │   ├── servidor_cliente.ex                    # API para usuarios finales
    │   │   ├── servidor_admin.ex                      # Panel de administración
    │   │   ├── database/                              # Capa de persistencia distribuida
    │   │   │   ├── tabla_usuarios.ex                  # Gestión de usuarios
    │   │   │   └── tabla_pistas.ex                    # Inventario de pistas
    │   │   └── encriptado/                            # Módulo de seguridad
    │   │       └── encriptado.ex                      # Encriptación de datos sensibles
    │   ├── test/                                      # Tests unitarios e integración
    │   └── Doc/                                       # Documentación arquitectural
    │
    └── README.md                                      # Documentación del proyecto
```

### Componentes por Proyecto

**Ejercicios Fundamentales:** Progresión gradual desde algoritmos básicos hasta sistemas complejos con patterns de concurrencia avanzada.

**EasyCourt:** Plataforma completa con arquitectura distribuida, supervisión jerárquica y requisitos no funcionales de producción.

## 💡 Características Destacadas

### Implementación Técnica
- **Actor Model Mastery:** Dominio completo del modelo de actores con paso de mensajes
- **Fault Tolerance Nativa:** Let it crash philosophy con recovery automático
- **Escalabilidad Lineal:** Performance proporcional a recursos disponibles
- **Hot Code Swapping:** Actualizaciones sin downtime en sistemas críticos

### Patrones Arquitectónicos Avanzados
- **Supervision Trees:** Jerarquías de supervisión para fault tolerance
- **Worker Pool Pattern:** Gestión eficiente de recursos limitados
- **Circuit Breaker:** Prevención de fallos en cascada
- **Service Registry:** Descubrimiento y localización dinámica de servicios

### Aplicaciones Prácticas
- **Sistemas Críticos:** Plataformas que requieren 99.9% de uptime
- **Microservicios:** Arquitecturas distribuidas con comunicación asíncrona
- **Real-time Systems:** Procesamiento de alta frecuencia con baja latencia
- **IoT Platforms:** Gestión masiva de dispositivos concurrentes

## 🎯 Valor Técnico y Profesional

Este proyecto demuestra competencias avanzadas en:
- **Sistemas Distribuidos:** Arquitecturas resilientes y escalables para entornos de producción
- **Programación Concurrente:** Expertise en modelos de actores y programación sin locks
- **Elixir/OTP:** Dominio de la plataforma líder para sistemas distribuidos críticos
- **Arquitectura Empresarial:** Aplicación de tácticas para requisitos no funcionales complejos

### Relevancia Industrial
- **Platform Engineering:** Desarrollo de infraestructuras escalables y resilientes
- **Distributed Systems:** Arquitecturas para sistemas de alta disponibilidad
- **Microservices Architecture:** Diseño de servicios desacoplados y tolerantes a fallos
- **Real-time Systems:** Sistemas de procesamiento en tiempo real con garantías de performance
