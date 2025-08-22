# Interfaz Persona-Máquina (IPM)
## Desarrollo de Aplicaciones con Enfoque en Experiencia de Usuario

Este repositorio contiene el desarrollo de **tres proyectos principales** en la asignatura de Interfaz Persona-Máquina, demostrando competencias en diseño de experiencia de usuario, desarrollo de interfaces modernas y adaptación multiplataforma.

## Objetivos de Aprendizaje

- **Diseño centrado en el usuario**: Aplicación de principios de usabilidad y accesibilidad
- **Desarrollo multiplataforma**: Implementación en diferentes tecnologías según requisitos del proyecto
- **Arquitecturas modernas**: Utilización de patrones MVP y gestión de estado
- **APIs y servicios web**: Integración con servicios externos para funcionalidades dinámicas

## Proyectos Desarrollados

### 1. Aplicación de Gestión de Cócteles (Python + GTK)
- **Framework**: Python con interfaz gráfica GTK
- **Arquitectura**: Patrón MVP (Model-View-Presenter)
- **Funcionalidades**:
  - Búsqueda y exploración de cócteles mediante API externa
  - Gestión de favoritos con persistencia local
  - Interfaz multiidioma (internacionalización)
  - Manejo asíncrono de peticiones HTTP

**Tecnologías clave:**
- Python para lógica de negocio
- GTK para interfaz gráfica nativa
- API REST (thecocktaildb.com)
- Requests para comunicación HTTP
- Gettext para internacionalización

### 2. Conversor de Divisas (Flutter)
- **Framework**: Flutter para desarrollo multiplataforma
- **Gestión de estado**: Provider pattern
- **Funcionalidades**:
  - Conversión en tiempo real entre múltiples divisas
  - Diseño responsivo (móvil y tablet)
  - Sistema de favoritos con persistencia
  - Validación de entrada y manejo de errores

**Tecnologías clave:**
- Dart/Flutter para desarrollo móvil
- Provider para gestión de estado
- HTTP package para API calls
- SharedPreferences para almacenamiento local
- Material Design 3

### 3. Aplicación Web de Agenda (HTML5 + JavaScript)
- **Tecnología**: Vanilla JavaScript con HTML5
- **Funcionalidades**:
  - Gestión completa de tareas (CRUD)
  - Almacenamiento local con localStorage
  - Filtrado avanzado (activas, completadas, todas)
  - Interfaz accesible con ARIA labels
  - Diseño responsivo con CSS3

**Tecnologías clave:**
- HTML5 semántico
- CSS3 con diseño responsivo
- JavaScript ES6+ para lógica de aplicación
- LocalStorage para persistencia
- Accesibilidad web (WCAG)

##  Competencias Técnicas Demostradas

### Desarrollo Frontend
- **Frameworks**: Flutter, GTK (Python), HTML5/CSS3/JavaScript
- **Patrones de diseño**: MVP, Provider, Responsive Design
- **APIs**: Integración con servicios REST externos
- **Persistencia**: LocalStorage, SharedPreferences, gestión de estado

### Experiencia de Usuario (UX/UI)
- **Diseño responsivo**: Adaptación automática a diferentes dispositivos
- **Accesibilidad**: Implementación de estándares WCAG y ARIA
- **Internacionalización**: Soporte multiidioma
- **Usabilidad**: Interfaces intuitivas y feedback al usuario

### Arquitectura de Software
- **Separación de responsabilidades**: Implementación del patrón MVP
- **Gestión de estado**: Utilización de Provider pattern en Flutter
- **Modularidad**: Código organizado y mantenible
- **Manejo de errores**: Validación robusta y feedback apropiado

## Estructura del Proyecto

```
3 Año/Interfaz_Persona_Máquina/
├── ipm-2324-p1-grupo_21-main/     # Aplicación Python + GTK
│   ├── app.py                      # Punto de entrada
│   ├── model.py                    # Lógica de datos y API
│   ├── view.py                     # Interfaz gráfica GTK
│   └── presenter.py                # Controlador MVP
├── ipm-2324-p2-grupo21-main/       # Aplicación Flutter
│   ├── lib/main.dart               # Aplicación principal
│   ├── lib/conversions.dart        # Modelo de conversiones
│   └── pubspec.yaml                # Dependencias Flutter
└── ipm-2324-p3-grupo-71-main/      # Aplicación Web
    ├── src/index.html              # Interfaz web
    └── src/css/                    # Estilos responsivos
```

## Tecnologías y Herramientas

| Categoría | Tecnologías |
|-----------|-------------|
| **Lenguajes** | Python, Dart, JavaScript, HTML5, CSS3 |
| **Frameworks** | Flutter, GTK |
| **APIs** | REST APIs, HTTP clients |
| **Arquitectura** | MVP, Provider pattern |
| **Persistencia** | LocalStorage, SharedPreferences |
| **UI/UX** | Material Design, Responsive Design, ARIA |

## Logros Destacados

- **Desarrollo multiplataforma**: Experiencia en 3 stacks tecnológicos diferentes
- **Integración de APIs**: Implementación robusta de servicios web externos
- **Diseño inclusivo**: Aplicación de principios de accesibilidad universal
- **Arquitecturas escalables**: Utilización de patrones de diseño profesionales
- **Experiencia de usuario**: Interfaces intuitivas con feedback apropiado

Este conjunto de proyectos demuestra versatilidad técnica y comprensión profunda de los principios de desarrollo de interfaces modernas, preparando para roles en frontend development, mobile development y UX/UI design.
