import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cep_provider.dart';
import '../models/cep_model.dart';

class CepScreen extends StatefulWidget {
  const CepScreen({super.key});

  @override
  State<CepScreen> createState() => _CepScreenState();
}

class _CepScreenState extends State<CepScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatarCep(String valor) {
    final digits = valor.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length <= 5) return digits;
    return '${digits.substring(0, 5)}-${digits.substring(5, digits.length > 8 ? 8 : digits.length)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
        centerTitle: true,
      ),
      body: Consumer<CepProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Ícone decorativo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 60,
                    color: Color(0xFF00695C),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Buscar Endereço',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digite o CEP para encontrar o endereço completo.',
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de entrada
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 8,
                          decoration: const InputDecoration(
                            labelText: 'CEP',
                            hintText: '00000-000',
                            prefixIcon: Icon(Icons.map),
                            counterText: '',
                          ),
                          onChanged: (value) {
                            final formatted = _formatarCep(value);
                            _controller.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                            provider.setCep(value);
                          },
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00695C),
                            ),
                            onPressed: provider.status == CepStatus.loading
                                ? null
                                : () {
                                    final digits = _controller.text
                                        .replaceAll(RegExp(r'[^0-9]'), '');
                                    provider.buscarCep(digits);
                                    _focusNode.unfocus();
                                  },
                            icon: provider.status == CepStatus.loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.search),
                            label: Text(
                              provider.status == CepStatus.loading
                                  ? 'Buscando...'
                                  : 'Buscar CEP',
                            ),
                          ),
                        ),

                        if (provider.status != CepStatus.idle) ...[
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: () {
                              _controller.clear();
                              provider.resetar();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Limpar'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Resultado
                if (provider.status == CepStatus.success && provider.resultado != null)
                  _ResultadoCard(cep: provider.resultado!),

                if (provider.status == CepStatus.error)
                  _ErroCard(mensagem: provider.errorMessage),

                const SizedBox(height: 20),

                // Informações sobre CEP
                Card(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.teal.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Sobre a consulta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Digite os 8 dígitos do CEP para obter logradouro, bairro, cidade e estado. Os CEPs são definidos pelos Correios do Brasil.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResultadoCard extends StatelessWidget {
  final CepModel cep;

  const _ResultadoCard({required this.cep});

  String _formatarCep(String digits) {
    if (digits.length != 8) return digits;
    return '${digits.substring(0, 5)}-${digits.substring(5)}';
  }

  @override
  Widget build(BuildContext context) {
    const cor = Color(0xFF00695C);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: cor, size: 64),
            const SizedBox(height: 12),
            Text(
              _formatarCep(cep.cep),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(icone: Icons.streetview, label: 'Logradouro', valor: cep.logradouro),
            _InfoRow(icone: Icons.location_city, label: 'Bairro', valor: cep.bairro),
            _InfoRow(icone: Icons.apartment, label: 'Cidade', valor: cep.cidade),
            _InfoRow(icone: Icons.map_outlined, label: 'Estado', valor: cep.uf),
            if (cep.ibge.isNotEmpty)
              _InfoRow(icone: Icons.tag, label: 'Cód. IBGE', valor: cep.ibge),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valor;

  const _InfoRow({
    required this.icone,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    if (valor.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, size: 18, color: const Color(0xFF00695C)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErroCard extends StatelessWidget {
  final String mensagem;

  const _ErroCard({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensagem,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}