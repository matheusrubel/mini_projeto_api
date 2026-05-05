import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/senha_provider.dart';

class SenhaScreen extends StatelessWidget {
  const SenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Gerador de Senhas'),
        centerTitle: true,
      ),
      body: Consumer<SenhaProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Ícone decorativo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBF360C).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 60,
                    color: Color(0xFFBF360C),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Gerar Senha Segura',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Configure e gere senhas fortes automaticamente.',
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Configurações
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tamanho
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tamanho',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${provider.tamanho} caracteres',
                              style: const TextStyle(
                                color: Color(0xFFBF360C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: provider.tamanho.toDouble(),
                          min: 6,
                          max: 32,
                          divisions: 26,
                          activeColor: const Color(0xFFBF360C),
                          onChanged: (v) => provider.setTamanho(v.toInt()),
                        ),

                        const Divider(height: 24),

                        // Switches de tipo
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Letras minúsculas'),
                          subtitle: const Text('a b c d e f ...', style: TextStyle(fontSize: 12)),
                          value: provider.letrasMinusculas,
                          activeColor: const Color(0xFFBF360C),
                          onChanged: (_) => provider.toggleLetrasMinusculas(),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Letras maiúsculas'),
                          subtitle: const Text('A B C D E F ...', style: TextStyle(fontSize: 12)),
                          value: provider.letrasMaiusculas,
                          activeColor: const Color(0xFFBF360C),
                          onChanged: (_) => provider.toggleLetrasMaiusculas(),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Números'),
                          subtitle: const Text('0 1 2 3 4 5 ...', style: TextStyle(fontSize: 12)),
                          value: provider.numeros,
                          activeColor: const Color(0xFFBF360C),
                          onChanged: (_) => provider.toggleNumeros(),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Símbolos'),
                          subtitle: const Text('! @ # \$ % & ...', style: TextStyle(fontSize: 12)),
                          value: provider.simbolos,
                          activeColor: const Color(0xFFBF360C),
                          onChanged: (_) => provider.toggleSimbolos(),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBF360C),
                            ),
                            onPressed: provider.status == SenhaStatus.loading
                                ? null
                                : provider.gerarSenha,
                            icon: provider.status == SenhaStatus.loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.generating_tokens),
                            label: Text(
                              provider.status == SenhaStatus.loading
                                  ? 'Gerando...'
                                  : 'Gerar Senha',
                            ),
                          ),
                        ),

                        if (provider.status != SenhaStatus.idle) ...[
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: provider.resetar,
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
                if (provider.status == SenhaStatus.success && provider.resultado != null)
                  _ResultadoCard(senha: provider.resultado!.senha),

                if (provider.status == SenhaStatus.error)
                  _ErroCard(mensagem: provider.errorMessage),

                const SizedBox(height: 20),

                // Informações sobre senhas
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.orange.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Dicas de segurança',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use senhas com pelo menos 12 caracteres combinando letras, números e símbolos. Nunca reutilize a mesma senha em sites diferentes.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade800,
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
  final String senha;

  const _ResultadoCard({required this.senha});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFFBF360C), size: 64),
            const SizedBox(height: 12),
            const Text(
              'SENHA GERADA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFBF360C),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFBF360C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                senha,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFBF360C),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFBF360C),
                  side: const BorderSide(color: Color(0xFFBF360C)),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: senha));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Senha copiada para a área de transferência!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copiar senha'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Guarde sua senha em um local seguro.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
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
