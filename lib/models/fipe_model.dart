// Marca retornada por /v1/fipe/brands/:type
class FipeMarcaModel {
  final String id;
  final String nome;

  FipeMarcaModel({required this.id, required this.nome});

  factory FipeMarcaModel.fromJson(Map<String, dynamic> json) {
    return FipeMarcaModel(
      id: json['id']?.toString() ?? '',
      nome: json['name'] ?? json['nome'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FipeMarcaModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// Modelo retornado por /v1/fipe/models/:brand_id
class FipeModeloModel {
  final String id;
  final String nome;
  final String codigoFipe;

  FipeModeloModel({
    required this.id,
    required this.nome,
    required this.codigoFipe,
  });

  factory FipeModeloModel.fromJson(Map<String, dynamic> json) {
    return FipeModeloModel(
      id: json['id']?.toString() ?? '',
      nome: json['name'] ?? json['nome'] ?? '',
      codigoFipe: json['fipe_code'] ?? json['codigo_fipe'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FipeModeloModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// Ano/preço retornado por /v1/fipe/years/:fipe_code
class FipeAnoModel {
  final String id;          // "2020-1"
  final String nome;        // "2020 Gasolina"
  final String codigoFipe;
  final String preco;       // "R$ 45.123,00"
  final String marca;
  final String modelo;
  final String combustivel;
  final String mesReferencia;

  FipeAnoModel({
    required this.id,
    required this.nome,
    required this.codigoFipe,
    required this.preco,
    required this.marca,
    required this.modelo,
    required this.combustivel,
    required this.mesReferencia,
  });

  factory FipeAnoModel.fromJson(Map<String, dynamic> json) {
    return FipeAnoModel(
      id: json['id']?.toString() ?? '',
      nome: json['name'] ?? json['nome'] ?? '',
      codigoFipe: json['fipe_code'] ?? '',
      preco: json['price'] ?? json['valor'] ?? '',
      marca: json['brand'] ?? json['marca'] ?? '',
      modelo: json['model'] ?? json['modelo'] ?? '',
      combustivel: json['fuel'] ?? json['combustivel'] ?? '',
      mesReferencia: json['reference_month'] ?? json['mes_referencia'] ?? '',
    );
  }
}
