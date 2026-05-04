class MoedaModel {
  final String simbolo;   // "USD_BRL"
  final String nome;      // "Dólar Americano/Real Brasileiro"
  final double preco;     // cotação atual
  final double alta;
  final double baixa;
  final double variacao;
  final String atualizadoEm;

  MoedaModel({
    required this.simbolo,
    required this.nome,
    required this.preco,
    required this.alta,
    required this.baixa,
    required this.variacao,
    required this.atualizadoEm,
  });

  // A API retorna um Map com chave "USD_BRL" e valor sendo outro Map
  // {
  //   "name": "Dólar Americano/Real Brasileiro",
  //   "price": 5.1234,
  //   "high": 5.20,
  //   "low": 5.10,
  //   "variation": 0.5,
  //   "updated_at": "2024-01-01 10:00:00"
  // }
  factory MoedaModel.fromJson(String key, Map<String, dynamic> json) {
    return MoedaModel(
      simbolo: key,
      nome: json['name'] ?? key,
      preco: (json['price'] ?? 0).toDouble(),
      alta: (json['high'] ?? 0).toDouble(),
      baixa: (json['low'] ?? 0).toDouble(),
      variacao: (json['variation'] ?? 0).toDouble(),
      atualizadoEm: json['updated_at'] ?? '',
    );
  }

  // Extrai só a sigla da moeda de origem (ex: "USD" de "USD_BRL")
  String get sigla => simbolo.split('_').first;
}
