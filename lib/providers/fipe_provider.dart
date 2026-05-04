import 'package:flutter/material.dart';
import '../models/fipe_model.dart';
import '../services/invertexto_service.dart';

enum FipeStatus { idle, loading, success, error }

class FipeProvider extends ChangeNotifier {
  final InvertextoService _service = InvertextoService();

  FipeStatus _statusMarcas = FipeStatus.idle;
  FipeStatus _statusModelos = FipeStatus.idle;
  FipeStatus _statusAnos = FipeStatus.idle;

  List<FipeMarcaModel> _marcas = [];
  List<FipeModeloModel> _modelos = [];
  List<FipeAnoModel> _anos = [];

  FipeMarcaModel? _marcaSelecionada;
  FipeModeloModel? _modeloSelecionado;
  int _tipoVeiculo = 1;
  String _errorMessage = '';
  String _codigoFipeManual = '';

  // Getters
  FipeStatus get statusMarcas => _statusMarcas;
  FipeStatus get statusModelos => _statusModelos;
  FipeStatus get statusAnos => _statusAnos;
  List<FipeMarcaModel> get marcas => _marcas;
  List<FipeModeloModel> get modelos => _modelos;
  List<FipeAnoModel> get anos => _anos;
  FipeMarcaModel? get marcaSelecionada => _marcaSelecionada;
  FipeModeloModel? get modeloSelecionado => _modeloSelecionado;
  int get tipoVeiculo => _tipoVeiculo;
  String get errorMessage => _errorMessage;
  String get codigoFipeManual => _codigoFipeManual;

  void setTipoVeiculo(int tipo) {
    _tipoVeiculo = tipo;
    _marcas = [];
    _modelos = [];
    _anos = [];
    _marcaSelecionada = null;
    _modeloSelecionado = null;
    _statusMarcas = FipeStatus.idle;
    _statusModelos = FipeStatus.idle;
    _statusAnos = FipeStatus.idle;
    notifyListeners();
  }

  void setCodigoFipeManual(String codigo) {
    _codigoFipeManual = codigo;
    notifyListeners();
  }

  Future<void> carregarMarcas() async {
    _statusMarcas = FipeStatus.loading;
    _marcas = [];
    _marcaSelecionada = null;
    _modelos = [];
    _modeloSelecionado = null;
    _anos = [];
    _errorMessage = '';
    notifyListeners();

    try {
      _marcas = await _service.getFipeMarcas(tipo: _tipoVeiculo);
      _statusMarcas = FipeStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _statusMarcas = FipeStatus.error;
    }
    notifyListeners();
  }

  Future<void> selecionarMarca(FipeMarcaModel marca) async {
    _marcaSelecionada = marca;
    _modeloSelecionado = null;
    _modelos = [];
    _anos = [];
    _statusModelos = FipeStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _modelos = await _service.getFipeModelos(marca.id);
      _statusModelos = FipeStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _statusModelos = FipeStatus.error;
    }
    notifyListeners();
  }

  Future<void> buscarAnosPorCodigo(String codigoFipe) async {
    _statusAnos = FipeStatus.loading;
    _anos = [];
    _errorMessage = '';
    notifyListeners();

    try {
      _anos = await _service.getFipeAnos(codigoFipe);
      _statusAnos = FipeStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _statusAnos = FipeStatus.error;
    }
    notifyListeners();
  }

  void resetar() {
    _statusMarcas = FipeStatus.idle;
    _statusModelos = FipeStatus.idle;
    _statusAnos = FipeStatus.idle;
    _marcas = [];
    _modelos = [];
    _anos = [];
    _marcaSelecionada = null;
    _modeloSelecionado = null;
    _errorMessage = '';
    _codigoFipeManual = '';
    notifyListeners();
  }
}
