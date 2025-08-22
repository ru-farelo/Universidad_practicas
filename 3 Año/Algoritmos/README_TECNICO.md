# Algoritmos - Análisis y Diseño de Algoritmos Avanzados

## Descripción del Proyecto

Implementación y análisis exhaustivo de **algoritmos fundamentales** en C, abarcando desde optimización de subsecuencias hasta algoritmos de grafos complejos. El proyecto incluye análisis riguroso de complejidad temporal, benchmarking experimental y comparativas de rendimiento entre diferentes enfoques algorítmicos.

## Características Principales

- **Análisis de complejidad**: Estudio empírico y teórico de algoritmos
- **Algoritmos de optimización**: Subsecuencia máxima con múltiples enfoques
- **Algoritmos de ordenación**: Implementación y comparativa de rendimiento
- **Estructuras de datos avanzadas**: Montículos y heaps para optimización
- **Algoritmos de grafos**: Implementación de Dijkstra para caminos mínimos
- **Benchmarking riguroso**: Medición precisa de tiempos de ejecución
- **Análisis experimental**: Validación empírica de complejidades teóricas

##  Arquitectura del Proyecto

### Práctica 1 - Optimización de Subsecuencias
- **Algoritmo O(n²)**: Implementación de fuerza bruta para subsecuencia máxima
- **Algoritmo de Kadane O(n)**: Optimización lineal del problema
- **Análisis comparativo**: Benchmarking de rendimiento entre enfoques
- **Metodología experimental**: Framework de medición temporal precisa

### Práctica 2 - Algoritmos de Ordenación
- **Ordenación por inserción**: Algoritmo O(n²) con análisis detallado
- **Ordenación Shell**: Mejora de inserción con incrementos decrecientes
- **Análisis de casos**: Mejor, peor y caso promedio para cada algoritmo
- **Comparativa experimental**: Evaluación con diferentes tipos de datos

### Práctica 3 - Estructuras de Datos Avanzadas
- **Montículos (Heaps)**: Implementación completa de min-heap
- **HeapSort**: Algoritmo de ordenación O(n log n) basado en montículos
- **Operaciones de montículo**: Inserción, eliminación y construcción
- **Análisis de eficiencia**: Comparación con otros algoritmos de ordenación

### Práctica 4 - Algoritmos de Grafos
- **Algoritmo de Dijkstra**: Caminos mínimos desde fuente única
- **Representación de grafos**: Matrices de adyacencia optimizadas
- **Análisis de complejidad**: O(V²) con implementación eficiente
- **Aplicaciones prácticas**: Problemas de enrutamiento y navegación

##  Stack Tecnológico

- **Lenguaje**: C estándar (C99/C11)
- **Compilación**: GCC con optimizaciones (-O2, -O3)
- **Medición temporal**: gettimeofday() para microsegundos de precisión
- **Análisis estadístico**: Medias y regresiones para validación
- **Herramientas**: Valgrind, GDB, profiling tools
- **Documentación**: Informes detallados con análisis matemático
- **Testing**: Casos de prueba exhaustivos y validación algorítmica

##  Configuración y Ejecución

### Requisitos Previos

- GCC 9.0+ con soporte completo C11
- Sistema Unix/Linux para medición temporal precisa
- Memoria suficiente para datasets grandes (hasta 512K elementos)

### Estructura del Proyecto

```
algoritmos/
├── P1/                        # Subsecuencia máxima
│   ├── practica1.c           # Implementaciones O(n²) y O(n)
│   ├── informe_P1.txt        # Análisis completo de resultados
│   └── p1.pdf                # Especificaciones del problema
├── P2/                        # Algoritmos de ordenación
│   ├── p2.c                  # Inserción y Shell sort
│   └── informe_P2.txt        # Comparativa de rendimiento
├── P3/                        # Montículos y HeapSort
│   ├── p3.c                  # Implementación completa de heaps
│   └── informe_P3.txt        # Análisis de estructuras de datos
└── P4/                        # Algoritmos de grafos
    ├── p4.c                  # Dijkstra y representación de grafos
    └── udc-prep-algoritmos/  # Framework de testing
```

### Compilación y Ejecución

```bash
# Compilar práctica específica
gcc -O2 -Wall -Wextra -o practica1 P1/practica1.c -lm

# Ejecutar con análisis de rendimiento
./practica1

# Compilar con optimizaciones máximas
gcc -O3 -march=native -o practica_opt P2/p2.c

# Análisis con Valgrind
valgrind --tool=callgrind ./practica3

# Profiling de rendimiento
gprof practica4 gmon.out > analysis.txt
```

## Implementaciones Destacadas

### Algoritmos de Optimización Dinámica
- **Subsecuencia máxima O(n²)**: Enfoque de fuerza bruta con análisis exhaustivo
- **Algoritmo de Kadane O(n)**: Programación dinámica optimizada
- **Análisis de casos límite**: Manejo de vectores con valores negativos
- **Comparativa experimental**: Validación empírica de complejidades

### Algoritmos de Ordenación Avanzados
- **Ordenación por inserción optimizada**: Implementación con mejoras prácticas
- **Shell Sort con secuencias**: Análisis de diferentes incrementos
- **Análisis de estabilidad**: Comportamiento con elementos duplicados
- **Benchmarking de casos**: Ascendente, descendente y aleatorio

### Estructuras de Datos Eficientes
- **Min-Heap completo**: Implementación con array subyacente
- **Operaciones O(log n)**: Inserción, eliminación y ajuste
- **HeapSort in-place**: Ordenación sin memoria adicional
- **Construcción O(n)**: Algoritmo de Floyd para creación eficiente

### Algoritmos de Grafos Clásicos
- **Dijkstra optimizado**: Implementación O(V²) sin cola de prioridad
- **Matriz de adyacencia**: Representación eficiente para grafos densos
- **Relajación de aristas**: Técnica fundamental en caminos mínimos
- **Análisis de conectividad**: Validación de grafos y componentes

## Competencias Técnicas Demostradas

- **Análisis algorítmico**: Evaluación rigurosa de complejidad temporal y espacial
- **Programación eficiente**: Optimizaciones a nivel de código y compilador
- **Metodología experimental**: Diseño de experimentos para validación empírica
- **Estructuras de datos**: Implementación y análisis de estructuras avanzadas
- **Matemáticas aplicadas**: Análisis estadístico y regresión de datos
- **Optimización de rendimiento**: Técnicas de profiling y mejora continua
- **Investigación algorítmica**: Comparación sistemática de enfoques

## Algoritmos y Complejidades Implementadas

### Análisis de Complejidad
- **Subsecuencia máxima**: O(n²) → O(n) mediante programación dinámica
- **Ordenación por inserción**: O(n²) promedio, O(n) mejor caso
- **Shell Sort**: O(n^1.5) con secuencia de Sedgewick
- **HeapSort**: O(n log n) garantizado en todos los casos
- **Dijkstra**: O(V²) con matriz de adyacencia

### Técnicas Algorítmicas
- **Programación dinámica**: Optimización de subproblemas solapados
- **Divide y vencerás**: Estrategias de partición y conquista
- **Algoritmos greedy**: Selección óptima local en cada paso
- **Backtracking**: Exploración sistemática del espacio de soluciones

### Optimizaciones Aplicadas
- **Localidad de cache**: Acceso secuencial a memoria para eficiencia
- **Desenrollado de bucles**: Reducción de overhead de iteración
- **Eliminación de recursión**: Conversión a versiones iterativas
- **Análisis de casos**: Optimización específica para diferentes inputs

## Metodología Experimental

### Framework de Benchmarking
- **Medición temporal precisa**: Microsegundos con gettimeofday()
- **Múltiples ejecuciones**: Promediado para reducir varianza
- **Casos de prueba controlados**: Datasets ascendentes, descendentes y aleatorios
- **Validación estadística**: Análisis de regresión y coeficientes de determinación

### Análisis de Resultados
- **Tablas de rendimiento**: Comparación sistemática de algoritmos
- **Gráficas de complejidad**: Visualización de crecimiento temporal
- **Cotas teóricas vs empíricas**: Validación de análisis matemático
- **Factores constantes**: Análisis de overhead real en implementaciones

## Logros Técnicos Alcanzados

Este proyecto demuestra:
- **Rigor algorítmico**: Implementación correcta de algoritmos complejos
- **Metodología científica**: Experimentación sistemática y validación
- **Optimización avanzada**: Mejoras significativas de rendimiento
- **Análisis matemático**: Capacidad de formalización y demostración
- **Programación eficiente**: Código optimizado para rendimiento máximo
- **Investigación empírica**: Validación experimental de teoría algorítmica

---

## Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Algoritmos (2022-2023)

*Proyecto desarrollado aplicando técnicas avanzadas de análisis algorítmico y metodología experimental rigurosa.*
