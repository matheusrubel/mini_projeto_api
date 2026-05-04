import 'dart:convert';

import 'package:http/http.dart' as http;

class PersonService {
  static const String token ="25975|UYnxxcoqC6krIsXSDsDmPiksVUfdomdU";

  static Future<Map<String, dynamic>?> generatePerson() async{
    try{
      final response = await http.get(
        Uri.parse(
          "https://api.invertexto.com/v1/faker?token=$token&fields=name,cpf&locale=pt_BR"
          ),
      );

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        throw Exception("Erro ao gerar pessoa");
      }
    }catch(e){
      print("Erro PERSON API: $e");
      return null;

    }
  }

}