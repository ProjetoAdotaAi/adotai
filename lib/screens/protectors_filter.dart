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

  final List<Map<String, String>> _protectors = [
    {
      'name': 'Matheus Morilha',
      'type': 'Protetor Individual',
      'location': 'Toledo-PR',
      'image': 'assets/images/default_icon.png'
    },
    {
      'name': 'Ana Silva',
      'type': 'Protetora Comunitária',
      'location': 'Cascavel-PR',
      'image': 'assets/images/default_icon.png'
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

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _protectors.length,
              itemBuilder: (context, index) {
                final protector = _protectors[index];
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
