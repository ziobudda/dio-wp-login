import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class LoggedScreen extends StatelessWidget {
  LoggedScreen({super.key});

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final SharedPreferences prefs;

  Future getPrefs() async {
    prefs = await _prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoggedScreen'),
      ),
      body: FutureBuilder(
          future: getPrefs(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.connectionState.name);

            if (snapshot.connectionState.name == 'done') {
              return Center(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(prefs.getString('token').toString())),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(prefs.getString('user_email').toString())),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child:
                            Text(prefs.getString('user_nicename').toString())),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                            prefs.getString('user_display_name').toString())),
                    ElevatedButton(
                      onPressed: () async {
                        final SharedPreferences prefs = await _prefs;
                        prefs.remove('token');
                        prefs.remove('user_email');
                        prefs.remove('user_nicename');
                        prefs.remove('user_display_name');

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                        // Navigate back to first route when tapped.
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            }
            return Text("Loading prefs...");
          }),
    );
  }
}
