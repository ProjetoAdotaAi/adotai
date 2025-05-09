import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/home/appbar.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<bool> _expanded = List.generate(6, (_) => false);

  final List<Map<String, String>> faq = [
    {
      'question': 'Esqueci minha senha, o que faço?',
      'answer': 'Clique em "Alterar Senha" no icone informações do usuário e siga as instruções para redefinir sua senha.',
    },
    {
      'question': 'Como faço para conversar com o abrigo?',
      'answer': 'A comunicação com o abrigo deve ser feita através das redes sociais disponibilizadas pelo abrigo.',
    },
    {
      'question': 'Como faço para adotar um pet?',
      'answer': 'Para adotar um pet, entre em contato com o abrigo através das redes sociais e siga as instruções fornecidas.',
    },
    {
      'question': 'Como faço para cadastrar um abrigo?',
      'answer': 'Para cadastrar um abrigo ou ONG, cadastre-se pela aba de Login realize o cadastro e aguarde o retorno de aprovação via e-mail.',
    },
    {
      'question': 'Como faço para entrar em contato com a equipe?',
      'answer': 'Para entrar em contato com a equipe, envie um e-mail para: haas.studies@gmail.com',
    },
    {
      'question': 'Quem foi a equipe responsavel pela criação do aplicativo?',
      'answer': 'Os membros da equipe são: Natan Kainak, Matheus Morilha, Igor Costa, João Haas, Carlos Barros',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        hasBackButton: true,
        hasNotificationIcon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: faq.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF98A2B3)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expanded[index] = !_expanded[index];
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                faq[index]['question']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.gradientEnd,
                                ),
                              ),
                            ),
                            Icon(
                              _expanded[index]
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: AppTheme.gradientEnd,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                        child:
                            _expanded[index]
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    faq[index]['answer']!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
