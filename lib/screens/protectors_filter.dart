import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:adotai/screens/protector_page.dart';
import '../providers/user_provider.dart';

class ProtectorsFilterWidget extends StatefulWidget {
  const ProtectorsFilterWidget({super.key});

  @override
  State<ProtectorsFilterWidget> createState() => _ProtectorsFilterWidgetState();
}

class _ProtectorsFilterWidgetState extends State<ProtectorsFilterWidget> {
  List<Map<String, dynamic>> _allProtectors = [];
  List<Map<String, dynamic>> _filteredProtectors = [];
  bool _isLoading = true;

  String? _selectedState;
  String? _selectedCity;
  List<String> _states = [];
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProtectors();
    });
  }

  Future<void> _loadProtectors() async {
    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allUsers = await userProvider.getAllUsers();

    List<Map<String, dynamic>> tempList = [];

    for (var user in allUsers) {
      if (user.isOng && user.address != null) {
        try {
          final locations = await locationFromAddress(
            '${user.address!.cep}, ${user.address!.city}, ${user.address!.state}',
          );
          if (locations.isNotEmpty) {
            final loc = locations.first;
            tempList.add({
              'protectorName': user.name,
              'protectorType': 'ONG',
              'location': '${user.address!.city}-${user.address!.state}',
              'state': user.address!.state,
              'city': user.address!.city,
              'image': user.profilePicture ?? 'assets/images/default_icon.png',
              'latitude': loc.latitude,
              'longitude': loc.longitude,
              'pets': user.pets,
              'description': user.name,
              'ownerId': user.id,
            });
          }
        } catch (_) {}
      }
    }

    _states = tempList.map((p) => p['state'] as String).toSet().toList()..sort();

    setState(() {
      _allProtectors = tempList;
      _filteredProtectors = List.from(_allProtectors);
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = _allProtectors;

    if (_selectedState != null) {
      filtered = filtered.where((p) => p['state'] == _selectedState).toList();
    }
    if (_selectedCity != null) {
      filtered = filtered.where((p) => p['city'] == _selectedCity).toList();
    }

    setState(() {
      _filteredProtectors = filtered;
    });
  }

  void _onStateChanged(String? newState) {
    if (newState == _selectedState) return;

    setState(() {
      _selectedState = newState;
      _selectedCity = null;
      _cities = [];

      if (newState != null) {
        _cities = _allProtectors
            .where((p) => p['state'] == newState)
            .map((p) => p['city'] as String)
            .toSet()
            .toList()
          ..sort();
      }
    });
  }

  void _onCityChanged(String? newCity) {
    setState(() {
      _selectedCity = newCity;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedState = null;
      _selectedCity = null;
      _cities = [];
      _filteredProtectors = List.from(_allProtectors);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  hint: const Text('Selecione o estado'),
                  value: _selectedState,
                  isExpanded: true,
                  items: _states
                      .map((state) => DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          ))
                      .toList(),
                  onChanged: _onStateChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<String>(
                  hint: const Text('Selecione a cidade'),
                  value: _selectedCity,
                  isExpanded: true,
                  items: _cities
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          ))
                      .toList(),
                  onChanged: _cities.isEmpty ? null : _onCityChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _applyFilters,
                child: const Text('Aplicar filtros'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _clearFilters,
                child: const Text('Limpar filtros'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredProtectors.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum protetor encontrado',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredProtectors.length,
                    itemBuilder: (context, index) {
                      final protector = _filteredProtectors[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProtectorPage(protectorData: protector),
                            ),
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
                                  child: _buildProtectorImage(protector['image']),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        protector['protectorName']?.toString() ??
                                            'Sem nome',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        protector['protectorType']?.toString() ??
                                            'Tipo desconhecido',
                                        style:
                                            const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        protector['location']?.toString() ??
                                            'Localização desconhecida',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
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

Widget _buildProtectorImage(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) {
    return Image.asset(
      'assets/images/default_icon.png',
      width: 64,
      height: 64,
      fit: BoxFit.cover,
    );
  }
  if (imagePath.startsWith('http')) {
    return Image.network(
      imagePath,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/default_icon.png',
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      ),
    );
  }
  return Image.asset(
    imagePath,
    width: 64,
    height: 64,
    fit: BoxFit.cover,
  );
}
