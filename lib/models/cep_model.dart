class CepModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;
  final String ibge;

  CepModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.ibge,
  });

  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      uf: json['uf'] ?? '',
      ibge: json['ibge'] ?? '',
    );
  }
}
