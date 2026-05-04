import 'package:flutter/material.dart';
import '../models/moeda_model.dart';
import '../services/invertexto_service.dart';

enum MoedaStatus { idle, loading, success, error }

class MoedaProvider extends ChangeNotifier {
  final InvertextoService _service = InvertextoService();

  MoedaStatus _status = MoedaStatus.idle;
  List<MoedaModel> _cotacoes = [];
  String _errorMessage = '';

  MoedaStatus get status => _status;
  List<MoedaModel> get cotacoes => _cotacoes;
  String get errorMessage => _errorMessage;

  final List<Map<String, String>> moedasDisponiveis = [
    {'sigla': 'USD', 'nome': 'Dólar Americano', 'emoji': '🇺🇸'},
    {'sigla': 'EUR', 'nome': 'Euro', 'emoji': '🇪🇺'},
    {'sigla': 'GBP', 'nome': 'Libra Esterlina', 'emoji': '🇬🇧'},
    {'sigla': 'ARS', 'nome': 'Peso Argentino', 'emoji': '🇦🇷'},
    {'sigla': 'BTC', 'nome': 'Bitcoin', 'emoji': '₿'},
  ];

  List<String> _selecionadas = ['USD', 'EUR'];
  List<String> get selecionadas => _selecionadas;

  void toggleMoeda(String sigla) {
    if (_selecionadas.contains(sigla)) {
      if (_selecionadas.length > 1) _selecionadas.remove(sigla);
    } else {
      _selecionadas.add(sigla);
    }
    notifyListeners();
  }

  Future<void> buscarCotacoes() async {
    _status = MoedaStatus.loading;
    _cotacoes = [];
    _errorMessage = '';
    notifyListeners();

    try {
      _cotacoes = await _service.getCotacoes(_selecionadas);
      _status = MoedaStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = MoedaStatus.error;
    }
    notifyListeners();
  }
}
