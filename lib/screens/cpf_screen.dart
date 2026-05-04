import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cpf_provider.dart';

class CpfScreen extends StatefulWidget {
  const CpfScreen({super.key});

  @override
  State<CpfScreen> createState() => _CpfScreenState();
}

class _CpfScreenState extends State<CpfScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatarCpf(String valor) {
    final digits = valor.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length <= 3) return digits;
    if (digits.length <= 6) return '${digits.substring(0, 3)}.${digits.substring(3)}';
    if (digits.length <= 9) {
      return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6)}';
    }
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, digits.length > 11 ? 11 : digits.length)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Validação de CPF'),
        centerTitle: true,
      ),
      body: Consumer<CpfProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Ícone decorativo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    size: 60,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Verificar CPF',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digite o CPF para verificar se é válido.',
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
                          maxLength: 11,
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            hintText: '000.000.000-00',
                            prefixIcon: Icon(Icons.person),
                            counterText: '',
                          ),
                          onChanged: (value) {
                            final formatted = _formatarCpf(value);
                            _controller.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                            provider.setCpf(value);
                          },
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: provider.status == CpfStatus.loading
                                ? null
                                : () {
                                    final digits = _controller.text
                                        .replaceAll(RegExp(r'[^0-9]'), '');
                                    provider.validarCpf(digits);
                                    _focusNode.unfocus();
                                  },
                            icon: provider.status == CpfStatus.loading
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
                              provider.status == CpfStatus.loading
                                  ? 'Validando...'
                                  : 'Validar CPF',
                            ),
                          ),
                        ),

                        if (provider.status != CpfStatus.idle) ...[
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
                if (provider.status == CpfStatus.success && provider.resultado != null)
                  _ResultadoCard(valido: provider.resultado!.valido, cpf: provider.resultado!.cpf),

                if (provider.status == CpfStatus.error)
                  _ErroCard(mensagem: provider.errorMessage),

                const SizedBox(height: 20),

                // Informações sobre CPF
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Sobre a validação',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A validação verifica o dígito verificador do CPF matematicamente. Um CPF válido segue as regras da Receita Federal do Brasil.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade800,
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
  final bool valido;
  final String cpf;

  const _ResultadoCard({required this.valido, required this.cpf});

  String _formatarCpf(String digits) {
    if (digits.length != 11) return digits;
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
  }

  @override
  Widget build(BuildContext context) {
    final cor = valido ? Colors.green : Colors.red;
    final icone = valido ? Icons.check_circle : Icons.cancel;
    final texto = valido ? 'CPF VÁLIDO' : 'CPF INVÁLIDO';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 64),
            const SizedBox(height: 12),
            Text(
              texto,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatarCpf(cpf),
                style: TextStyle(
                  fontSize: 18,
                  color: cor.shade700,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              valido
                  ? 'O CPF informado é matematicamente válido.'
                  : 'O CPF informado não é válido. Verifique os dígitos.',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
