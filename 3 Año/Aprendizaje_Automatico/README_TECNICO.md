# Aprendizaje Automático (AA)
## Implementación Completa de Algoritmos de Machine Learning e Inteligencia Artificial

Este repositorio contiene el desarrollo progresivo de **seis prácticas incrementales** y un **proyecto final integrador** en la asignatura de Aprendizaje Automático, demostrando competencias avanzadas en machine learning, deep learning y procesamiento de imágenes médicas.

## Objetivos de Aprendizaje

- **Algoritmos de Machine Learning**: Implementación desde cero de algoritmos fundamentales de ML
- **Deep Learning**: Desarrollo de redes neuronales convolucionales con Julia y Flux.jl
- **Visión por Computador**: Procesamiento y análisis de imágenes médicas para diagnóstico
- **Optimización**: Técnicas avanzadas de regularización, validación cruzada y selección de modelos

## Prácticas Incrementales Desarrolladas

### P1: Fundamentos y Preprocesamiento de Datos
**Manipulación de datasets y técnicas de normalización**

#### Competencias Desarrolladas
- **Carga y procesamiento de datos**: Manejo del dataset Iris clásico
- **Codificación categórica**: Implementación de One-Hot Encoding
- **Normalización**: Técnicas Min-Max y Z-Score normalization
- **Preparación de datos**: Conversión de tipos y validación de consistencia

#### Tecnologías
- **Julia**: Lenguaje principal de programación científica
- **FileIO & DelimitedFiles**: Manejo de archivos y datos estructurados
- **Statistics**: Análisis estadístico básico

### P2: Redes Neuronales Artificiales
**Implementación completa de ANNs desde cero**

#### Funcionalidades Implementadas
- **Arquitectura flexible**: Función `buildClassANN` para topologías personalizables
- **Entrenamiento optimizado**: Algoritmo Adam con early stopping
- **Funciones de activación**: Sigmoid, ReLU, Softmax para diferentes capas
- **Loss functions**: Binary Cross-Entropy y Categorical Cross-Entropy
- **Métricas de evaluación**: Accuracy y clasificación multiclase

#### Algoritmos Clave
```julia
# Construcción de ANN con topología variable
buildClassANN(numInputs, topology, numOutputs; transferFunctions)
# Entrenamiento con optimización Adam
trainClassANN(topology, dataset; maxEpochs, learningRate)
```

### P3: Técnicas de Regularización
**Control de sobreentrenamiento y optimización de modelos**

#### Técnicas Implementadas
- **Hold-Out Validation**: División estratificada de datasets
- **Cross-Validation**: Validación cruzada k-fold
- **Early Stopping**: Prevención de overfitting
- **L1/L2 Regularization**: Técnicas de penalización

### P4-P5: Algoritmos de Machine Learning Clásicos
**Implementación de algoritmos fundamentales**

#### Algoritmos Desarrollados
- **Support Vector Machines**: Kernels lineales, polinómicos, RBF
- **Decision Trees**: Algoritmos de partición con control de profundidad
- **K-Nearest Neighbors**: Clasificación basada en proximidad
- **Ensemble Methods**: Combinación de múltiples modelos

### P6: Integración con Scikit-Learn
**Interfaz Julia-Python para algoritmos optimizados**

#### Funcionalidades
- **ScikitLearn.jl**: Wrapper para algoritmos de sklearn
- **Comparación de rendimiento**: Implementaciones propias vs. optimizadas
- **Validación de algoritmos**: Verificación de correctitud

```julia
@sk_import svm: SVC
@sk_import tree: DecisionTreeClassifier
@sk_import neighbors: KNeighborsClassifier
```

## Proyecto Final: Diagnóstico de Melanoma con Deep Learning

### Sistema Completo de Clasificación de Lesiones Cutáneas

#### Problemática Médica
**Clasificación automática de lesiones dermatológicas en tres categorías:**
- **Melanoma**: Cáncer de piel agresivo
- **Nevus Atípico**: Lesión benigna con características irregulares  
- **No Melanoma**: Lesión benigna normal

#### Enfoques Desarrollados

### 1. Machine Learning Tradicional con Feature Engineering
**Extracción manual de características dermatológicas**

#### Características Implementadas
- **Regularidad**: Ratio de área lesión/bounding box
- **Asimetría**: Análisis de simetría bilateral
- **Irregularidad de Bordes**: Longitud normalizada del perímetro
- **Intensidad de Píxeles**: Media de valores en ROI
- **Análisis de Color**: Estadísticas RGB en región segmentada

#### Pipeline de Procesamiento
```julia
# Carga de imágenes dermoscópicas y de lesión
no_melanoma_imgs = cargar_imagenes("no_melanoma", "lesion", true)
melanoma_imgs = cargar_imagenes("melanoma", "lesion", true)

# Extracción de características específicas
dataset = extraer_caracteristicas_aprox1(inputs, bounding_boxes)
normalizeMinMax!(dataset)

# Evaluación de múltiples algoritmos
execute_SVM(configuraciones, dataset, targets)
execute_ARB(profundidades, dataset, targets)
execute_KNN(K_values, dataset, targets)
execute_ANN(topologias, dataset, targets)
```

### 2. Deep Learning con Redes Neuronales Convolucionales
**Arquitecturas CNN especializadas para diagnóstico médico**

#### Arquitecturas Implementadas
- **CNN Shallow**: 1-2 capas convolucionales para baseline
- **CNN Deep**: 3-4 capas con pooling progresivo
- **CNN Multi-Scale**: Kernels de diferentes tamaños (3x3, 5x5)
- **Arquitecturas Optimizadas**: Balanceando profundidad y parámetros

#### Ejemplos de Arquitecturas
```julia
# CNN profunda con regularización
ann3 = Chain(
    Conv((3, 3), 3=>16, pad=(1,1), relu),
    MaxPool((2,2)),
    Conv((3, 3), 16=>32, pad=(1,1), relu), 
    MaxPool((2,2)),
    Conv((3, 3), 32=>32, pad=(1,1), relu),
    MaxPool((2,2)),
    x -> reshape(x, :, size(x, 4)),
    Dense(288, 3),
    softmax
)
```

#### Entrenamiento Avanzado
- **Regularización L1/L2**: Control de overfitting
- **Adam Optimizer**: Optimización adaptativa
- **Early Stopping**: Criterios múltiples de parada
- **Data Augmentation**: Transformaciones para robustez

```julia
# Loss function con regularización
loss(model,x,y) = crossentropy(model(x),y) + 
                  L1*sum(absnorm, Flux.params(model)) + 
                  L2*sum(sqrnorm, Flux.params(model))
```

#### Procesamiento de Imágenes
- **Preprocessing**: Redimensionado a 30x30 píxeles
- **Conversión de formatos**: RGB → Array 4D (HWCN)
- **Normalización**: Valores en rango [0,1]
- **Segmentación**: Extracción de ROI con bounding boxes

## Stack Tecnológico Completo

### Machine Learning y Deep Learning
| Tecnología | Propósito | Características |
|------------|-----------|-----------------|
| **Julia** | Lenguaje principal | Alto rendimiento científico |
| **Flux.jl** | Deep Learning framework | Redes neuronales dinámicas |
| **MLJ.jl** | Machine Learning ecosystem | Interfaz unificada |
| **ScikitLearn.jl** | Algoritmos clásicos | Wrapper Python-Julia |

### Procesamiento de Imágenes
| Tecnología | Propósito | Características |
|------------|-----------|-----------------|
| **Images.jl** | Manipulación de imágenes | Carga, conversión, filtrado |
| **ImageFeatures.jl** | Extracción de características | Descriptores geométricos |
| **ImageMorphology.jl** | Operaciones morfológicas | Bounding boxes, centroides |

### Análisis y Visualización
| Tecnología | Propósito | Características |
|------------|-----------|-----------------|
| **Plots.jl** | Visualización | Gráficos y métricas |
| **Statistics.jl** | Análisis estadístico | Métricas de evaluación |
| **Random.jl** | Generación aleatoria | Reproducibilidad |

## Arquitectura del Proyecto

```
Aprendizaje_Automatico/
├── P1/                                    # Fundamentos y preprocesamiento
│   ├── Solucion P1.jl                    # Carga y normalización de datos
│   └── iris/                             # Dataset clásico
├── P2/                                    # Redes neuronales artificiales
│   ├── P2.jl                             # Implementación ANN desde cero
│   └── pruebasconIris.jl                 # Validación con Iris
├── P3/                                    # Regularización y validación
├── P4-P5/                                # Algoritmos ML clásicos
├── P6/                                    # Integración ScikitLearn
│   └── P6.jl                             # Wrapper Python-Julia
└── Final/                                # Proyecto integrador
    ├── src/
    │   ├── deepLearning.jl               # CNNs para clasificación
    │   ├── arquitectures.jl              # 11 arquitecturas CNN
    │   ├── aprox1-4.jl                   # Enfoques incrementales
    │   ├── adhoc.jl                      # Feature engineering
    │   └── plotting.jl                   # Visualización resultados
    └── datasets/                         # Imágenes dermatológicas
        ├── melanoma/
        ├── no_melanoma/
        └── atypical_nevus/
```

## Competencias Técnicas Demostradas

### Machine Learning Avanzado
- **Algoritmos Fundamentales**: Implementación desde cero de SVM, Decision Trees, KNN, ANNs
- **Optimización**: Adam, SGD con momentum, técnicas de regularización
- **Evaluación de Modelos**: Cross-validation, métricas multiclase, F1-Score
- **Feature Engineering**: Extracción manual de características específicas del dominio

### Deep Learning Especializado
- **Arquitecturas CNN**: Diseño de redes convolucionales para visión médica
- **Transfer Learning**: Adaptación de modelos para diagnóstico específico
- **Regularización Avanzada**: L1/L2, Dropout, Early Stopping
- **Optimización de Hiperparámetros**: Grid search automático de arquitecturas

### Visión por Computador Médica
- **Segmentación de Imágenes**: Extracción de ROI en imágenes dermatológicas
- **Análisis Morfológico**: Cálculo de asimetría, irregularidad, características geométricas
- **Procesamiento Multi-modal**: Imágenes dermoscópicas y de lesión
- **Feature Engineering Médico**: Características específicas para diagnóstico dermatológico

### Desarrollo Científico
- **Julia High-Performance**: Programación científica de alto rendimiento
- **Reproducibilidad**: Semillas aleatorias y experimentos controlados
- **Análisis Estadístico**: Validación robusta de resultados
- **Visualización Científica**: Gráficos explicativos y métricas

## Casos de Uso Implementados

### 1. Clasificación Tradicional con Feature Engineering
```julia
# Pipeline completo de ML tradicional
dataset = extraer_caracteristicas_aprox1(imagenes, bounding_boxes)
normalizeMinMax!(dataset)
(f1_score, config) = execute_SVM(configuraciones, dataset, targets)
```

### 2. Deep Learning para Diagnóstico Médico
```julia
# Entrenamiento de CNN multiclase
train_set = (train_imgs, onehotbatch(train_labels, ["melanoma", "no_melanoma", "atypical_nevus"]))
f1_scores = [train(arquitectura) for arquitectura in arquitecturas]
```

### 3. Análisis Comparativo de Arquitecturas
```julia
# Evaluación sistemática de 11 arquitecturas CNN
bar(1:length(arquitecturas), [f1_test f1_training], 
    title="Comparación F1 Score en Test vs Training")
```

## Características Avanzadas

### Sistema de Evaluación Robusto
- **Múltiples Métricas**: F1-Score, Accuracy, Matriz de Confusión
- **Validación Cruzada**: Evaluación estadísticamente significativa
- **Comparación Sistemática**: 11 arquitecturas CNN evaluadas automáticamente
- **Early Stopping Inteligente**: Múltiples criterios de parada

### Optimización de Rendimiento
- **Julia High-Performance**: Compilación JIT para velocidad nativa
- **Paralelización**: Procesamiento paralelo de imágenes
- **Memory Efficiency**: Gestión optimizada de grandes datasets de imágenes
- **GPU Compatibility**: Preparado para aceleración CUDA

### Procesamiento Médico Especializado
- **Segmentación Automática**: Detección de bounding boxes de lesiones
- **Análisis Morfológico**: Características geométricas específicas
- **Multi-resolución**: Procesamiento a diferentes escalas
- **Robustez**: Manejo de variabilidad en imágenes médicas reales

##  Logros Destacados

- **Sistema Completo de Diagnóstico**: Pipeline end-to-end desde imagen raw hasta clasificación
- **Implementación Nativa**: Algoritmos ML desarrollados desde cero sin librerías externas
- **Investigación Comparativa**: Evaluación sistemática de 11 arquitecturas CNN diferentes
- **Feature Engineering Médico**: Características específicas del dominio dermatológico
- **Alta Performance**: Implementación optimizada con Julia para computación científica
- **Reproducibilidad**: Experimentos controlados con semillas fijas y validación robusta

Este proyecto demuestra competencias excepcionales en **machine learning médico**, **deep learning aplicado**, **visión por computador** y **desarrollo científico de alto rendimiento**, preparando para roles especializados en AI médica, computer vision engineering y research & development en inteligencia artificial.
