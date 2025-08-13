# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:

```
-->
```mermaid
classDiagram
  class ChangeNotifierProvider {
  }

  class ChangeNotifier {
  }

  class MyApp {
  }

  class MyHomePage {
    -Title : String
  }

  class MyHomePageStage {
    -controller : var
    -currencies : var
    -values : var
    -favorites : List<String>
  }

  class FavoritosInfo {
    - Amount : int
    - From : String
    - To : String 
    - Result : double
  }

  class ConversionInfo {
    - To : String 
    - Result : double
  }

  class Conversion {
    -CurrentAmount : double
    -CurrentOrigin : String
    -Conversions : List<Conversion>
    +getCurrentAmount(): int
    +setCurrentAmount(value): void
    +getCurrentOrigin(): String
    +setCurrentOrigin(value): void
    +changeCurrentAmount(int newAmount, BuildContext context): void
    +changeCurrentOrigin(String newOrigin, BuildContext context): void
    +isValidOrigin(String newOrigin): bool
    +isValidDestination(String newDestination): bool
    +changeDestination(String destination, int index): void
    +getDestinationByIndex(int index): String
  }

  class Favoritos {
    -favorites : List<String>
    +getFavorites(): List<String>
    +addFavorite(int amount, String from, String to, double result): void
    +deleteFavorites(FavoritosInfo conversionInfo): void
  }

  class Model {
    +getConversion(String Origin, String Destination, int amount): double
    +createErrorWindow(BuildContext context, String error)
  }

  Model -- MyApp
  ChangeNotifierProvider o-- MyApp
  MyApp o-- MyHomePage

  MyHomePage o-- MyHomePageStage

  MyHomePageStage o-- Conversion
  MyHomePageStage o-- Favoritos

  Conversion --|> ChangeNotifier
  Favoritos --|> ChangeNotifier

  ConversionInfo -- Conversion
  FavoritosInfo -- Favoritos

  Model -- Conversion
  Model -- Favoritos

```
-->

```mermaid
sequenceDiagram
  participant MyApp
  participant ChangeNotifierProvider
  participant MyHomePage
  participant MyHomePageStage
  participant Conversion
  participant Favoritos
  participant Model
  participant API

  MyApp ->> ChangeNotifierProvider: create
  ChangeNotifierProvider ->> MyApp: instance
  MyApp ->> MyHomePage: create
  MyHomePage ->> MyHomePageStage: create
  MyHomePageStage ->> Conversion: create
  MyHomePageStage ->> Favoritos: create
  MyApp ->> Model: create
  MyApp ->> API: create

  MyHomePageStage ->> Conversion: changeCurrentAmount(newAmount, context)
  Conversion ->> Conversion: setCurrentAmount(value)
  Conversion ->> Model: getConversion(CurrentOrigin, destination, newAmount)
  Model ->> API: makeRequest(origin, destination, amount)
  API -->> Model: response
  Model -->> Conversion: conversionResult
  Conversion ->> MyHomePageStage: updateUI(conversionResult)

  MyHomePageStage ->> Conversion: changeCurrentOrigin(newOrigin, context)
  Conversion ->> Conversion: setCurrentOrigin(value)
  Conversion ->> MyHomePageStage: updateUI()

  MyHomePageStage ->> Conversion: changeDestination(destination, index)
  Conversion ->> Conversion: changeDestination(destination, index)
  Conversion ->> MyHomePageStage: updateUI()

  MyHomePageStage ->> Favoritos: addFavorite(amount, CurrentOrigin, destination, conversionResult)
  Favoritos ->> Favoritos: addFavorite(amount, CurrentOrigin, destination, conversionResult)
  Favoritos ->> MyHomePageStage: updateFavoritesUI()

  MyHomePageStage ->> Favoritos: deleteFavorites(conversionInfo)
  Favoritos ->> Favoritos: deleteFavorites(conversionInfo)
  Favoritos ->> MyHomePageStage: updateFavoritesUI()

  Model ->> MyApp: createErrorWindow(context, error)
  MyApp ->> MyHomePageStage: showError(error)


    
```

