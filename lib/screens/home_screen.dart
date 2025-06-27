import 'package:adotai/screens/swipe_detector_screen.dart';
import 'package:adotai/widgets/pet/favorite_pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/home/appbar.dart';
import '../widgets/home/navigation_bar.dart';
import '../services/notification_service.dart';
import 'protectors_filter.dart';
import 'user_pet_list_screen.dart';
import 'user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Conecta ao WebSocket quando a tela carrega
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectNotificationWebSocket();
    });
  }

  void _connectNotificationWebSocket() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    
    final userId = userProvider.userId;
    if (userId != null) {
      print('[HomeScreen] Conectando WebSocket para usuário: $userId');
      notificationService.connectWebSocket(userId.toString());
      
      // Carregar notificações iniciais ao conectar
      notificationService.fetchNotifications(userId.toString());
    } else {
      print('[HomeScreen] Usuário não logado, usando ID padrão');
      notificationService.connectWebSocket("1");
      notificationService.fetchNotifications("1");
    }
  }

  @override
  void dispose() {
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    notificationService.disconnectWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    bool isOng = user?.isOng ?? false;

    final List<Widget> pages = [
      const SwipeScreen(),
      const ProtectorsFilterWidget(),
      isOng ? const UserPetList() : const FavoritePets(),
      const UserScreen(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : pages[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
