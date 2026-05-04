class CpfModel {
  final bool valido;
  final String cpf;
  final String? mensagem;

  CpfModel({
    required this.valido,
    required this.cpf,
    this.mensagem,
  });

  factory CpfModel.fromJson(Map<String, dynamic> json) {
    return CpfModel(
      valido: json['valido'] ?? false,
      cpf: json['cpf'] ?? '',
      mensagem: json['mensagem'],
    );
  }
}
