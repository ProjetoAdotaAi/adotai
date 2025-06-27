import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/home/appbar.dart';
import '../widgets/preferences/filter_options.dart';

class AdoptionPreferencesScreen extends StatefulWidget {
  const AdoptionPreferencesScreen({super.key});

  @override
  _AdoptionPreferencesScreenState createState() => _AdoptionPreferencesScreenState();
}

class _AdoptionPreferencesScreenState extends State<AdoptionPreferencesScreen> {
  List<String> postadoPor = [];
  List<String> especie = [];
  List<String> idade = [];
  List<String> sexo = [];
  List<String> porte = [];

  final List<String> especieOptions = ['Gato', 'Cachorro'];
  final List<String> sexoOptions = ['Macho', 'Fêmea'];
  final List<String> porteOptions = ['Pequeno', 'Médio', 'Grande'];
  final List<String> idadeOptions = ['Filhote', 'Adulto', 'Idoso'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      postadoPor = prefs.getStringList('postadoPor') ?? [];
      especie = prefs.getStringList('especie') ?? [];
      idade = prefs.getStringList('idade') ?? [];
      sexo = prefs.getStringList('sexo') ?? [];
      porte = prefs.getStringList('porte') ?? [];
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
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
      appBar: const CustomAppBar(hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Preferências para adoção',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterSection('Espécie:', especie, especieOptions, (selected) {
              setState(() => especie = selected);
            }),
            const SizedBox(height: 16),
            _buildFilterSection('Idade:', idade, idadeOptions, (selected) {
              setState(() => idade = selected);
            }),
            const SizedBox(height: 16),
            _buildFilterSection('Sexo:', sexo, sexoOptions, (selected) {
              setState(() => sexo = selected);
            }),
            const SizedBox(height: 16),
            _buildFilterSection('Porte:', porte, porteOptions, (selected) {
              setState(() => porte = selected);
            }),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _savePreferences,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gradientStart,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                'Salvar Preferências',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> selectedOptions, List<String> options, Function(List<String>) onSelectionChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: AppTheme.cinza, fontSize: 26, fontWeight: FontWeight.bold)),
        FilterButtonWidget(
          selectedOptions: selectedOptions,
          options: options,
          onSelectionChanged: onSelectionChanged,
        ),
      ],
    );
  }
}
