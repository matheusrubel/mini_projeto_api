import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cpf_model.dart';
import '../models/moeda_model.dart';
import '../models/fipe_model.dart';
import '../models/cep_model.dart';
import '../models/senha_model.dart';

class InvertextoService {
  static const String _baseUrl = 'https://api.invertexto.com/v1';

  // ⚠️ Gere seu token em: https://invertexto.com/api-token
  static const String _token = '26148|zlkdIubfY3zheQc95A4mm1g4VhCawOBZ';

  // ──────────────────────────────────────────────
  // CPF
  // ──────────────────────────────────────────────
  Future<CpfModel> validarCpf(String cpf) async {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    final uri =
        Uri.parse('$_baseUrl/validator?token=$_token&value=$cpfLimpo&type=cpf');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CpfModel(valido: json['valid'] ?? false, cpf: cpfLimpo);
    } else {
      throw Exception(
          'Erro ${response.statusCode}: token inválido ou CPF incorreto.');
    }
  }

  // ──────────────────────────────────────────────
  // Moedas
  // ──────────────────────────────────────────────
  Future<List<MoedaModel>> getCotacoes(List<String> moedas) async {
    final symbols = moedas.map((m) => '${m}_BRL').join(',');
    final uri = Uri.parse('$_baseUrl/currency/$symbols?token=$_token');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return body.entries
          .map((e) => MoedaModel.fromJson(e.key, e.value))
          .toList();
    } else {
      throw Exception('Erro ${response.statusCode}: falha ao buscar cotações.');
    }
  }

  // ──────────────────────────────────────────────
  // FIPE
  // ──────────────────────────────────────────────
  Future<List<FipeMarcaModel>> getFipeMarcas({int tipo = 1}) async {
    final uri = Uri.parse('$_baseUrl/fipe/brands/$tipo?token=$_token');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => FipeMarcaModel.fromJson(j)).toList();
    } else {
      throw Exception(
          'Erro ${response.statusCode}: falha ao buscar marcas FIPE.');
    }
  }

  Future<List<FipeModeloModel>> getFipeModelos(String brandId) async {
    final uri = Uri.parse('$_baseUrl/fipe/models/$brandId?token=$_token');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => FipeModeloModel.fromJson(j)).toList();
    } else {
      throw Exception(
          'Erro ${response.statusCode}: falha ao buscar modelos FIPE.');
    }
  }

  Future<List<FipeAnoModel>> getFipeAnos(String codigoFipe) async {
    final uri = Uri.parse('$_baseUrl/fipe/years/$codigoFipe?token=$_token');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => FipeAnoModel.fromJson(j)).toList();
    } else {
      throw Exception(
          'Erro ${response.statusCode}: código FIPE inválido ou não encontrado.');
    }
  }

  // ──────────────────────────────────────────────
  // CEP  →  GET /v1/cep/:cep?token=...
  // ──────────────────────────────────────────────
  Future<CepModel> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('$_baseUrl/cep/$cepLimpo?token=$_token');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json is Map && json.containsKey('message')) {
        throw Exception(json['message'] ?? 'CEP não encontrado.');
      }
      return CepModel.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('CEP não encontrado. Verifique os dígitos.');
    } else {
      throw Exception('Erro ${response.statusCode}: falha ao buscar CEP.');
    }
  }

  // ──────────────────────────────────────────────
  // Senha  →  GET /v1/password?token=...
  // ──────────────────────────────────────────────
  Future<SenhaModel> gerarSenha({
    required int tamanho,
    required bool letrasMinusculas,
    required bool letrasMaiusculas,
    required bool numeros,
    required bool simbolos,
  }) async {
    final uri = Uri.parse('$_baseUrl/password').replace(
      queryParameters: {
        'token': _token,
        'length': tamanho.toString(),
        'lowercase': letrasMinusculas ? '1' : '0',
        'uppercase': letrasMaiusculas ? '1' : '0',
        'numbers': numeros ? '1' : '0',
        'symbols': simbolos ? '1' : '0',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json is Map && json.containsKey('message')) {
        throw Exception(json['message'] ?? 'Erro ao gerar senha.');
      }
      return SenhaModel.fromJson(json);
    } else {
      throw Exception('Erro ${response.statusCode}: falha ao gerar senha.');
    }
  }
}
