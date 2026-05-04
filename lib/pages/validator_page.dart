import 'package:api_alunos/services/validator_service.dart';
import 'package:flutter/material.dart';

class ValidatorPage extends StatefulWidget {
  const ValidatorPage({super.key});

  @override
  State<ValidatorPage> createState() => _ValidatorPageState();
}

class _ValidatorPageState extends State<ValidatorPage> {
  final TextEditingController controller = TextEditingController();

  String result = "";

  Future<void> validate() async {
    final value = controller.text;

    final isValid = await ValidatorService.validateCPF(value);

    setState(() {
      result = isValid ? "Cpf Válido" : "Cpf Invalido";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          "Validador de CPF",
          style: TextStyle(color: Colors.grey[100]),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.verified, size: 60, color: Colors.pinkAccent),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Digite o CPF",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: validate,
                    label: Text("Validar"),
                    icon: Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
