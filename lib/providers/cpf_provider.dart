import 'package:flutter/material.dart';
import '../models/cpf_model.dart';
import '../services/invertexto_service.dart';

enum CpfStatus { idle, loading, success, error }

class CpfProvider extends ChangeNotifier {
  final InvertextoService _service = InvertextoService();

  CpfStatus _status = CpfStatus.idle;
  CpfModel? _resultado;
  String _errorMessage = '';
  String _cpfDigitado = '';

  CpfStatus get status => _status;
  CpfModel? get resultado => _resultado;
  String get errorMessage => _errorMessage;
  String get cpfDigitado => _cpfDigitado;

  void setCpf(String cpf) {
    _cpfDigitado = cpf;
    notifyListeners();
  }

  Future<void> validarCpf(String cpf) async {
    if (cpf.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
      _errorMessage = 'O CPF deve ter 11 dígitos.';
      _status = CpfStatus.error;
      _resultado = null;
      notifyListeners();
      return;
    }

    _status = CpfStatus.loading;
    _resultado = null;
    _errorMessage = '';
    notifyListeners();

    try {
      _resultado = await _service.validarCpf(cpf);
      _status = CpfStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = CpfStatus.error;
    }

    notifyListeners();
  }

  void resetar() {
    _status = CpfStatus.idle;
    _resultado = null;
    _errorMessage = '';
    _cpfDigitado = '';
    notifyListeners();
  }
}
