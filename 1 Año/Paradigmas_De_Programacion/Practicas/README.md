# Prácticas en OCaml — Paradigmas de Programación

## Resumen
Durante la asignatura de **Paradigmas de Programación**, he desarrollado y completado un extenso conjunto de prácticas utilizando **OCaml**, abarcando desde la manipulación básica de listas hasta algoritmos clásicos de ordenación, trabajo con árboles, lógica proposicional, técnicas de backtracking y recursión terminal, entre otros. A continuación se detalla mi experiencia práctica en los distintos bloques temáticos trabajados.

---

## Manipulación y Recursión sobre Listas

- **Implementación de funciones estándar y avanzadas de listas:**
  - `append`, `rev`, `rev_append`, `fold_left`, `filter`, `partition`, `map`, `rev_map`, `find`, `mem`, `init`, `combine`, `split`, `flatten`, entre otras, replicando y optimizando muchas de las funciones de la librería estándar de OCaml.
  - Prácticas de recursión simple y terminal, análisis de eficiencia y prevención de desbordamientos de pila en operaciones sobre listas.
  - Implementación de variantes propias como `append'`, `rev_append`, `isort'`, etc.

- **Funciones polimórficas y de orden superior:**
  - Uso y creación de funciones como `for_all`, `exists`, `map2`, `fold_right`, mostrando el dominio de la abstracción funcional.

---

## Ordenación y Algoritmos Eficientes

- **Algoritmos de ordenación implementados:**
  - **QuickSort**: versiones recursiva clásica (`qsort1`) y terminal (`qsort2`), con análisis comparativo de rendimiento en listas ordenadas y aleatorias.
  - **MergeSort**: versiones `msort1` y `msort2` (terminal y eficiente), con funciones auxiliares como `divide` y `merge`, análisis de complejidad y pruebas de rendimiento.
  - **Insertion Sort**: funciones `insert`, `isort`, y versiones terminales optimizadas.

- **Cronometrado y comparación de eficiencia:**
  - Uso de funciones como `crono` para medir tiempos de ejecución y comparar algoritmos en distintos casos (listas ordenadas, aleatorias, grandes volúmenes de datos).

---

## Árboles Binarios y Genéricos

- **Definición y manipulación de árboles:**
  - Implementación de tipos algebraicos para árboles binarios y genéricos (`bin_tree`, `g_tree`, etc.).
  - Funciones de recorrido: inorden (`inorder`), preorden, postorden, espéculo/mirror.
  - Funciones generales con `fold_tree` y su uso para calcular suma, producto, tamaño, altura y hojas del árbol.
  - Conversión entre diferentes representaciones de árboles (`tree_of_sttree`, `sttree_of_tree`).

- **Recorridos avanzados y algoritmos sobre árboles:**
  - Implementación de recorrido por niveles (`breadth_first`), generación de árboles grandes y gestión de eficiencia y stack overflow.

---

## Lógica Proposicional y Expresiones

- **Definición de tipos para lógica proposicional:**
  - Modelado de expresiones lógicas (`log_exp`, `prop`, operadores unarios y binarios, etc.).
  - Funciones de evaluación (`eval`, `peval`), conversión entre representaciones y obtención de variables libres.

- **Implementación de tautologías:**
  - Algoritmo para verificar si una proposición es una tautología (`is_tau`), generación de contextos y combinatoria de asignaciones.

---

## Paradigmas y Técnicas Funcionales Avanzadas

- **Funciones curryficadas y desacurryficadas:**
  - Implementación de `curry`, `uncurry`, y aplicaciones prácticas en funciones aritméticas y de manipulación de tuplas.

- **Producto cartesiano, factorial y recursividad terminal:**
  - Desarrollo de funciones terminales para cálculo eficiente de factoriales (`pro_fact`, `fact`), Fibonacci y máximo de listas.

- **Composición y combinadores funcionales:**
  - Implementación de combinadores como `comp` para composición de funciones arbitrarias.

---

## Backtracking y Problemas Clásicos

- **Problema de las N reinas (ocho reinas generalizado):**
  - Resolución mediante backtracking y generación de todas las soluciones posibles.
  - Control y manejo de excepciones en recursión, optimización de búsqueda y conteo de soluciones (`all_queens`, `nu_queens`).

- **Problema del recorrido del caballo (knight's tour):**
  - Algoritmo de backtracking para encontrar recorridos y tours más cortos en tableros de ajedrez de tamaño arbitrario.

---

## Permutaciones y Combinatoria

- **Generación de permutaciones:**
  - Funciones recursivas para obtener todas las permutaciones posibles de una lista (`interleave`, `permutations`, `next`).

---

## Entrada/Salida y Manejo de Archivos

- **Operaciones básicas de E/S:**
  - Uso de funciones para impresión de caracteres, cadenas, líneas, lectura interactiva y gestión de archivos.
  - Comprensión del flujo de entrada/salida en OCaml y manejo explícito del buffer y flushing.

---

## Tipos Algebraicos y Modelado de Datos

- **Definición de tipos algebraicos complejos:**
  - Modelado de números, booleanos, días, números naturales y variantes heterogéneas.
  - Implementación de operaciones seguras y manejo de errores mediante tipos y excepciones.

---

## Otros Algoritmos y Técnicas

- **Implementación de algoritmos clásicos:**
  - Algoritmos sobre secuencias de Collatz, manejo de órbitas, máximos, recuentos y recorridos personalizados.
  - Funciones para eliminar elementos, diferencias y productos cartesianos de listas.

---

## Conclusión

Mi experiencia con OCaml en la asignatura de Paradigmas de Programación me ha permitido desarrollar una sólida base en programación funcional, algoritmia eficiente, modelado con tipos algebraicos y resolución de problemas clásicos mediante técnicas avanzadas de recursión, backtracking y composición funcional.

---
