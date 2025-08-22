# Diseño de Lenguajes de Programación - Intérprete Lambda Cálculo Extendido

## Descripción del Proyecto

El proyecto **Diseño de Lenguajes de Programación** constituye una implementación completa de un **intérprete funcional para lambda cálculo extendido** con sistemas de tipos avanzados. El desarrollo abarca desde los fundamentos teóricos del lambda cálculo hasta la implementación práctica de un intérprete robusto con extensiones modernas como subtipado estructural, tipos de datos algebraicos y recursión tipada.

### Objetivos Principales
- **Construcción de intérprete completo** con análisis léxico, sintáctico y semántico
- **Implementación de sistema de tipos avanzado** con subtipado estructural
- **Desarrollo de extensiones modernas** (registros, variantes, listas, recursión)
- **Aplicación práctica** de teoría de lenguajes de programación y compiladores

##  Tecnologías y Herramientas

### Entorno de Desarrollo
- **Lenguaje Principal:** OCaml (programación funcional con type safety)
- **Herramientas de Compilación:** Menhir (parser LR), OCamlLex (análisis léxico)
- **Sistema de Construcción:** Make, compilación incremental
- **Paradigma:** Functional programming, pattern matching, immutable data

### Metodologías Implementadas
- **Teoría de Compiladores:** Pipeline completo desde tokens hasta evaluación
- **Sistemas de Tipos:** Type checking, subtipado estructural, inferencia
- **Semántica Operacional:** Call-by-value, substitución capture-avoiding
- **Algebraic Data Types:** Modelado formal de sintaxis y tipos

## Arquitectura del Sistema

### Pipeline de Interpretación
1. **Análisis Léxico (OCamlLex)**
   - Tokenización de sintaxis funcional (lambda, let, case, tipos)
   - Reconocimiento de literales (números, strings, booleanos)
   - Manejo de identificadores y palabras clave contextuales

2. **Análisis Sintáctico (Menhir)**
   - Gramática LR(1) para lambda cálculo extendido
   - Construcción de AST con precedencia y asociatividad
   - Soporte para sintaxis de registros, variantes y listas

3. **Sistema de Tipos**
   - Type checking con subtipado estructural
   - Validación de coherencia en registros y funciones
   - Manejo de recursión con punto fijo tipado

4. **Evaluador Operacional**
   - Estrategia call-by-value con valores canónicos
   - Substitución segura con alpha-conversion
   - Pattern matching para destrucción de tipos complejos

### Características Técnicas
- **Type Safety:** Garantías de progress y preservation
- **Subtipado Estructural:** Width/depth subtyping en registros y funciones
- **Recursión General:** Combinador de punto fijo con restricciones de tipo
- **Extensibilidad:** Arquitectura modular para nuevas construcciones

## 📁 Estructura del Proyecto

```
DLP_OFICIAL/
├── lambda.mli                         # Interface principal del intérprete
│                                      # - Definiciones de tipos y términos
│                                      # - Especificación de funciones públicas
│
├── lambda.ml                          # Implementación del intérprete completo
│   ├── Type System                    # Sistema de tipos + subtipado
│   ├── Type Checker                   # Algoritmo de verificación de tipos
│   ├── Evaluator                      # Semántica operacional call-by-value
│   ├── Pretty Printer                # Formateo de salida estructurado
│   └── Context Management             # Entornos de variables y tipos
│
├── parser.mly                         # Gramática Menhir (análisis sintáctico)
│                                      # - Reglas de producción para lambda cálculo
│                                      # - Precedencia y asociatividad de operadores
│                                      # - Construcción de AST tipado
│
├── lexer.mll                          # Especificación léxica (OCamlLex)
│                                      # - Expresiones regulares para tokens
│                                      # - Manejo de literales y identificadores
│                                      # - Palabras clave contextuales
│
├── main.ml                            # REPL interactivo
│                                      # - Read-Eval-Print Loop
│                                      # - Manejo de errores y excepciones
│                                      # - Interface de usuario del intérprete
│
├── ejemplos.txt                       # Suite de casos de prueba
│                                      # - Ejemplos de todas las extensiones
│                                      # - Casos de subtipado y recursión
│                                      # - Validación de funcionalidades
│
├── Makefile                           # Sistema de construcción automatizada
└── Documentación_DLP_ING.pdf         # Especificación técnica formal
```

### Componentes del Sistema

**Sistema de Tipos Extensible:** Soporte para tipos básicos, funciones, tuplas, registros, variantes y listas con subtipado estructural completo.

**Pipeline de Compilación:** Integración completa Flex → Bison → Type Checker → Evaluador con manejo robusto de errores.

## Características Destacadas

### Implementación Técnica
- **Lambda Cálculo Puro:** Fundamentos teóricos sólidos con extensiones prácticas
- **Subtipado Estructural:** Width y depth subtyping para registros y funciones
- **Recursión Tipada:** Punto fijo con garantías de type safety
- **Pattern Matching:** Destrucción segura de tipos de datos algebraicos

### Extensiones Avanzadas
- **Registros Estructurales:** Tipos producto con proyección por nombre y subtipado
- **Variantes Marcadas:** Tipos suma con pattern matching exhaustivo
- **Listas Homogéneas:** Estructuras recursivas con operaciones funcionales
- **Let Bindings:** Definiciones locales con scoping léxico

### Aplicaciones Prácticas
- **Desarrollo de Compiladores:** Fundamentos para construcción de lenguajes DSL
- **Investigación en PL:** Base para experimentación con sistemas de tipos
- **Herramientas de Análisis:** Verificación formal de programas funcionales
- **Educación:** Plataforma didáctica para enseñanza de teoría de lenguajes

## Valor Técnico y Profesional

Este proyecto demuestra competencias avanzadas en:
- **Teoría de Lenguajes:** Dominio completo de lambda cálculo y sistemas de tipos formales
- **Compiladores:** Implementación práctica de pipeline completo de interpretación
- **Programación Funcional:** Expertise en OCaml, pattern matching y tipos algebraicos
- **Investigación Aplicada:** Capacidad para implementar papers y teoría formal

### Relevancia Industrial
- **Language Design:** Desarrollo de DSLs y herramientas de programación especializadas
- **Compiler Engineering:** Implementación de frontends y optimizaciones avanzadas
- **Type Systems Research:** Investigación en verificación formal y análisis estático
- **Programming Tools:** Desarrollo de IDEs, linters y herramientas de análisis de código
