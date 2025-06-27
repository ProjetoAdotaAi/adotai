import 'package:flutter/material.dart';
import 'package:adotai/services/notification_service.dart';
import 'package:adotai/widgets/notification_card.dart';
import 'package:adotai/models/notification_model.dart';
import 'package:adotai/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarrega sempre que a tela volta ao foco
    if (ModalRoute.of(context)?.isCurrent == true) {
      _loadNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Resetar o serviço completamente antes de carregar
      notificationService.reset();
      
      // Usar o ID real do usuário logado ou fallback para "1"
      final userId = userProvider.userId?.toString() ?? "1";
      print('🔄 Carregando notificações para usuário: $userId');
      
      await notificationService.fetchNotifications(userId);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('✅ Notificações carregadas com sucesso');
      }
      
    } catch (e) {
      print('❌ Erro ao carregar notificações: $e');
      if (mounted) {
        setState(() {
          _error = 'Erro ao carregar notificações: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (!notification.isRead) {
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      final success = await notificationService.markAsRead(notification.id);
      if (success) {
        // O provider irá notificar automaticamente sobre a mudança
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    final unreadNotifications = notificationService.notifications.where((n) => !n.isRead).toList();
    
    for (final notification in unreadNotifications) {
      await notificationService.markAsRead(notification.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notificações'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            actions: [
              if (notificationService.notifications.any((n) => !n.isRead))
                TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text(
                    'Marcar todas como lidas',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadNotifications,
            child: _buildBody(notificationService),
          ),
        );
      },
    );
  }

  Widget _buildBody(NotificationService notificationService) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (notificationService.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma notificação',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Você não possui notificações no momento',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notificationService.notifications.length,
      itemBuilder: (context, index) {
        final notification = notificationService.notifications[index];
        
        return NotificationCard(
          notification: notification,
          onTap: () => _markAsRead(notification),
        );
      },
    );
  }
}

// Widget para mostrar o badge de notificações não lidas
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int? count;

  const NotificationBadge({
    Key? key,
    required this.child,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count == null || count! <= 0) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              count! > 99 ? '99+' : count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
