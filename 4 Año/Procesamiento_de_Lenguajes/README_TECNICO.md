# 🌐 Procesamiento de Lenguajes - Validador de Protocolos HTTP

## 📋 Descripción del Proyecto

El proyecto **Procesamiento de Lenguajes** constituye una implementación completa de un **analizador léxico y sintáctico especializado en la validación de protocolos HTTP**. El desarrollo se centra en la construcción desde cero de un compilador que procesa y valida la sintaxis de peticiones y respuestas HTTP, implementando las fases fundamentales de análisis léxico, sintáctico y semántico.

### Objetivos Principales
- **Construcción de compilador completo** con analizador léxico (Flex) y sintáctico (Bison)
- **Validación exhaustiva** de sintaxis HTTP según estándares RFC
- **Procesamiento robusto** de diferentes métodos, versiones y formatos HTTP
- **Sistema de testing automatizado** con casos de prueba comprehensivos

## 🛠️ Tecnologías y Herramientas

### Entorno de Desarrollo
- **Lenguajes:** C (núcleo), Flex (análisis léxico), Bison (análisis sintáctico)
- **Herramientas de Construcción:** Make, GCC, Bash scripting
- **Metodología:** Desarrollo de compiladores, teoría de autómatas, gramáticas formales

### Tecnologías de Compilación
- **Flex (Fast Lexical Analyzer):** Generación automática del analizador léxico
- **Bison (GNU Parser Generator):** Construcción del analizador sintáctico LALR(1)
- **Expresiones Regulares:** Definición precisa de tokens y patrones léxicos
- **Gramáticas Libres de Contexto:** Especificación formal de la sintaxis HTTP

## 🔧 Arquitectura del Sistema

### Pipeline de Compilación
1. **Análisis Léxico (Flex)**
   - Reconocimiento de tokens HTTP (métodos, versiones, URLs, headers)
   - Validación de formatos IPv4, IPv6, dominios y rutas
   - Procesamiento de tipos MIME y codificaciones

2. **Análisis Sintáctico (Bison)**
   - Parsing de estructura HTTP completa
   - Validación de secuencias request/response
   - Manejo de errores sintácticos con reportes detallados

3. **Validación Semántica**
   - Verificación de coherencia en headers HTTP
   - Validación de tipos de contenido y codificaciones
   - Control de integridad de protocolos

4. **Testing Automatizado**
   - Suite de 22 casos de prueba positivos
   - 7 casos de prueba negativos para validación de errores
   - Script automatizado de ejecución y validación

### Características Técnicas
- **Cobertura Protocolar:** HTTP/0.9, 1.0, 1.1, 2.0
- **Métodos Soportados:** GET, POST, PUT, DELETE, HEAD, OPTIONS, TRACE, CONNECT
- **Validación Avanzada:** IPv4/IPv6, dominios, rutas, headers complejos
- **Robustez:** Manejo exhaustivo de casos edge y errores sintácticos

## 📁 Estructura del Proyecto

```
PL_Final/
├── practica.l                         # Especificación léxica (Flex)
│                                      # - Definición de tokens HTTP
│                                      # - Expresiones regulares para URLs, IPs, headers
│                                      # - Reglas de reconocimiento de patrones
│
├── practica.y                         # Gramática sintáctica (Bison)
│                                      # - Reglas de producción HTTP
│                                      # - Manejo de errores sintácticos
│                                      # - Validación semántica integrada
│
├── Makefile                           # Sistema de construcción automatizada
│                                      # - Compilación con Flex/Bison
│                                      # - Targets de testing y limpieza
│
├── test.sh                            # Script de testing automatizado
│                                      # - Ejecución de casos de prueba
│                                      # - Validación de resultados esperados
│
├── test/
│   ├── pass/                          # Cases de prueba positivos (22 tests)
│   │   ├── testP00.txt - testP21.txt  # Validación de sintaxis correcta
│   │
│   └── fail/                          # Casos de prueba negativos (7 tests)
│       ├── testF00.txt - testF06.txt  # Validación de detección de errores
│
└── Documentacion_PL_Final.pdf        # Documentación técnica completa
```

### Componentes del Sistema

**Analizador Léxico (practica.l):**
- Reconocimiento de métodos HTTP, versiones y códigos de estado
- Validación de direcciones IPv4/IPv6 y nombres de dominio
- Procesamiento de headers complejos (Accept, Cache-Control, Content-Type)

**Analizador Sintáctico (practica.y):**
- Parsing de estructura completa de peticiones/respuestas HTTP
- Manejo de errores con mensajes descriptivos
- Validación de coherencia semántica en tiempo de compilación

## 💡 Características Destacadas

### Implementación Técnica
- **Compilador Completo:** Desarrollo desde especificaciones formales hasta código ejecutable
- **Validación Robusta:** Cobertura exhaustiva del protocolo HTTP en todas sus versiones
- **Testing Automatizado:** Suite comprehensiva de casos de prueba con validación automática
- **Arquitectura Modular:** Separación clara entre análisis léxico, sintáctico y semántico

### Aplicaciones Prácticas
- **Desarrollo Web:** Validación de comunicaciones HTTP en APIs y servicios web
- **Testing de Redes:** Verificación de conformidad protocolar en sistemas distribuidos
- **Herramientas DevOps:** Validación automática de logs y trazas HTTP
- **Educación:** Herramienta didáctica para enseñanza de protocolos de red

## 🎯 Valor Técnico y Profesional

Este proyecto demuestra competencias avanzadas en:
- **Teoría de Compiladores:** Dominio completo del pipeline de compilación (léxico → sintáctico → semántico)
- **Programación de Sistemas:** Implementación eficiente en C con herramientas profesionales
- **Protocolos de Red:** Conocimiento profundo de especificaciones HTTP y estándares RFC
- **Testing y Validación:** Desarrollo de suites de prueba automatizadas y robustas

### Relevancia Industrial
- **Desarrollo de Infraestructura Web:** Construcción de parsers y validadores protocolar
- **Herramientas de Testing:** Desarrollo de software de validación para sistemas distribuidos
- **Compiladores y DSLs:** Experiencia práctica en construcción de lenguajes específicos de dominio
- **Sistemas de Comunicación:** Desarrollo de componentes de validación para protocolos de red
