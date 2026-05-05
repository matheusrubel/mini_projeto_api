class SenhaModel {
  final String senha;

  SenhaModel({
    required this.senha,
  });

  factory SenhaModel.fromJson(Map<String, dynamic> json) {
    return SenhaModel(
      senha: json['password'] ?? '',
    );
  }
}
