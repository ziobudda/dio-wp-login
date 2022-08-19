import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Verdana',
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: buildMaterialColor(
          Color.fromARGB(217, 14, 25, 228),
        ),
        //generateMaterialColorFromColor(Color.fromRGBO(94, 92, 0, 39)),
        hintColor: Colors.blue[200],
      ),
      home: const MyHomePage(title: 'Login Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  double windowWidth = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    AppBar appBar = AppBar(
      title: Text(widget.title),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Center(
          heightFactor: 1 / 1,
          child: Container(
            height: MediaQuery.of(context).size.height -
                appBar.preferredSize.height,
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WindowSizeTexts(),
                  SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Email", //babel text
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(93, 93, 93, 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        controller: usernameController,
                        showCursor: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Password", //babel text
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(93, 93, 93, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        controller: passwordController,
                        showCursor: true,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: (MediaQuery.of(context).size.width > 300)
                            ? 100
                            : 10,
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Login'),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  (MediaQuery.of(context).size.width > 300)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: bottomLinks(false))
                      : Column(children: bottomLinks(true)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomLinks(addADivider) {
    return [
      GestureDetector(
        child: Text(
          'Perso la password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
        onTap: () {
          print("password");
        },
      ),
      (addADivider)
          ? Divider(
              height: 20,
            )
          : VerticalDivider(
              width: 0,
            ),
      GestureDetector(
        child: Text(
          'Registrati',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
        onTap: () {
          print("password");
        },
      ),
    ];
  }
}

class WindowSizeTexts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    print("dentro WindowSizeTexts build");
    return (MediaQuery.of(context).size.width > 300)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Window W: ${MediaQuery.of(context).size.width}"),
              Text("Window H: ${MediaQuery.of(context).size.height}"),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Window W: ${MediaQuery.of(context).size.width}"),
              Text("Window H: ${MediaQuery.of(context).size.height}"),
            ],
          );
  }
}
