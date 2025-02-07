import 'package:Calculator/splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(),
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
  var no1Controller = TextEditingController();
  var no2Controller = TextEditingController();
  var result = "";

  // Function to dismiss keyboard
  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // Function to perform calculations
  void calculate(String operation) {
    if (no1Controller.text.isEmpty || no2Controller.text.isEmpty) {
      setState(() {
        result = "Enter both numbers!";
      });
      return;
    }

    int? no1 = int.tryParse(no1Controller.text);
    int? no2 = int.tryParse(no2Controller.text);

    if (no1 == null || no2 == null) {
      setState(() {
        result = "Invalid input!";
      });
      return;
    }

    setState(() {
      if (operation == "Add") {
        result = "Sum: ${no1 + no2}";
      } else if (operation == "Subtract") {
        result = "Difference: ${no1 - no2}";
      } else if (operation == "Multiply") {
        result = "Product: ${no1 * no2}";
      } else if (operation == "Divide") {
        result = no2 == 0 ? "Cannot divide by zero!" : "Quotient: ${(no1 / no2).toStringAsFixed(2)}";
      }
    });
  }

  // Function to clear input fields
  void clearFields() {
    setState(() {
      no1Controller.clear();
      no2Controller.clear();
      result = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissKeyboard, // Dismiss keyboard on tap
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Calculator", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red, width: 1), // ✅ Red 3px Border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Number Input Fields
                          TextField(
                            controller: no1Controller,
                            decoration: InputDecoration(
                              labelText: "First Number",
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              // fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: no2Controller,
                            decoration: InputDecoration(
                              labelText: "Second Number",
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              // fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20),

                          // Buttons
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              buildButton("➕", "Add"),
                              buildButton("➖", "Subtract"),
                              buildButton("✖️", "Multiply"),
                              buildButton("➗", "Divide"),
                            ],
                          ),
                          
                          SizedBox(height: 10),

                          // Clear Button with Emoji
                          ElevatedButton(
                            onPressed: clearFields,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.red, width: 0), // ✅ Red Border
                              ),
                              backgroundColor: Colors.white.withOpacity(0.3),
                              elevation: 5,
                            ),
                            child: Text(
                              "AC", // ✅ AC emoji for clearing
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Animated Result Display
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),  // Animation duration
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Container(
                              key: ValueKey<String>(result),  // Key to trigger animation on result change
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                result,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button Builder
  Widget buildButton(String emoji, String operation) {
    return ElevatedButton(
      onPressed: () => calculate(operation),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // ✅ Beautiful Rounded Border
          side: BorderSide(color: Colors.white, width: 2), // ✅ White Border
          
        ),
        backgroundColor: Colors.white.withOpacity(0.3),
        
        elevation: 5,
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
