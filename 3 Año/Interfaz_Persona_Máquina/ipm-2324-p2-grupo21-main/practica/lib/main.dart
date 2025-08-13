import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'conversions.dart';
import 'favoritos.dart';

void main() {
  print('La aplicación está comenzando...');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Conversion()),
        ChangeNotifierProvider(create: (_) => Favoritos()),
      ],
      child: const ResponsiveApp(),
    ),
  );
}

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = Device.get().isTablet;

    return isTablet ? const TabletApp() : const MobileApp();
  }
}

class MobileApp extends StatelessWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThE CoNvErSiOn ApP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationBar(),
    );
  }
}

class TabletApp extends StatelessWidget {
  const TabletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversion APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FavoritesAndConversions(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThE CoNvErSiOn ApP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _getActualWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getActualWidget() {
    switch (_currentIndex) {
      case 0:
        return const MyHomePage(title: 'Converter Coin');
      case 1:
        return const Favorites();
      default:
        return const MyHomePage(title: 'Converter Coin');
    }
  }
}
class FavoritesAndConversions extends StatelessWidget {
  const FavoritesAndConversions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: MyHomePage(title: 'Converter Coin'),
          ),
          Expanded(
            flex: 1,
            child: Favorites(),
          ),
        ],
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _currencies = [
    const DropdownMenuItem(value: 'EUR', child: Text('EUR')),
    const DropdownMenuItem(value: 'USD', child: Text('USD')),
    const DropdownMenuItem(value: 'JPY', child: Text('JPY')),
    const DropdownMenuItem(value: 'DKK', child: Text('DKK')),
    const DropdownMenuItem(value: 'GBP', child: Text('GBP')),
    const DropdownMenuItem(value: 'SEK', child: Text('SEK')),
    const DropdownMenuItem(value: 'CHF', child: Text('CHF')),
    const DropdownMenuItem(value: 'NOK', child: Text('NOK')),
    const DropdownMenuItem(value: 'RUB', child: Text('RUB')),
    const DropdownMenuItem(value: 'TRY', child: Text('TRY')),
    const DropdownMenuItem(value: 'AUD', child: Text('AUD')),
    const DropdownMenuItem(value: 'BRL', child: Text('BRL')),
    const DropdownMenuItem(value: 'CAD', child: Text('CAD')),
    const DropdownMenuItem(value: 'CNY', child: Text('CNY')),
    const DropdownMenuItem(value: 'INR', child: Text('INR')),
    const DropdownMenuItem(value: 'MXN', child: Text('MXN')),
    const DropdownMenuItem(value: 'ZAR', child: Text('ZAR')),
  ];

  String initialCurrencyTo = 'USD';

  final _textController = TextEditingController();

  void createErrorWindow(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(error),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void pressedButton(BuildContext context) async {
    if (_textController.text.isEmpty) {
      createErrorWindow(context, 'Enter an amount');
      return;
    }

    final int? parsedAmount = int.tryParse(_textController.text);

    if (parsedAmount == null || parsedAmount <= 0) {
      createErrorWindow(
          context, 'Enter a valid amount (integer greater than 0)');
      return;
    }

    // Muestra el diálogo de carga
    showLoadingDialog(context);

    final conversionProvider = Provider.of<Conversion>(context, listen: false);
    final favoritosProvider = Provider.of<Favoritos>(context, listen: false);

    // Captura el contexto antes de la operación asíncrona
    final currentContext = context;

    // Almacena el Navigator en una variable antes de la operación asíncrona
    final navigator = Navigator.of(context);

    try {
      // Cambia la cantidad actual en conversionProvider y favoritosProvider
      await Future.wait([
        conversionProvider.changeCurrentAmount(parsedAmount, currentContext),
        favoritosProvider.changeAmountFavoritos(parsedAmount, currentContext),
      ]);

      // Cierra el diálogo de carga después de la operación
      // Usa el Navigator almacenado en lugar del BuildContext
      navigator.pop();

      // Limpia el controlador de texto
      _textController.clear();
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la operación
      print('Error: $e');
      // Aquí puedes mostrar un mensaje de error si es necesario

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: _buildLayout(),
    );
  }

  Widget _buildLayout() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
              SizedBox(
                height: 64,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            key: const ValueKey('textFormField'),
                            controller: _textController,
                            onFieldSubmitted: (ok) {
                              pressedButton(context);
                            },
                            decoration: InputDecoration(
                              labelText: 'AMOUNT',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              hintText: '1',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.black, width: 3,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.blue, width: 3,
                                ),
                              ),
                              suffixIcon: IconButton(
                                key: const ValueKey('convertButton'),
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () async {
                                  pressedButton(context);
                                },
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonFormField(
                            key: const ValueKey('dropdownFrom'),
                            decoration: InputDecoration(
                              labelText: 'FROM',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.black, width: 3,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.blue, width: 3,),
                              ),
                            ),
                            value: Provider
                                .of<Conversion>(context, listen: false)
                                .currentOrigin,
                            items: _currencies,
                            onChanged: (newCurrency) async {
                              if (Provider.of<Conversion>(
                                  context, listen: false).isValidOrigin(
                                  newCurrency!)) {
                                // Llama a la función que muestra el spinner
                                showLoadingDialog(context);

                                // Llama a la función para cambiar el origen actual
                                final conversionProvider = Provider.of<
                                    Conversion>(context, listen: false);
                                final favoritosProvider = Provider.of<
                                    Favoritos>(context, listen: false);

                                // Captura el contexto antes de la operación asíncrona
                                final currentContext = context;

                                // Almacena el Navigator en una variable antes de la operación asíncrona
                                final navigator = Navigator.of(context);

                                try {
                                  await Future.wait([
                                    conversionProvider.changeCurrentOrigin(
                                        newCurrency, currentContext),
                                    favoritosProvider.changeOriginFavoritos(
                                        newCurrency, currentContext),
                                  ]);

                                  // Cierra el spinner después de que la operación haya finalizado
                                  if (context.mounted) {
                                    navigator.pop();
                                  }
                                } catch (e) {
                                  // Manejar cualquier error que pueda ocurrir durante la operación
                                  print('Error: $e');
                                  // Aquí puedes mostrar un mensaje de error si es necesario
                                }
                              } else {
                                createErrorWindow(context,
                                    'Origin must be different than destiny');
                              }
                            },


                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.swap_vertical_circle,),


                      const SizedBox(height: 10,),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 75,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Provider
                                    .of<Conversion>(context)
                                    .conversions
                                    .length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      ElevatedButton.icon(
                                        key: const ValueKey('FavoritosButton'),
                                        label: const Text(''),
                                        icon: const Icon(Icons.favorite),
                                        onPressed: () {
                                          print('Botón TO presionado');
                                          int lastIndex = Provider
                                              .of<Conversion>(
                                              context, listen: false)
                                              .conversions
                                              .length - 1;
                                          print('Último índice: $lastIndex');

                                          if (lastIndex >= 0) {
                                            String currencyToAdd = Provider.of<
                                                Conversion>(
                                                context, listen: false)
                                                .getDestinationByIndex(
                                                lastIndex);

                                            var currentAmount = Provider
                                                .of<Conversion>(
                                                context, listen: false)
                                                .currentAmount;
                                            var currentOrigin = Provider
                                                .of<Conversion>(
                                                context, listen: false)
                                                .currentOrigin;

                                            print(
                                                'Cantidad actual: $currentAmount, Origen: $currentOrigin, Añadida moneda a favoritos: $currencyToAdd');

                                            // Obtener la instancia de Favoritos
                                            Favoritos favoritosProvider = Provider
                                                .of<
                                                Favoritos>(
                                                context, listen: false);

                                            // Verificar si ya existe un elemento igual en la lista
                                            bool alreadyExists = favoritosProvider
                                                .favoritos.any((element) =>
                                            element.amount == currentAmount &&
                                                element.from == currentOrigin &&
                                                element.to == currencyToAdd &&
                                                element.result == Provider
                                                    .of<Conversion>(
                                                    context, listen: false)
                                                    .conversions[index].result);

                                            if (!alreadyExists) {
                                              // Si no existe, agregar a favoritos
                                              favoritosProvider.addFavorites(
                                                  currentAmount, currentOrigin,
                                                  currencyToAdd, Provider
                                                  .of<Conversion>(
                                                  context, listen: false)
                                                  .conversions[index].result);
                                            } else {
                                              // Mostrar un SnackBar de error usando la función
                                              createErrorWindow(context,
                                                  'Esta moneda ya está en favoritos.');
                                            }
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: DropdownButtonFormField(
                                          key: const ValueKey('dropdownTo'),
                                          decoration: InputDecoration(
                                            labelText: 'TO',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                              borderSide: const BorderSide(
                                                color: Colors.black, width: 3,),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                              borderSide: const BorderSide(
                                                color: Colors.blue, width: 3,),
                                            ),
                                          ),
                                          value: Provider.of<Conversion>(
                                              context, listen: false)
                                              .getDestinationByIndex(
                                              index),
                                          items: _currencies,
                                          onChanged: (newCurrency) async {
                                            if (Provider.of<Conversion>(
                                                context, listen: false)
                                                .isValidDestination(
                                                newCurrency!)) {
                                              // Llama a la función que muestra el spinner
                                              showLoadingDialog(context);

                                              // Llama a la función para cambiar la moneda destino
                                              final conversionProvider = Provider
                                                  .of<Conversion>(
                                                  context, listen: false);
                                              final favoritosProvider = Provider
                                                  .of<Favoritos>(
                                                  context, listen: false);

                                              // Captura el contexto antes de la operación asíncrona
                                              final currentContext = context;

                                              // Almacena el Navigator en una variable antes de la operación asíncrona
                                              final navigator = Navigator.of(
                                                  context);

                                              try {
                                                await Future.wait([
                                                  conversionProvider
                                                      .changeDestination(
                                                      newCurrency,
                                                      currentContext),
                                                ]);

                                                // Cierra el spinner después de que la operación haya finalizado
                                                if (context.mounted) {
                                                  navigator.pop();
                                                }
                                              } catch (e) {
                                                // Manejar cualquier error que pueda ocurrir durante la operación
                                                print('Error: $e');
                                                // Aquí puedes mostrar un mensaje de error si es necesario
                                              }
                                            } else {
                                              createErrorWindow(context,
                                                  'Origin must be different than destiny');
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: Provider
                                      .of<Conversion>(context)
                                      .conversions
                                      .length,
                                  itemBuilder: (context, index) {
                                    var currentAmount = Provider
                                        .of<Conversion>(context)
                                        .currentAmount;
                                    var currentOrigin = Provider
                                        .of<Conversion>(context)
                                        .currentOrigin;
                                    var conversion = Provider
                                        .of<Conversion>(context)
                                        .conversions
                                        .elementAt(index);

                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$currentAmount $currentOrigin = ${conversion
                                            .result.toStringAsFixed(
                                            2)} ${conversion.to}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}



class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritos = Provider.of<Favoritos>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: favoritos.favoritos.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            favoritos.favoritos[index].to,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              favoritos.deleteFavorites(favoritos.favoritos[index]);
                            },
                          ),
                          onTap: () {
                            // Implementa la lógica cuando se toca un elemento de la lista
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${favoritos.favoritos[index].amount} ${favoritos.favoritos[index].from} = ${favoritos.favoritos[index].result} ${favoritos.favoritos[index].to}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//