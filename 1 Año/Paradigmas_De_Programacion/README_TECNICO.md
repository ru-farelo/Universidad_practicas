# Paradigmas de Programación - Programación Funcional en OCaml

## 📋 Descripción del Proyecto

Conjunto de implementaciones avanzadas en **programación funcional** utilizando OCaml, cubriendo desde estructuras de datos fundamentales hasta algoritmos complejos de inteligencia artificial. El proyecto demuestra el dominio de múltiples paradigmas de programación y técnicas algorítmicas avanzadas.

## 🚀 Características Principales

- **Programación funcional pura**: Implementaciones sin efectos secundarios
- **Algoritmos de búsqueda**: Backtracking y búsqueda con poda
- **Estructuras de datos**: Árboles binarios, listas personalizadas y grafos
- **Lógica proposicional**: Evaluadores de expresiones booleanas
- **Algoritmos de ordenación**: Implementaciones optimizadas (QuickSort, MergeSort)
- **Análisis de complejidad**: Comparación de eficiencia algoritmica
- **Recursión avanzada**: Funciones recursivas terminales y no terminales

## 🏗️ Arquitectura del Proyecto

### Módulos Principales

- **`arboles.ml`**: Implementación de árboles binarios con operaciones de transformación
- **`logic.ml`**: Sistema de evaluación de lógica proposicional
- **`qsort.ml`**: Algoritmos de ordenación con análisis de rendimiento
- **`bin_tree.ml`**: Estructuras de datos arbóreas avanzadas
- **`breadth_first.ml`**: Algoritmos de búsqueda en anchura
- **`g_tree.ml`**: Implementación de árboles generales
- **`tour.ml`**: Soluciones a problemas de recorrido (como el caballo)

### Algoritmos de Búsqueda y Optimización

- **N-Reinas (`nreinas.txt`)**: Implementación completa del problema clásico
- **Permutaciones (`permutations.txt`)**: Generación exhaustiva de permutaciones
- **Shortest Path (`shortest.ml`)**: Algoritmos de camino más corto

## 🛠️ Stack Tecnológico

- **Lenguaje**: OCaml (Objective Caml)
- **Paradigma**: Programación funcional, Programación lógica
- **Técnicas**: Recursión, Pattern Matching, Higher-Order Functions
- **Algoritmos**: Backtracking, Divide y Vencerás, Programación Dinámica
- **Estructuras**: Tipos Algebraicos, Listas Inmutables, Árboles
- **Herramientas**: OCaml REPL, Compilador nativo
- **Testing**: Análisis de complejidad temporal y espacial

## ⚙️ Configuración y Ejecución

### Requisitos Previos

- OCaml 4.08+ y OPAM
- Editor con soporte OCaml (VS Code + OCaml Platform)

### Compilación y Ejecución

```bash
# Cargar en el intérprete interactivo
ocaml

# Cargar un módulo específico
#use "arboles.ml";;

# Compilar a binario nativo
ocamlopt -o programa archivo.ml

# Ejecutar tests de rendimiento
ocaml -i archivo.ml
```

## 🔧 Implementaciones Destacadas

### Algoritmos de Ordenación Avanzados
- **QuickSort Optimizado**: Implementación recursiva terminal para evitar stack overflow
- **MergeSort**: Algoritmo estable con análisis de complejidad
- **Comparativa de Rendimiento**: Benchmarking con listas de hasta 1M elementos

### Problema de las N-Reinas
- **Backtracking**: Búsqueda exhaustiva con poda
- **Optimizaciones**: Verificación de compatibilidad eficiente
- **Múltiples Variantes**: Una solución, todas las soluciones, conteo

### Lógica Proposicional
- **AST**: Árbol de sintaxis abstracta para expresiones lógicas
- **Evaluador**: Interpretación de fórmulas con contexto variable
- **Operadores**: Negación, conjunción, disyunción, implicación, bicondicional

### Estructuras de Datos Funcionales
- **Árboles Binarios**: Operaciones de inserción, búsqueda y transformación
- **Listas Personalizadas**: Implementaciones optimizadas de operaciones comunes
- **Grafos**: Representación funcional para algoritmos de recorrido

## 📈 Competencias Técnicas Demostradas

- **Programación funcional**: Dominio completo del paradigma funcional
- **Análisis algorítmico**: Evaluación de complejidad temporal y espacial
- **Matemáticas discretas**: Aplicación de conceptos de lógica y combinatoria
- **Optimización**: Técnicas de mejora de rendimiento y uso de memoria
- **Resolución de problemas**: Implementación de algoritmos clásicos de IA
- **Programación avanzada**: Pattern matching, tipos algebraicos, funciones de orden superior
- **Testing y benchmarking**: Medición y comparación de rendimiento

## 🎯 Algoritmos y Técnicas Implementadas

### Técnicas de Programación
- **Recursión Terminal**: Optimización para grandes volúmenes de datos
- **Memoización**: Cacheo de resultados para programación dinámica
- **Currificación**: Aplicación parcial de funciones
- **Composición Funcional**: Combinación elegante de operaciones

### Algoritmos Clásicos
- **Backtracking**: Búsqueda sistemática con retroceso
- **Divide y Vencerás**: Descomposición de problemas complejos
- **Búsqueda en Grafos**: BFS, DFS y variantes optimizadas
- **Algoritmos Greedy**: Soluciones por aproximación óptima

### Análisis de Complejidad
- **Complejidad Temporal**: Análisis Big-O de todas las implementaciones
- **Complejidad Espacial**: Optimización de uso de memoria
- **Benchmarking**: Medición empírica de rendimiento
- **Escalabilidad**: Testing con datasets de diferentes tamaños

## 🔬 Proyectos de Investigación

Este repositorio incluye implementaciones de problemas complejos que demuestran:
- **Capacidad de abstracción**: Modelado matemático en código funcional
- **Pensamiento algorítmico**: Diseño de soluciones eficientes
- **Optimización avanzada**: Mejora continua de rendimiento
- **Rigor matemático**: Pruebas de correctitud y análisis formal

---

## 🏛️ Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Paradigmas de Programación (2020-2021)

*Proyecto desarrollado aplicando principios de programación funcional y técnicas avanzadas de algorítmica.*
