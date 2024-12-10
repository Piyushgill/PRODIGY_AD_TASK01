import 'package:flutter/material.dart';
void main(){
  runApp(myapp());
}
class myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: calculatorapp(),
    );
  }
}
class calculatorapp extends StatefulWidget{
  @override
  _calculatorappState createState()=> _calculatorappState();
}
class _calculatorappState extends State<calculatorapp>{
  TextEditingController inputController =TextEditingController();
  String operator='';
  double? firstnumber;
  String result='';
  bool isDecimalUsed = false;
  void onNumberPressed(String number){
    setState(() {
      if(result.isNotEmpty){
        inputController.clear();
        result='';
      }
      inputController.text += number;
    });
  }
  void onoperatorpressed(String op){
    setState(() {
      if(firstnumber == null){
        firstnumber=double.tryParse(inputController.text)??0.0;
        operator=op;
        inputController.clear();
      }
      else {
        double secondnumber = double.tryParse(inputController.text) ?? 0.0;
        switch (operator) {
          case '+':
            firstnumber = firstnumber! + secondnumber;
            break;
          case '-':
            firstnumber = firstnumber! - secondnumber;
            break;
          case '*':
            firstnumber = firstnumber! * secondnumber;
            break;
          case '/':
            if (secondnumber != 0) {
              firstnumber = firstnumber! / secondnumber;
            }
            else {
              firstnumber = double.nan;
            }
            break;
          case '%':
            firstnumber=firstnumber!*secondnumber/100;
            break;
        }
        inputController.clear();
        operator = op;
      }
    });
  }
  void calculate(){
    double secondnumber =double.tryParse(inputController.text)??0.0;
    setState(() {
      if(result.isNotEmpty){
        firstnumber=double.tryParse(result)??0.0;
        result=(firstnumber!*2).toString();
        inputController.text=result;
      }
      else {
        switch (operator) {
          case '+':
            result = (firstnumber! + secondnumber).toString();
            break;
          case '-':
            result = (firstnumber! - secondnumber).toString();
            break;
          case '*':
            result = (firstnumber! * secondnumber).toString();
            break;
          case '/':
            result = secondnumber != 0
                ? (firstnumber! / secondnumber).toString()
                : 'Error: Division by 0';
            break;
          case '%':
            result = (firstnumber! * secondnumber / 100).toString();
            break;
          default:
            result = 'Invalid operation';
        }
        firstnumber = double.tryParse(result) ?? 0.0;
        operator = '';
        inputController.clear();
        inputController.text = result;
      }
    });
  }
  void eraselastcharacter(){
    setState(() {
      inputController.text=inputController.text.isNotEmpty?inputController.text.substring(0, inputController.text.length - 1)
          : '';
    });
  }
  void clearall(){
    setState(() {
      inputController.clear();
      firstnumber=null;
      operator='';
      result='';
      isDecimalUsed = false;
    });
  }
  void onDecimalPressed() {
    setState(() {
      if (!isDecimalUsed) {
        inputController.text += '.';
        isDecimalUsed = true;
      }
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black,
      body: Padding(padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: inputController,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Enter the number',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 32, color: Colors.white),
                maxLines: null,
                minLines: 1,
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: GridView.count(crossAxisCount: 4,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              padding: EdgeInsets.all(10),
              children: [buildClearButton(),
                buildEraseButton(),
                ...['%','/'].map((button) => buildOperatorButton(button)),
                ...['7', '8', '9', '*'].map((button) => buildButton(button)),
                ...['4', '5', '6', '-'].map((button) => buildButton(button)),
                ...['1', '2', '3', '+'].map((button) => buildButton(button)),
                ...['00', '0', '.', '='].map((button) => buildButton(button)),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildButton(String label){
    return ElevatedButton(onPressed: (){
      if (label == '=') {
        calculate();
      }
      else if
      (['+', '-', '*', '/'].contains(label)) {
        onoperatorpressed(label);
      }
      else
      {
        onNumberPressed(label);
      }
    },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        backgroundColor: Colors.white,
      ),
      child: Text(label, style: TextStyle(fontSize: 24)),
    );
  }
  Widget buildOperatorButton(String label) {
    return ElevatedButton(
      onPressed: () {
        onoperatorpressed(label);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        backgroundColor: Colors.orange,
      ),
      child: Text(label, style: TextStyle(fontSize: 24, color: Colors.white)),
    );
  }
  Widget buildEraseButton(){
    return Expanded(child: IconButton(onPressed: eraselastcharacter, icon: Icon(Icons.backspace,size: 30,color: Colors.white),),);
  }
  Widget buildClearButton(){
    return ElevatedButton(
      onPressed: clearall,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(20),
      ),
      child: Text('C',style: TextStyle(fontSize: 24)),

    );
  }
}