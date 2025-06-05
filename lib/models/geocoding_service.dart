import 'package:adotai/screens/protector_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_theme.dart';

class ProtectorsFilterWidget extends StatefulWidget {
  const ProtectorsFilterWidget({super.key});

  @override
  State<ProtectorsFilterWidget> createState() => _ProtectorsFilterWidgetState();
}

class _ProtectorsFilterWidgetState extends State<ProtectorsFilterWidget> {
  double _distance = 100;
  Position? _currentPosition;

  String? _selectedSpecies;
  String? _selectedSize;
  String? _selectedSex;
  bool _castrated = false;
  bool _dewormed = false;
  bool _vaccinated = false;

  final List<String> _speciesOptions = ['Cachorro', 'Gato'];
  final List<String> _sizeOptions = ['Pequeno', 'Médio', 'Grande'];
  final List<String> _sexOptions = ['Macho', 'Fêmea'];

  final List<Map<String, dynamic>> _protectors = [
    {
      'name': 'Matheus Morilha',
      'type': 'Protetor Individual',
      'location': 'Toledo-PR',
      'image': 'assets/images/default_icon.png',
      'latitude': -24.7137,
      'longitude': -53.7435,
    },
    {
      'name': 'Ana Silva',
      'type': 'Protetora Comunitária',
      'location': 'Cascavel-PR',
      'image': 'assets/images/default_icon.png',
      'latitude': -24.9578,
      'longitude': -53.4590,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  InputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: _inputBorder(Colors.black),
        enabledBorder: _inputBorder(Colors.black),
        focusedBorder: _inputBorder(AppTheme.primaryColor),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      activeColor: AppTheme.primaryColor,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  List<Map<String, dynamic>> get _filteredProtectors {
    if (_currentPosition == null) return [];

    return _protectors.where((protector) {
      final distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        protector['latitude'],
        protector['longitude'],
      );

      return distanceInMeters <= _distance * 1000;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProtectors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Protetores perto de você',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              prefixIcon: const Icon(Icons.search),
              border: _inputBorder(Colors.black),
              enabledBorder: _inputBorder(Colors.black),
              focusedBorder: _inputBorder(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Distância: +${_distance.round()} km',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: _distance,
            min: 10,
            max: 100,
            divisions: 18,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              setState(() {
                _distance = value;
              });
            },
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            title: const Text(
              'Filtros Avançados',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              _buildDropdown('Espécie', _selectedSpecies, _speciesOptions, (value) {
                setState(() {
                  _selectedSpecies = value;
                });
              }),
              const SizedBox(height: 8),
              _buildDropdown('Porte', _selectedSize, _sizeOptions, (value) {
                setState(() {
                  _selectedSize = value;
                });
              }),
              const SizedBox(height: 8),
              _buildDropdown('Sexo', _selectedSex, _sexOptions, (value) {
                setState(() {
                  _selectedSex = value;
                });
              }),
              _buildCheckbox('Castrado', _castrated, (value) {
                setState(() {
                  _castrated = value ?? false;
                });
              }),
              _buildCheckbox('Vermifugado', _dewormed, (value) {
                setState(() {
                  _dewormed = value ?? false;
                });
              }),
              _buildCheckbox('Vacinado', _vaccinated, (value) {
                setState(() {
                  _vaccinated = value ?? false;
                });
              }),
              const SizedBox(height: 8),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final protector = filtered[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProtectorPage()),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              protector['image']!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  protector['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  protector['type']!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  protector['location']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
