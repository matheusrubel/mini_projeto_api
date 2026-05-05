import 'package:flutter/material.dart';
import '../models/senha_model.dart';
import '../services/invertexto_service.dart';

enum SenhaStatus { idle, loading, success, error }

class SenhaProvider extends ChangeNotifier {
  final InvertextoService _service = InvertextoService();

  SenhaStatus _status = SenhaStatus.idle;
  SenhaModel? _resultado;
  String _errorMessage = '';

  int _tamanho = 16;
  bool _letrasMinusculas = true;
  bool _letrasMaiusculas = true;
  bool _numeros = true;
  bool _simbolos = false;

  SenhaStatus get status => _status;
  SenhaModel? get resultado => _resultado;
  String get errorMessage => _errorMessage;
  int get tamanho => _tamanho;
  bool get letrasMinusculas => _letrasMinusculas;
  bool get letrasMaiusculas => _letrasMaiusculas;
  bool get numeros => _numeros;
  bool get simbolos => _simbolos;

  void setTamanho(int tamanho) {
    _tamanho = tamanho;
    notifyListeners();
  }

  void toggleLetrasMinusculas() {
    _letrasMinusculas = !_letrasMinusculas;
    notifyListeners();
  }

  void toggleLetrasMaiusculas() {
    _letrasMaiusculas = !_letrasMaiusculas;
    notifyListeners();
  }

  void toggleNumeros() {
    _numeros = !_numeros;
    notifyListeners();
  }

  void toggleSimbolos() {
    _simbolos = !_simbolos;
    notifyListeners();
  }

  Future<void> gerarSenha() async {
    if (!_letrasMinusculas && !_letrasMaiusculas && !_numeros && !_simbolos) {
      _errorMessage = 'Selecione pelo menos um tipo de caractere.';
      _status = SenhaStatus.error;
      notifyListeners();
      return;
    }

    _status = SenhaStatus.loading;
    _resultado = null;
    _errorMessage = '';
    notifyListeners();

    try {
      _resultado = await _service.gerarSenha(
        tamanho: _tamanho,
        letrasMinusculas: _letrasMinusculas,
        letrasMaiusculas: _letrasMaiusculas,
        numeros: _numeros,
        simbolos: _simbolos,
      );
      _status = SenhaStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = SenhaStatus.error;
    }

    notifyListeners();
  }

  void resetar() {
    _status = SenhaStatus.idle;
    _resultado = null;
    _errorMessage = '';
    notifyListeners();
  }
}
