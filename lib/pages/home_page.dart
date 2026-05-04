import 'package:api_alunos/pages/person_page.dart';
import 'package:api_alunos/pages/validator_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          "App Invertexto",
          style: TextStyle(color: Colors.grey[100]),
        ),
        centerTitle: true,
        elevation: 2,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bem-vindo ao App Invertexto!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Escolha uma opção abaixo',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> PersonPage(),
                ));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.pinkAccent[100], size: 40),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        "Gerar Pessoa",
                        style: TextStyle(
                          color: Colors.pinkAccent[100],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent[100])
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ValidatorPage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: Colors.pinkAccent[100], size: 40),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        "Validar CPF",
                        style: TextStyle(
                          color: Colors.pinkAccent[100],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent[100])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
