import 'package:flutter/material.dart';
import '../data/saldos_service.dart';
import '../models/saldos_model.dart';
import '../widgets/saldos_card.dart';

class SaldosPage extends StatefulWidget {
  const SaldosPage({super.key});

  @override
  State<SaldosPage> createState() => _SaldosPageState();
}

class _SaldosPageState extends State<SaldosPage> {
  final SaldosService _saldosService = SaldosService();
  late Future<List<SaldoUsuario>> _listaSaldosFuture;

  @override
  void initState() {
    super.initState();
    _listaSaldosFuture = _saldosService.obtenerSaldos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estado de Cuentas"), centerTitle: true),
      body: FutureBuilder<List<SaldoUsuario>>(
        future: _listaSaldosFuture,
        builder: (context, snapshot) {
          // 1. Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  const Text("Error al cargar saldos"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _listaSaldosFuture = _saldosService.obtenerSaldos();
                      });
                    },
                    child: const Text("Reintentar"),
                  ),
                ],
              ),
            );
          }

          // 3. Éxito
          final saldos = snapshot.data ?? [];

          if (saldos.isEmpty) {
            return const Center(child: Text("No hay deudas pendientes"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: saldos.length,
            itemBuilder: (context, index) {
              return SaldoCard(usuario: saldos[index]);
            },
          );
        },
      ),
    );
  }
}
