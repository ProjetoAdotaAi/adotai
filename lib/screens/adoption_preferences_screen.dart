import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/home/appbar.dart';
import '../widgets/preferences/filter_options.dart';

class AdoptionPreferncesScreen extends StatefulWidget {
  const AdoptionPreferncesScreen({super.key});

  @override
  _AdoptionPreferncesScreenState createState() => _AdoptionPreferncesScreenState();
}

class _AdoptionPreferncesScreenState extends State<AdoptionPreferncesScreen> {
  List<String> postadoPor = [];
  List<String> especie = [];
  List<String> idade = [];
  List<String> sexo = [];
  List<String> porte = [];

  final List<String> postadoPorOptions = ['ONG', 'Protetores Individuais'];
  final List<String> especieOptions = ['Gato', 'Cachorro'];
  final List<String> sexoOptions = ['Masculino', 'Feminino'];
  final List<String> porteOptions = ['Pequeno', 'Médio', 'Grande'];
  final List<String> idadeOptions = ['Filhote', 'Adulto'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      postadoPor = prefs.getStringList('postadoPor') ?? [];
      especie = prefs.getStringList('especie') ?? [];
      idade = prefs.getStringList('idade') ?? [];
      sexo = prefs.getStringList('sexo') ?? [];
      porte = prefs.getStringList('porte') ?? [];
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('postadoPor', postadoPor);
    await prefs.setStringList('especie', especie);
    await prefs.setStringList('idade', idade);
    await prefs.setStringList('sexo', sexo);
    await prefs.setStringList('porte', porte);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Preferências para adoção',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Postado Por:', style: TextStyle(color: AppTheme.cinza, fontSize: 26, fontWeight: FontWeight.bold)),
                FilterButtonWidget(
                  selectedOptions: postadoPor,
                  options: postadoPorOptions,
                  onSelectionChanged: (selected) {
                    setState(() {
                      postadoPor = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Espécie:', style: TextStyle(color: AppTheme.cinza, fontSize: 26, fontWeight: FontWeight.bold)),
                FilterButtonWidget(
                  selectedOptions: especie,
                  options: especieOptions,
                  onSelectionChanged: (selected) {
                    setState(() {
                      especie = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Idade:', style: TextStyle(color: AppTheme.cinza, fontSize: 26, fontWeight: FontWeight.bold)),
                FilterButtonWidget(
                  selectedOptions: idade,
                  options: idadeOptions,
                  onSelectionChanged: (selected) {
                    setState(() {
                      idade = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sexo:', style: TextStyle(color: AppTheme.cinza, fontSize: 26, fontWeight: FontWeight.bold)),
                FilterButtonWidget(
                  selectedOptions: sexo,
                  options: sexoOptions,
                  onSelectionChanged: (selected) {
                    setState(() {
                      sexo = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Porte:', style: TextStyle(color: AppTheme.cinza, fontSize: 26, fontWeight: FontWeight.bold)),
                FilterButtonWidget(
                  selectedOptions: porte,
                  options: porteOptions,
                  onSelectionChanged: (selected) {
                    setState(() {
                      porte = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _savePreferences,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gradientStart,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Salvar Preferências', style: TextStyle(color: Colors.white, fontSize: 22),),
            ),
          ],
        ),
      ),
    );
  }
}
