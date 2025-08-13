# Teoría de la Computación - Autómatas y Lenguajes Formales

## 📋 Descripción del Proyecto

Implementación completa de **algoritmos fundamentales de teoría de la computación** en OCaml, abarcando desde estructuras de datos funcionales hasta autómatas finitos y gramáticas libres de contexto. El proyecto demuestra un dominio profundo de los fundamentos matemáticos de la informática y la teoría de lenguajes formales.

## 🚀 Características Principales

- **Estructuras de datos funcionales**: Conjuntos, árboles binarios y listas inmutables
- **Autómatas finitos**: Deterministas (AFD) y no deterministas (AFNE)
- **Gramáticas formales**: Análisis y manipulación de gramáticas libres de contexto
- **Algoritmos de parsing**: Implementación del algoritmo CYK para reconocimiento
- **Teoría de conjuntos**: Operaciones matemáticas completas
- **Recorrido de árboles**: Algoritmos in-orden, pre-orden, post-orden y anchura
- **Equivalencias**: Determinación de equivalencia entre autómatas

## 🏗️ Arquitectura del Proyecto

### Práctica 0 - Fundamentos Funcionales
- **Funciones de orden superior**: mapdoble, primero_que_cumple, existe
- **Recorrido de árboles**: Implementación de todos los algoritmos de recorrido
- **Teoría de conjuntos**: Operaciones completas (unión, intersección, diferencia)
- **Producto cartesiano**: Combinatoria de conjuntos

### Práctica 1 - Autómatas y Equivalencias
- **Detección de AFNE**: Algoritmo para identificar autómatas no deterministas
- **Equivalencia de autómatas**: Comparación formal de lenguajes aceptados
- **Manipulación de transiciones**: Análisis de epsilon-transiciones
- **Optimización de autómatas**: Técnicas de minimización

### Práctica 2 - Gramáticas y Parsing
- **Forma Normal de Chomsky (FNC)**: Verificación y transformación
- **Algoritmo CYK**: Parser bottom-up para gramáticas libres de contexto
- **Análisis sintáctico**: Reconocimiento de cadenas en lenguajes formales
- **Manipulación de gramáticas**: Operaciones sobre reglas de producción

## 🛠️ Stack Tecnológico

- **Lenguaje**: OCaml (Objective Caml)
- **Paradigma**: Programación funcional pura
- **Bibliotecas**: TALF (Teoría de Autómatas y Lenguajes Formales)
- **Módulos**: Conj, Auto, Ergo, Graf (conjuntos, autómatas, gramáticas, grafos)
- **Herramientas**: OCaml REPL, rlwrap para interactividad
- **Testing**: Casos de prueba exhaustivos para cada algoritmo
- **Documentación**: Explicaciones detalladas de cada implementación

## ⚙️ Configuración y Ejecución

### Requisitos Previos

- OCaml 4.08+ con OPAM
- Biblioteca TALF instalada
- rlwrap para mejor experiencia interactiva

### Estructura del Proyecto

```
teoria-computacion/
├── Practica0/                 # Fundamentos funcionales
│   ├── practica0.ml          # Implementaciones principales
│   ├── explicacionp0.txt     # Documentación detallada
│   └── practica-0-enunciado.pdf
├── Practica1/                 # Autómatas y equivalencias
│   ├── practica1.ml          # Algoritmos de autómatas
│   ├── equivalentes.ml       # Pruebas de equivalencia
│   └── explicacionP1.txt     # Análisis teórico
└── Practica2/                 # Gramáticas y parsing
    ├── practica2.ml          # Algoritmo CYK
    ├── algoritmo-cyk.pdf     # Documentación del algoritmo
    └── explicacionP2.txt     # Fundamentos teóricos
```

### Compilación y Ejecución

```bash
# Cargar en el intérprete OCaml
rlwrap ocaml

# Cargar biblioteca TALF
#load "talf.cma";;

# Importar módulos necesarios
open Conj;;
open Auto;;
open Ergo;;

# Ejecutar práctica específica
#use "Practica0/practica0.ml";;

# Probar funciones
mapdoble (function x -> x) (function x -> -x) [1;1;1;1;1];;
es_afne af_example;;
cyk "ab" gramatica_ejemplo;;
```

## 🔧 Implementaciones Destacadas

### Estructuras de Datos Funcionales Avanzadas
- **Conjuntos inmutables**: Implementación completa con operaciones matemáticas
- **Árboles binarios**: Recorridos in-orden, pre-orden, post-orden y por anchura
- **Listas funcionales**: Operaciones de orden superior y transformaciones
- **Producto cartesiano**: Combinatoria eficiente de conjuntos

### Autómatas Finitos y Reconocimiento
- **Detección de epsilon-transiciones**: Identificación de autómatas no deterministas
- **Equivalencia de autómatas**: Algoritmos para comparar lenguajes aceptados
- **Optimización de transiciones**: Análisis de estados alcanzables
- **Conversión AFD/AFNE**: Transformaciones entre tipos de autómatas

### Algoritmos de Parsing Avanzados
- **Algoritmo CYK**: Parser tabular para gramáticas en Forma Normal de Chomsky
- **Verificación FNC**: Análisis de gramáticas libres de contexto
- **Análisis sintáctico**: Reconocimiento eficiente de cadenas
- **Manipulación de gramáticas**: Transformaciones y optimizaciones

### Funciones de Orden Superior
- **mapdoble**: Aplicación alternada de funciones en listas
- **primero_que_cumple**: Búsqueda con predicados personalizados
- **existe**: Verificación existencial en estructuras de datos
- **filter/map avanzados**: Transformaciones funcionales complejas

## 📈 Competencias Técnicas Demostradas

- **Teoría de la computación**: Dominio profundo de autómatas y lenguajes formales
- **Programación funcional**: Implementación de algoritmos sin efectos secundarios
- **Matemáticas discretas**: Aplicación de teoría de conjuntos y lógica formal
- **Análisis algorítmico**: Evaluación de complejidad en algoritmos de parsing
- **Diseño de lenguajes**: Comprensión de gramáticas y reconocimiento sintáctico
- **Abstracción matemática**: Modelado formal de problemas computacionales
- **Optimización funcional**: Técnicas de eficiencia en programación declarativa

## 🎯 Algoritmos y Técnicas Implementadas

### Teoría de Autómatas
- **Determinización**: Conversión de AFNE a AFD mediante construcción de subconjuntos
- **Minimización**: Eliminación de estados redundantes en autómatas
- **Equivalencia**: Comparación de lenguajes mediante isomorfismo
- **Composición**: Operaciones de intersección y unión de autómatas

### Análisis Sintáctico
- **CYK (Cocke-Younger-Kasami)**: Parser tabular con complejidad O(n³)
- **Bottom-up parsing**: Construcción ascendente de árboles sintácticos
- **Forma Normal de Chomsky**: Verificación y transformación de gramáticas
- **Reconocimiento de lenguajes**: Decisión de pertenencia a lenguajes formales

### Algoritmos Funcionales
- **Recursión terminal**: Optimización de memoria en funciones recursivas
- **Pattern matching**: Análisis estructural de tipos de datos
- **Inmutabilidad**: Estructuras de datos sin efectos secundarios
- **Composición funcional**: Combinación elegante de transformaciones

## 🔬 Análisis Teórico y Complejidad

### Complejidad Algorítmica
- **CYK**: O(n³|G|) para gramáticas de tamaño |G| y cadenas de longitud n
- **Operaciones de conjuntos**: O(n log n) mediante ordenación eficiente
- **Recorrido de árboles**: O(n) para árboles de n nodos
- **Equivalencia de autómatas**: Análisis exponencial en casos generales

### Propiedades Formales
- **Corrección**: Demostración formal de algoritmos implementados
- **Completitud**: Cobertura exhaustiva de casos de prueba
- **Terminación**: Garantía de finalización en todos los algoritmos
- **Decidibilidad**: Análisis de problemas computables vs. no computables

## 🏆 Logros Académicos Alcanzados

Este proyecto demuestra:
- **Dominio teórico**: Comprensión profunda de fundamentos computacionales
- **Implementación rigurosa**: Traducción fiel de teoría a código funcional
- **Análisis matemático**: Capacidad de formalización y demostración
- **Resolución de problemas**: Aplicación creativa de técnicas formales
- **Programación avanzada**: Uso experto de paradigmas funcionales
- **Documentación técnica**: Explicaciones claras de conceptos complejos

---

## 🏛️ Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Teoría de la Computación (2021-2022)

*Proyecto desarrollado aplicando fundamentos matemáticos de la informática y técnicas avanzadas de programación funcional.*
