# Sistemas Inteligentes - Inteligencia Artificial y Machine Learning

## 📋 Descripción del Proyecto

Implementación de algoritmos y técnicas fundamentales de **Inteligencia Artificial** y **Machine Learning**, abarcando desde métodos de búsqueda clásicos hasta algoritmos de aprendizaje automático avanzados. El proyecto demuestra competencias en resolución de problemas complejos mediante técnicas de IA y análisis de datos.

## 🚀 Características Principales

- **Algoritmos de búsqueda**: Implementación de técnicas de búsqueda informada y no informada
- **Sistemas expertos**: Desarrollo de motores de inferencia y bases de conocimiento
- **Machine Learning**: Algoritmos de aprendizaje supervisado y no supervisado
- **Redes neuronales**: Implementación desde cero de perceptrones y redes multicapa
- **Algoritmos genéticos**: Optimización mediante computación evolutiva
- **Procesamiento de lenguaje natural**: Análisis y comprensión de texto
- **Visión artificial**: Procesamiento y reconocimiento de imágenes

## 🏗️ Arquitectura del Proyecto

### Módulo de Búsqueda y Planificación
- **Búsqueda ciega**: BFS, DFS, búsqueda de coste uniforme
- **Búsqueda informada**: A*, búsqueda greedy, IDA*
- **Búsqueda adversarial**: Minimax, poda alfa-beta
- **Planificación**: STRIPS, planificación jerárquica

### Módulo de Aprendizaje Automático
- **Aprendizaje supervisado**: Regresión lineal, árboles de decisión, SVM
- **Aprendizaje no supervisado**: K-means, clustering jerárquico
- **Redes neuronales**: Perceptrón, MLP, backpropagation
- **Algoritmos evolutivos**: Algoritmos genéticos, programación evolutiva

### Módulo de Sistemas Basados en Conocimiento
- **Motores de inferencia**: Forward chaining, backward chaining
- **Representación del conocimiento**: Lógica de predicados, frames
- **Sistemas expertos**: Motor de reglas, explicación de decisiones
- **Razonamiento bajo incertidumbre**: Redes bayesianas, lógica difusa

## 🛠️ Stack Tecnológico

- **Lenguajes**: Java SE 11+, Python 3.8+
- **ML Libraries**: Scikit-learn, NumPy, Pandas, Matplotlib
- **AI Frameworks**: AIMA-Java, Weka, TensorFlow/Keras (básico)
- **Herramientas**: Jupyter Notebooks, IntelliJ IDEA, PyCharm
- **Visualización**: Matplotlib, Seaborn, Graphviz
- **Testing**: JUnit 5, PyTest, unittest
- **Datos**: CSV processing, database integration

## ⚙️ Configuración y Ejecución

### Requisitos Previos

- Java JDK 11+ y Python 3.8+
- Jupyter Notebook o JupyterLab
- Bibliotecas científicas: numpy, pandas, scikit-learn
- IDE con soporte AI/ML

### Estructura del Proyecto

```
sistemas-inteligentes/
├── busqueda/                  # Algoritmos de búsqueda
│   ├── ciega/                 # BFS, DFS, UCS
│   ├── informada/             # A*, Greedy, IDA*
│   └── adversarial/           # Minimax, Alpha-Beta
├── machine-learning/          # Aprendizaje automático
│   ├── supervisado/           # Clasificación y regresión
│   ├── no-supervisado/        # Clustering y reducción dimensional
│   └── redes-neuronales/      # Perceptrón y MLP
├── sistemas-expertos/         # Sistemas basados en conocimiento
│   ├── motor-inferencia/      # Forward/Backward chaining
│   └── base-conocimiento/     # Representación de reglas
└── notebooks/                 # Análisis y visualizaciones
```

### Compilación y Ejecución

```bash
# Ejecutar algoritmos de búsqueda
javac -cp "lib/*" src/busqueda/*.java
java -cp "src:lib/*" busqueda.AStar problema.txt

# Ejecutar machine learning
python -m venv ml-env
source ml-env/bin/activate
pip install numpy pandas scikit-learn matplotlib
python machine_learning/clasificacion.py

# Jupyter notebooks
jupyter notebook notebooks/analisis_datos.ipynb
```

## 🔧 Implementaciones Destacadas

### Algoritmos de Búsqueda Avanzados
- **A* optimizado**: Implementación con heurísticas admisibles y consistentes
- **IDA* iterativo**: Búsqueda con memoria limitada para espacios grandes
- **Minimax con poda**: Algoritmo de juegos con optimización alfa-beta
- **Búsqueda local**: Hill climbing, simulated annealing, algoritmos genéticos

### Machine Learning desde Cero
- **Perceptrón multicapa**: Implementación completa con backpropagation
- **Árboles de decisión**: Construcción con criterios de ganancia de información
- **K-means clustering**: Algoritmo de agrupamiento con inicialización K-means++
- **Regresión lineal**: Implementación con descenso de gradiente

### Sistemas Expertos
- **Motor de inferencia**: Forward chaining con resolución de conflictos
- **Base de conocimiento**: Representación de reglas y hechos
- **Explicación de decisiones**: Trazabilidad del razonamiento
- **Manejo de incertidumbre**: Factores de certeza y propagación

### Procesamiento Inteligente de Datos
- **Preprocesamiento**: Normalización, tratamiento de valores faltantes
- **Feature engineering**: Selección y extracción de características
- **Validación cruzada**: Evaluación robusta de modelos
- **Métricas de evaluación**: Precision, recall, F1-score, ROC-AUC

## 📈 Competencias Técnicas Demostradas

- **Inteligencia Artificial**: Dominio de algoritmos clásicos y modernos de IA
- **Machine Learning**: Implementación y evaluación de modelos de aprendizaje
- **Análisis de datos**: Procesamiento, visualización y extracción de insights
- **Optimización**: Técnicas de búsqueda local y global para problemas complejos
- **Representación del conocimiento**: Modelado formal de dominios de problema
- **Evaluación de algoritmos**: Análisis de complejidad y rendimiento empírico
- **Programación científica**: Uso de bibliotecas especializadas y herramientas de investigación

## 🎯 Algoritmos y Técnicas Implementadas

### Técnicas de Búsqueda
- **Búsqueda ciega**: Exploración sistemática sin información del dominio
- **Búsqueda informada**: Uso de heurísticas para guiar la búsqueda
- **Búsqueda local**: Optimización mediante mejora iterativa
- **Búsqueda adversarial**: Algoritmos para juegos de suma cero

### Aprendizaje Automático
- **Aprendizaje supervisado**: Clasificación y regresión con etiquetas
- **Aprendizaje no supervisado**: Descubrimiento de patrones ocultos
- **Aprendizaje por refuerzo**: Optimización mediante recompensas
- **Deep Learning básico**: Redes neuronales profundas introductorias

### Razonamiento Automático
- **Lógica proposicional**: Satisfacibilidad y resolución
- **Lógica de predicados**: Unificación y teorema de resolución
- **Razonamiento probabilístico**: Redes bayesianas y propagación
- **Razonamiento difuso**: Lógica fuzzy y sistemas de control

## 🔬 Proyectos de Investigación

### Aplicaciones Desarrolladas
- **Sistema de recomendación**: Filtrado colaborativo y basado en contenido
- **Clasificador de texto**: Análisis de sentimientos con NLP
- **Juego inteligente**: IA para juegos de estrategia (ajedrez, damas)
- **Predictor de series temporales**: Forecasting con técnicas avanzadas

### Análisis Experimental
- **Comparativa de algoritmos**: Benchmarking de diferentes enfoques
- **Optimización de hiperparámetros**: Grid search y búsqueda aleatoria
- **Análisis de convergencia**: Estudio de comportamiento de algoritmos iterativos
- **Evaluación de robustez**: Testing con datos ruidosos y outliers

## 🏆 Logros Técnicos Alcanzados

Este proyecto demuestra:
- **Capacidad de investigación**: Implementación de algoritmos estado del arte
- **Pensamiento analítico**: Resolución de problemas complejos mediante IA
- **Programación avanzada**: Desarrollo de sistemas inteligentes escalables
- **Conocimiento interdisciplinario**: Aplicación de matemáticas, estadística y CS
- **Experimentación rigurosa**: Metodología científica en evaluación de algoritmos
- **Innovación tecnológica**: Desarrollo de soluciones creativas con IA

---

## 🏛️ Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Sistemas Inteligentes (2021-2022)

*Proyecto desarrollado aplicando técnicas avanzadas de Inteligencia Artificial y Machine Learning con enfoque en investigación y desarrollo.*
