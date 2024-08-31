import 'package:calculator/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String input = "";
  String output = "0";

  List<String> values = [
    "(",
    ")",
    "log",
    "ln",
    "deg",
    "sin",
    'C',
    'D',
    '*',
    '-',
    "cos",
    '7',
    '8',
    '9',
    '%',
    "tan",
    '4',
    '5',
    '6',
    '/',
    "√",
    '1',
    '2',
    '3',
    '+',
    "π",
    '.',
    '0',
    'e',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  value.changeTheme();
                },
                icon: value.isToggle
                    ? const Icon(Icons.nightlight_outlined)
                    : const Icon(Icons.sunny),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    output,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 45,),
              Expanded(
                flex: 2,
                child: GridView.builder(
                  itemCount: values.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (_, int index) {
                    return customButton(values[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget customButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Transform.rotate(
        angle: 45 * 3.1415927 / 180,
        child: InkWell(
          onTap: () {
            setState(() {
              calculation(text);
            });
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: getBackground(text),
            ),
            child: Center(
              child: Transform.rotate(
                angle: -45 * 3.1415927 / 180,
                child: Text(
                  text,
                  style: TextStyle(color: textColor(text), fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void calculation(String text) {
    if (text == "C") {
      input = "";
      output = "0";
      return;
    }
    if (text == "D") {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
      if (input.isEmpty) {
        output = "0";
      } else {
        output = input;
      }
      return;
    }
    if (text == "=") {
      calculated();
      return;
    }
    if (text == "π") {
      input += "3.141592653589793";
      output = input;
      return;
    }
    if (text == "e") {
      input += "2.718281828459045";
      output = input;
      return;
    }
    input += text;
    output = input;
  }

  void calculated() {
    try {
      String finalInput = input.replaceAll('sin', 'sin(')
          .replaceAll('cos', 'cos(')
          .replaceAll('tan', 'tan(')
          .replaceAll('√', 'sqrt(')
          .replaceAll('log', 'log(')
          .replaceAll('ln', 'ln(')
          .replaceAll('deg', 'deg(')
          .replaceAll(')', '))');

      // Correct the format by adding a closing parenthesis after each function
      finalInput = finalInput.replaceAllMapped(
          RegExp(r'(sin|cos|tan|sqrt|log|ln|deg)\(([^)]+)'),
              (Match m) => '${m[1]}(${m[2]})');

      var exp = Parser().parse(finalInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      output = evaluation.toString();
      input = output; // update input to show the evaluated result
    } catch (e) {
      output = "Error";
    }
  }

  Color textColor(String text) {
    if (text == "C" ||
        text == "+" ||
        text == "=" ||
        text == "log" ||
        text == "ln" ||
        text == "deg" ||
        text == "sin" ||
        text == "√" ||
        text == "e" ||
        text == "cos" ||
        text == "tan" ||
        text == "%" ||
        text == "D" ||
        text == "-" ||
        text == "/" ||
        text == "*" ||
        text == ")" ||
        text == "(" ||
        text == "+") {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Color getBackground(String text) {
    if (text == "C" ||
        text == "+" ||
        text == "=" ||
        text == "log" ||
        text == "ln" ||
        text == "deg" ||
        text == "sin" ||
        text == "√" ||
        text == "e" ||
        text == "cos" ||
        text == "tan" ||
        text == "%" ||
        text == "D" ||
        text == "-" ||
        text == "/" ||
        text == "*" ||
        text == ")" ||
        text == "(" ||
        text == "π" ||
        text == "+") {
      return Colors.deepOrange;
    } else {
      return Colors.blueGrey;
    }
  }
}
