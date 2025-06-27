import 'package:adotai/providers/report_provider.dart';
import 'package:adotai/providers/pet_provider.dart';
import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

void showReportDialog(BuildContext context, String petId) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      // Usamos um Consumer para reconstruir o botão se o estado de loading mudar
      return Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          return AlertDialog(
            title: const Text('Denunciar publicação'),
            content: TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Descreva o motivo da denúncia',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: reportProvider.isLoading
                    ? null // Desabilita o botão enquanto carrega
                    : () async {
                        final reportText = controller.text.trim();
                        if (reportText.isEmpty) return;

                        final userId = Provider.of<UserProvider>(context, listen: false).userId;
                        if (userId == null) return;

                        final success = await reportProvider.sendReport(
                          petId: petId,
                          userId: userId,
                          reportText: reportText,
                        );

                        // Fecha o dialog independente do resultado
                        Navigator.of(context).pop();

                        // Mostra o feedback
                        if (success) {
                          // Remove o pet da lista local após report bem-sucedido
                          final petProvider = Provider.of<PetProvider>(context, listen: false);
                          petProvider.removePetById(petId);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Denúncia enviada com sucesso! O pet foi removido da lista.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(reportProvider.errorMessage ?? 'Ocorreu um erro ao enviar a denúncia.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: reportProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('Enviar'),
              ),
            ],
          );
        },
      );
    },
  );
}