import 'package:education_app/resources/exports.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _output = '0';

  final List<List<String>> buttons = [
    ['AC', '±', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '='],
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _output = '0';
      } else if (value == '±') {
        if (_output.isNotEmpty && _output != '0') {
          if (_output.startsWith('-')) {
            _output = _output.substring(1);
          } else {
            _output = '-$_output';
          }
          _expression = _output;
        }
      } else if (value == '=') {
        _output = _evaluateExpression(_expression);
        _expression = _output;
      } else {
        _expression += value;
        _output = _expression;
      }
    });
  }

  String _evaluateExpression(String expr) {
    try {
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression exp = parser.parse(expr);
      double result = exp.evaluate();
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width / 4.5;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(
          "Calculator",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.deepPurple,
                AppColors.lightPurple,
              ],
            ),
          ),
        ),

        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Text(
                _output,
                style: GoogleFonts.poppins(
                  fontSize: 60,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkText,
                  shadows: [
                    Shadow(
                      color: AppColors.greyOverlay70,
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            ...buttons.map((row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: row.map((text) {
                      return CalculatorButton(
                        text: text,
                        size: buttonSize,
                        isZero: text == '0',
                        color: _getButtonColor(text),
                        textColor: _getTextColor(text),
                        onTap: () => _onButtonPressed(text),
                      );
                    }).toList(),
                  ),
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(String text) {
    if (text == 'AC' || text == '±' || text == '%') {
      return Colors.white;
    } else if (text == '÷' ||
        text == '×' ||
        text == '-' ||
        text == '+' ||
        text == '=') {
      return AppColors.deepPurple;
    } else {
      return AppColors.surfaceColor;
    }
  }

  Color _getTextColor(String text) {
    if (text == 'AC' || text == '±' || text == '%') {
      return AppColors.primaryColor;
    } else if (text == '÷' ||
        text == '×' ||
        text == '-' ||
        text == '+' ||
        text == '=') {
      return Colors.white;
    } else {
      return AppColors.darkText;
    }
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final bool isZero;
  final double size;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.size,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.isZero = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isZero ? (size * 2) + 16 : size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.85),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(0, 6),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              offset: const Offset(-4, -4),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textColor,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: const Offset(0, 1),
                blurRadius: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Parser {
  Expression parse(String expr) {
    List<String> tokens = _tokenize(expr);
    List<String> rpn = _toRPN(tokens);
    return Expression(rpn);
  }

  List<String> _tokenize(String expr) {
    final tokens = <String>[];
    final buffer = StringBuffer();

    for (int i = 0; i < expr.length; i++) {
      final c = expr[i];
      if ('0123456789.'.contains(c)) {
        buffer.write(c);
      } else if ('+-*/'.contains(c)) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(c);
      }
    }
    if (buffer.isNotEmpty) tokens.add(buffer.toString());
    return tokens;
  }

  List<String> _toRPN(List<String> tokens) {
    final output = <String>[];
    final ops = <String>[];
    final prec = {'+': 1, '-': 1, '*': 2, '/': 2};

    for (var token in tokens) {
      if (double.tryParse(token) != null) {
        output.add(token);
      } else if ('+-*/'.contains(token)) {
        while (ops.isNotEmpty &&
            prec[ops.last] != null &&
            prec[ops.last]! >= prec[token]!) {
          output.add(ops.removeLast());
        }
        ops.add(token);
      }
    }
    while (ops.isNotEmpty) output.add(ops.removeLast());
    return output;
  }
}

class Expression {
  final List<String> rpn;

  Expression(this.rpn);

  double evaluate() {
    final stack = <double>[];

    for (var token in rpn) {
      if (double.tryParse(token) != null) {
        stack.add(double.parse(token));
      } else {
        double b = stack.removeLast();
        double a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
        }
      }
    }
    return stack.single;
  }
}
