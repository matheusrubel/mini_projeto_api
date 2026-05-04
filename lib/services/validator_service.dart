import 'dart:convert';

import 'package:http/http.dart' as http;

class ValidatorService {
  static String token = "25975|UYnxxcoqC6krIsXSDsDmPiksVUfdomdU";


  static Future<bool> validateCPF(String cpf) async{
    try{
      final response = await http.get(
        Uri.parse("https://api.invertexto.com/v1/validator?token=$token&value=$cpf&type=cpf"),
      );
      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['valid'];
      }else{
        return false;
      }


    }catch(e){
      print("Erro Validator API: $e");
      return false;

    }
  }

  static Future<bool> validateCNPJ(String cnpj) async{
    try{
      final response = await http.get(
        Uri.parse("https://api.invertexto.com/v1/validator?token=$token&value=$cnpj&type=cnpj"),
      );
      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['valid'];
      }else{
        return false;
      }


    }catch(e){
      print("Erro Validator API: $e");
      return false;

    }
  }




}