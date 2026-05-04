import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/moeda_provider.dart';
import '../models/moeda_model.dart';

class MoedaScreen extends StatelessWidget {
  const MoedaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Cotação de Moedas'),
        centerTitle: true,
      ),
      body: Consumer<MoedaProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.currency_exchange, color: Colors.white, size: 36),
                      SizedBox(height: 10),
                      Text(
                        'Câmbio em Tempo Real',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Conversão para Real Brasileiro (BRL)',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Selecionar moedas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 12),

                // Chips de seleção
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.moedasDisponiveis.map((moeda) {
                    final sigla = moeda['sigla']!;
                    final selecionada = provider.selecionadas.contains(sigla);
                    return FilterChip(
                      label: Text('${moeda['emoji']} $sigla'),
                      selected: selecionada,
                      onSelected: (_) => provider.toggleMoeda(sigla),
                      selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF2E7D32),
                      labelStyle: TextStyle(
                        color: selecionada
                            ? const Color(0xFF2E7D32)
                            : Colors.black54,
                        fontWeight: selecionada
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                    onPressed: provider.status == MoedaStatus.loading
                        ? null
                        : provider.buscarCotacoes,
                    icon: provider.status == MoedaStatus.loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      provider.status == MoedaStatus.loading
                          ? 'Buscando...'
                          : 'Buscar Cotações',
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (provider.status == MoedaStatus.success) ...[
                  const Text(
                    'Cotações atuais',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...provider.cotacoes.map((m) => _MoedaCard(moeda: m)),
                ],

                if (provider.status == MoedaStatus.error)
                  _ErroCard(mensagem: provider.errorMessage),

                if (provider.status == MoedaStatus.idle)
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.green.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Selecione as moedas desejadas e toque em "Buscar Cotações".',
                              style: TextStyle(
                                  color: Colors.green.shade800, fontSize: 13),
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

class _MoedaCard extends StatelessWidget {
  final MoedaModel moeda;
  const _MoedaCard({required this.moeda});

  String _emoji(String sigla) {
    const mapa = {
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'ARS': '🇦🇷',
      'BTC': '₿',
    };
    return mapa[sigla] ?? '💱';
  }

  Color _corVariacao() =>
      moeda.variacao >= 0 ? Colors.green.shade700 : Colors.red.shade700;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(_emoji(moeda.sigla),
                        style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moeda.sigla,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        moeda.nome,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${moeda.preco.toStringAsFixed(4)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          moeda.variacao >= 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: _corVariacao(),
                          size: 18,
                        ),
                        Text(
                          '${moeda.variacao.toStringAsFixed(2)}%',
                          style: TextStyle(
                              color: _corVariacao(),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniInfo(
                    label: 'Mínima',
                    valor: 'R\$ ${moeda.baixa.toStringAsFixed(4)}'),
                _MiniInfo(
                    label: 'Máxima',
                    valor: 'R\$ ${moeda.alta.toStringAsFixed(4)}'),
                _MiniInfo(
                    label: 'Atualizado',
                    valor: moeda.atualizadoEm.length > 10
                        ? moeda.atualizadoEm.substring(0, 10)
                        : moeda.atualizadoEm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label;
  final String valor;
  const _MiniInfo({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.black45)),
        const SizedBox(height: 2),
        Text(valor,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600)),
      ],
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
              child: Text(mensagem,
                  style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        ),
      ),
    );
  }
}
