import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fipe_provider.dart';
import '../models/fipe_model.dart';

class FipeScreen extends StatefulWidget {
  const FipeScreen({super.key});

  @override
  State<FipeScreen> createState() => _FipeScreenState();
}

class _FipeScreenState extends State<FipeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codigoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Tabela FIPE'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Por Código'),
            Tab(icon: Icon(Icons.list), text: 'Por Marca'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TabPorCodigo(controller: _codigoController),
          const _TabPorMarca(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tab 1: Consulta por código FIPE
// ─────────────────────────────────────────
class _TabPorCodigo extends StatelessWidget {
  final TextEditingController controller;
  const _TabPorCodigo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<FipeProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Código FIPE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ex: 001004-9  (encontrado na aba "Por Marca")',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Digite o código FIPE',
                          prefixIcon: Icon(Icons.tag),
                          hintText: '001004-9',
                        ),
                        onChanged: provider.setCodigoFipeManual,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A1B9A)),
                          onPressed:
                              provider.statusAnos == FipeStatus.loading
                                  ? null
                                  : () {
                                      final codigo = controller.text.trim();
                                      if (codigo.isNotEmpty) {
                                        provider.buscarAnosPorCodigo(codigo);
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                          icon: provider.statusAnos == FipeStatus.loading
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
                            provider.statusAnos == FipeStatus.loading
                                ? 'Buscando...'
                                : 'Consultar Preços',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (provider.statusAnos == FipeStatus.success &&
                  provider.anos.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preços por ano',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                        fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                ...provider.anos.map((a) => _AnoCard(ano: a)),
              ],

              if (provider.statusAnos == FipeStatus.error)
                _ErroCard(mensagem: provider.errorMessage),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Tab 2: Navegar por Marca
// ─────────────────────────────────────────
class _TabPorMarca extends StatelessWidget {
  const _TabPorMarca();

  @override
  Widget build(BuildContext context) {
    return Consumer<FipeProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de veículo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tipo de veículo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A1B9A)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _TipoChip(
                            label: '🚗 Carros',
                            tipo: 1,
                            atual: provider.tipoVeiculo,
                            onTap: provider.setTipoVeiculo,
                          ),
                          const SizedBox(width: 8),
                          _TipoChip(
                            label: '🏍️ Motos',
                            tipo: 2,
                            atual: provider.tipoVeiculo,
                            onTap: provider.setTipoVeiculo,
                          ),
                          const SizedBox(width: 8),
                          _TipoChip(
                            label: '🚛 Camin.',
                            tipo: 3,
                            atual: provider.tipoVeiculo,
                            onTap: provider.setTipoVeiculo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A1B9A)),
                          onPressed:
                              provider.statusMarcas == FipeStatus.loading
                                  ? null
                                  : provider.carregarMarcas,
                          icon: provider.statusMarcas == FipeStatus.loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.download),
                          label: Text(
                            provider.statusMarcas == FipeStatus.loading
                                ? 'Carregando...'
                                : 'Carregar Marcas',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Dropdown de marcas
              if (provider.statusMarcas == FipeStatus.success &&
                  provider.marcas.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Selecionar marca',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Card(
                  child: DropdownButtonFormField<FipeMarcaModel>(
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      prefixIcon: Icon(Icons.business),
                    ),
                    hint: const Text('Escolha uma marca'),
                    value: provider.marcaSelecionada,
                    items: provider.marcas
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m.nome),
                            ))
                        .toList(),
                    onChanged: (m) {
                      if (m != null) provider.selecionarMarca(m);
                    },
                  ),
                ),
              ],

              // Loading modelos
              if (provider.statusModelos == FipeStatus.loading) ...[
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator()),
              ],

              // Dropdown de modelos
              if (provider.statusModelos == FipeStatus.success &&
                  provider.modelos.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Selecionar modelo',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Card(
                  child: DropdownButtonFormField<FipeModeloModel>(
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    hint: const Text('Escolha um modelo'),
                    value: provider.modeloSelecionado,
                    items: provider.modelos
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m.nome,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (m) {
                      if (m != null && m.codigoFipe.isNotEmpty) {
                        provider.buscarAnosPorCodigo(m.codigoFipe);
                      }
                    },
                  ),
                ),

                // Código FIPE do modelo selecionado
                if (provider.modeloSelecionado != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Código FIPE: ${provider.modeloSelecionado!.codigoFipe}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black45),
                    ),
                  ),
              ],

              // Loading anos
              if (provider.statusAnos == FipeStatus.loading) ...[
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator()),
              ],

              // Lista de anos/preços
              if (provider.statusAnos == FipeStatus.success &&
                  provider.anos.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Preços por ano',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                        fontSize: 15)),
                const SizedBox(height: 8),
                ...provider.anos.map((a) => _AnoCard(ano: a)),
              ],

              // Erros
              if (provider.statusMarcas == FipeStatus.error ||
                  provider.statusModelos == FipeStatus.error ||
                  provider.statusAnos == FipeStatus.error)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _ErroCard(mensagem: provider.errorMessage),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────

class _AnoCard extends StatelessWidget {
  final FipeAnoModel ano;
  const _AnoCard({required this.ano});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_today,
                  color: Color(0xFF6A1B9A), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ano.nome,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  if (ano.combustivel.isNotEmpty)
                    Text(ano.combustivel,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  if (ano.mesReferencia.isNotEmpty)
                    Text('Ref: ${ano.mesReferencia}',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black38)),
                ],
              ),
            ),
            Text(
              ano.preco,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipoChip extends StatelessWidget {
  final String label;
  final int tipo;
  final int atual;
  final void Function(int) onTap;

  const _TipoChip({
    required this.label,
    required this.tipo,
    required this.atual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selecionado = tipo == atual;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(tipo),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selecionado
                ? const Color(0xFF6A1B9A)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selecionado
                  ? const Color(0xFF6A1B9A)
                  : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: selecionado ? Colors.white : Colors.black54,
            ),
          ),
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
              child: Text(mensagem,
                  style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        ),
      ),
    );
  }
}
