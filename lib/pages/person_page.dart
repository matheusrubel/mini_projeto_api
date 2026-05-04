import 'package:api_alunos/services/person_service.dart';
import 'package:flutter/material.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  Map<String, dynamic>? person;
  bool isLoading = false;

  Future<void> fetchPerson() async {
    setState(() {
      isLoading = true;
    });

    final result = await PersonService.generatePerson();

    setState(() {
      person = result;
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    fetchPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          "Gerador de Pessoa",
          style: TextStyle(color: Colors.grey[100]),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : person == null
            ? Text("Erro ao carregar")
            : Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
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
                          Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.pinkAccent,
                          ),
                          SizedBox(height: 20),
                          Text(
                            person?["name"] ?? "Sem nome",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text("CPF: ${person?['cpf'] ?? '-'}"),
                          Text("Email: ${person?['email'] ?? '-'}"),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: fetchPerson,
                      icon: Icon(Icons.refresh),
                      label: Text("Gerar novamente"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
