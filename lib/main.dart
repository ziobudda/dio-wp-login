import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'settings.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logged_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        //generateMaterialColorFromColor(Color.fromRGBO(94, 92, 0, 39)),
        hintColor: Colors.blue[200],
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool doLogin = false;
  String _errorMsg = '';
  double windowWidth = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
    print("dentro build main");
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    AppBar appBar = AppBar(
      title: Text('Login w/DIO in WP'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //WindowSizeTexts(),
                //SizedBox(height: 20),
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
                LoginButton(),
                ErrorMsg(),
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
    );
  }

  Widget LoginButton() {
    return (!doLogin)
        ? Center(
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal:
                    (MediaQuery.of(context).size.width > 300) ? 100 : 10,
              ),
            ),
            onPressed: () async {
              setState(() {
                doLogin = true;
              });
              try {
                final response = await login();
                final SharedPreferences prefs = await _prefs;
                prefs.setString('token', response['token']);
                prefs.setString('user_email', response['user_email']);
                prefs.setString('user_nicename', response['user_nicename']);
                prefs.setString(
                    'user_display_name', response['user_display_name']);

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        LoggedScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              } on DioError catch (e) {
                var doc = parse(e.response?.data['message']);
                String parsedstring = doc.documentElement!.text;
                setState(() {
                  _errorMsg = parsedstring;
                  doLogin = false;
                });
              }
              setState(() {
                doLogin = false;
              });
            },
            child: Text('Login'),
          ))
        : Center(child: Text('In login...'));
  }

  Widget ErrorMsg() {
    if (_errorMsg != '') {
      return Column(children: [
        SizedBox(
          height: 20,
        ),
        Text(_errorMsg,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(
          height: 20,
        ),
      ]);
    } else {
      return SizedBox(
        height: 0,
      );
    }
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

  Future login() async {
    setState(() {
      _errorMsg = '';
    });

    var dio = Dio();
    final response = await dio.post(Settings.mainUrl +
        "jwt-auth/v1/token?username=" +
        usernameController.text.toString() +
        "&password=" +
        passwordController.text.toString());
    return response.data;
  }
}
