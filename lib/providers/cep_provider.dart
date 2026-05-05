import 'package:flutter/material.dart';
import '../models/cep_model.dart';
import '../services/invertexto_service.dart';

enum CepStatus { idle, loading, success, error }

class CepProvider extends ChangeNotifier {
  final InvertextoService _service = InvertextoService();

  CepStatus _status = CepStatus.idle;
  CepModel? _resultado;
  String _errorMessage = '';
  String _cepDigitado = '';

  CepStatus get status => _status;
  CepModel? get resultado => _resultado;
  String get errorMessage => _errorMessage;
  String get cepDigitado => _cepDigitado;

  void setCep(String cep) {
    _cepDigitado = cep;
    notifyListeners();
  }

  Future<void> buscarCep(String cep) async {
    if (cep.replaceAll(RegExp(r'[^0-9]'), '').length != 8) {
      _errorMessage = 'O CEP deve ter 8 dígitos.';
      _status = CepStatus.error;
      _resultado = null;
      notifyListeners();
      return;
    }

    _status = CepStatus.loading;
    _resultado = null;
    _errorMessage = '';
    notifyListeners();

    try {
      _resultado = await _service.buscarCep(cep);
      _status = CepStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = CepStatus.error;
    }

    notifyListeners();
  }

  void resetar() {
    _status = CepStatus.idle;
    _resultado = null;
    _errorMessage = '';
    _cepDigitado = '';
    notifyListeners();
  }
}
