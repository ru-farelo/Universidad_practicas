# Visión Artificial - 🚦 Sistema de Reconocimiento de Señales de Tráfico

📌 Sistema de visión por computador desarrollado desde cero en Python para detectar y clasificar señales de tráfico en tiempo real, con una precisión superior al 90% en pruebas controladas.  
Incluye algoritmos propios de procesamiento de imágenes, optimización de rendimiento y aplicación directa en vehículos autónomos, smart cities y sistemas de inspección industrial.

## Descripción del Proyecto
El proyecto **Visión Artificial** constituye una implementación completa de un sistema de visión por computador especializado en la **detección y clasificación automática de señales de tráfico**. El desarrollo se centra en la implementación desde cero de algoritmos fundamentales de procesamiento de imágenes y computer vision, sin depender de librerías preconstruidas para los componentes core del sistema.

### Objetivos Principales
- Desarrollo de algoritmos propios de procesamiento de imágenes y detección de objetos  
- Implementación de pipeline completo desde captura hasta clasificación final  
- Optimización para tiempo real con robustez ante condiciones variables de iluminación  
- Validación exhaustiva del sistema con múltiples criterios de clasificación  

## Tecnologías y Herramientas

**Entorno de Desarrollo**  
- Lenguaje Principal: Python 3.x  
- Librerías Core: NumPy (computación numérica), OpenCV (E/S de imágenes), Matplotlib (visualización)  
- Paradigma: Programación orientada a objetos con enfoque modular  

**Metodologías Implementadas**  
- Procesamiento de Imágenes: Filtrado, segmentación, morfología matemática  
- Visión por Computador: Detección de contornos, análisis geométrico, clasificación por características  
- Algoritmos Propios: Implementación desde cero de detectores de formas y clasificadores  

## Arquitectura del Sistema

**Pipeline de Procesamiento**  
1. Captura y Preprocesamiento  
   - Normalización de imágenes de entrada  
   - Conversión de espacios de color (RGB → HSV)  
   - Filtrado de ruido y mejora de contraste  

2. Segmentación por Color  
   - Implementación de rangos HSV adaptativos  
   - Robustez ante variaciones de iluminación  
   - Extracción de regiones candidatas  

3. Análisis Geométrico  
   - Detección de contornos mediante algoritmos propios  
   - Clasificación de formas: círculos, triángulos, cuadrados, octógonos  
   - Validación por criterios geométricos (área, perímetro, compacidad)  

4. Clasificación Final  
   - Sistema multi-criterio (forma + color + proporción)  
   - Categorización: Prohibición, Peligro, Obligación, Indicación  
   - Filtrado de falsos positivos  

**Características Técnicas**
- Precisión de Detección: Superior al 90% en condiciones controladas  
- Tiempo de Respuesta: Procesamiento en tiempo real  
- Escalabilidad: Arquitectura modular para extensión de categorías  
- Robustez: Tolerancia a condiciones de iluminación variable  

## 📁 Estructura del Proyecto

```
Vision_Artificial/
├── P1/                                 # Práctica 1: Fundamentos de Procesamiento
│   └── VA-Practicas/
│       ├── p1.py                      # Algoritmos fundamentales de visión artificial
│       ├── imagenes.py                # Funciones de carga y visualización de imágenes
│       ├── test.py                    # Tests de validación de funciones básicas
│       ├── main.py                    # Ejecutor principal de la práctica
│       ├── imagenes/                  # Dataset de imágenes de prueba
│       ├── imagenes_output/           # Resultados del procesamiento
│       └── VA-P1-2324.pdf            # Documentación técnica
│
└── P2/                                 # Práctica 2: Sistema de Reconocimiento Completo de Señales de Tráfico
    └── VA-PRACTICA-P2-main/
        ├── p2.py                      # Clasificación avanzada (Hough, aproximación poligonal)
        ├── test.py                    # Tests de máscaras y clasificación de señales
        ├── main.py                    # Pipeline completo de detección y clasificación
        ├── Material Señales/          # Dataset de señales de tráfico (12 imágenes .ppm)
        └── Documentacion_VA.pdf       # Documentación del sistema completo
```

### Contenido por Práctica

**P1 - Fundamentos:** Implementación de algoritmos básicos de procesamiento de imágenes, funciones de carga/visualización y validación de componentes fundamentales.

**P2 - Sistema Completo:** Desarrollo del pipeline de reconocimiento final con clasificación por transformada de Hough (señales circulares) y aproximación poligonal (resto de formas), incluyendo filtros de máscaras y validación integral.


## Características Destacadas

**Implementación Técnica**  
- Algoritmos propios desarrollados desde cero  
- Optimización de rendimiento para tiempo real  
- Modularidad para incorporar nuevas categorías  
- Validación robusta con sistema multi-criterio  

**Aplicaciones Prácticas**  
- Industria Automotriz: Sistemas ADAS  
- Vehículos Autónomos: Navegación y detección automática  
- Smart Cities: Monitorización de infraestructura vial  
- Inspección Industrial: Control de calidad automatizado  

## Valor Técnico y Profesional

Este proyecto demuestra competencias avanzadas en:
- Visión por Computador: Técnicas fundamentales y algoritmos especializados  
- Programación de Sistemas: Implementación de pipelines complejos  
- Optimización: Código eficiente para tiempo real  
- Análisis de Rendimiento: Validación exhaustiva de sistemas de visión artificial  

**Relevancia Industrial**  
- Desarrollo de tecnologías para vehículos autónomos  
- Sistemas inteligentes de transporte  
- Aplicaciones IoT en infraestructuras urbanas  
- Sistemas de inspección automatizada  