import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  List<NotificationModel> _notifications = [];
  WebSocketChannel? _channel;
  bool _isConnected = false;

  // URL do seu backend - ajuste conforme necessário
  static const String baseUrl = 'http://10.0.2.2:3003'; // Para emulador Android
  static const String wsUrl = 'ws://10.0.2.2:3003';

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  bool get isConnected => _isConnected;

  // Busca todas as notificações do usuário
  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    try {
      print('Buscando notificações para usuário: $userId');
      
      // LIMPAR CACHE ANTES DE BUSCAR NOVAS NOTIFICAÇÕES
      _notifications = [];
      notifyListeners();
      print('Cache de notificações limpo antes da busca');
      
      // OBRIGATÓRIO: Buscar token de autenticação
      final token = await _getAuthToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Token de autenticação não encontrado. Usuário precisa fazer login.');
      }
      
      final url = '$baseUrl/api/notifications';
      print('URL da requisição: $url');
      
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      print('Fazendo requisição com token de autenticação');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Dados decodificados: $data');
        
        // Verifica se a resposta tem o formato {success: true, data: [...]}
        List<dynamic> notificationsList = [];
        
        if (data is Map) {
          if (data.containsKey('data')) {
            // Se data é um array, usa diretamente
            if (data['data'] is List) {
              notificationsList = data['data'];
            } else if (data['data'] != null) {
              // Se data é um objeto único, coloca em uma lista
              notificationsList = [data['data']];
            }
          } else if (data.containsKey('notifications')) {
            // Caso o campo seja 'notifications'
            notificationsList = data['notifications'] is List ? data['notifications'] : [];
          } else {
            // Se não tem campo específico, tenta usar o objeto inteiro
            notificationsList = [data];
          }
        } else if (data is List) {
          // Se a resposta é diretamente um array
          notificationsList = data;
        }
        
        print('Lista de notificações encontrada: ${notificationsList.length} itens');
        print('Notificações recebidas: $notificationsList');
        
        _notifications = notificationsList
            .where((json) => json != null)
            .map((json) {
              try {
                print('Tentando converter notificação: $json');
                final notification = NotificationModel.fromJson(json);
                print('Notificação convertida com sucesso: ${notification.title}');
                return notification;
              } catch (e) {
                print('Erro ao converter notificação: $e');
                print('JSON problemático: $json');
                return null;
              }
            })
            .where((notification) => notification != null)
            .cast<NotificationModel>()
            .toList();
        
        print('Notificações carregadas do backend: ${_notifications.length}');
        notifyListeners();
        return _notifications;
      } else {
        print('Erro na API: ${response.statusCode} - ${response.body}');
        throw Exception('Erro ao buscar notificações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar notificações: $e');
      
      // Em caso de erro, retorna lista vazia
      _notifications = [];
      notifyListeners();
      return _notifications;
    }
  }

  // Método para obter o token de autenticação
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // O AuthProvider salva como 'token'
      String? token = prefs.getString('token');
      
      print('Token obtido do SharedPreferences: ${token != null ? 'Token presente (${token.length} chars)' : 'Sem token'}');
      
      if (token != null) {
        print('Primeiros 20 chars do token: ${token.length > 20 ? token.substring(0, 20) + '...' : token}');
      }
      
      return token;
    } catch (e) {
      print('Erro ao obter token: $e');
      return null;
    }
  }

  // Marca uma notificação como lida
  Future<bool> markAsRead(String notificationId) async {
    try {
      print('Marcando notificação como lida: $notificationId');
      
      // Obter token de autenticação
      final token = await _getAuthToken();
      
      final headers = {
        'Content-Type': 'application/json',
      };
      
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      final response = await http.patch(
        Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
        headers: headers,
        body: jsonEncode({}), // Endpoint não precisa de body
      );

      print('Mark as read response: ${response.statusCode}');
      print('Mark as read body: ${response.body}');

      if (response.statusCode == 200) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          notifyListeners();
        }
        return true;
      } else {
        print('Erro ao marcar como lida no backend: ${response.statusCode}');
        // Fallback: marca localmente mesmo se a API falhar
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          notifyListeners();
        }
        return false;
      }
    } catch (e) {
      print('Erro ao marcar como lida: $e');
      // Fallback: marca localmente em caso de erro
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  // Adiciona uma nova notificação à lista
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Limpa todas as notificações do cache
  void clearNotifications() {
    _notifications = [];
    notifyListeners();
    print('Cache de notificações limpo');
  }

  // Conta notificações não lidas
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Conecta ao WebSocket para receber notificações em tempo real
  Future<void> connectWebSocket(String userId) async {
    try {
      print('Conectando ao WebSocket para usuário: $userId');
      
      _channel = WebSocketChannel.connect(
        Uri.parse('$wsUrl/ws/$userId'),
      );

      _isConnected = true;
      notifyListeners();

      _channel!.stream.listen(
        (data) {
          try {
            print('Nova notificação recebida via WebSocket: $data');
            final notification = NotificationModel.fromJson(jsonDecode(data));
            addNotification(notification);
          } catch (e) {
            print('Erro ao processar notificação: $e');
          }
        },
        onError: (error) {
          print('Erro no WebSocket: $error');
          _isConnected = false;
          notifyListeners();
        },
        onDone: () {
          print('WebSocket desconectado');
          _isConnected = false;
          notifyListeners();
        },
      );
    } catch (e) {
      print('Erro ao conectar WebSocket: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  // Desconecta do WebSocket
  void disconnectWebSocket() {
    try {
      _channel?.sink.close(status.goingAway);
      _isConnected = false;
      notifyListeners();
      print('WebSocket desconectado manualmente');
    } catch (e) {
      print('Erro ao desconectar WebSocket: $e');
    }
  }

  // Reseta completamente o serviço de notificações
  void reset() {
    _notifications = [];
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    notifyListeners();
    print('NotificationService resetado completamente');
  }

  // Método para testar a conexão com o backend
  Future<void> testConnection() async {
    print('=== TESTE DE CONEXÃO COM BACKEND ===');
    
    try {
      // Teste 1: Verificar se há token
      final token = await _getAuthToken();
      if (token == null) {
        print('❌ ERRO: Nenhum token encontrado no SharedPreferences');
        print('O usuário precisa fazer login primeiro');
        return;
      }
      print('✅ Token encontrado');
      
      // Teste 2: Testar endpoint de notificações
      final url = '$baseUrl/api/notifications';
      print('🔗 Testando URL: $url');
      
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      print('📡 Fazendo requisição...');
      final response = await http.get(Uri.parse(url), headers: headers);
      
      print('📊 Status da resposta: ${response.statusCode}');
      print('📄 Body da resposta: ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ SUCESSO: Backend respondeu corretamente');
        
        // Tentar parsear a resposta
        try {
          final data = jsonDecode(response.body);
          print('✅ JSON válido recebido');
          print('📋 Estrutura: ${data.runtimeType}');
          
          if (data is Map && data.containsKey('data')) {
            final notifications = data['data'];
            print('📨 Notificações encontradas: ${notifications is List ? notifications.length : 'Não é uma lista'}');
          }
        } catch (e) {
          print('❌ Erro ao parsear JSON: $e');
        }
      } else if (response.statusCode == 401) {
        print('❌ ERRO: Token inválido ou expirado');
        print('O usuário precisa fazer login novamente');
      } else {
        print('❌ ERRO: Falha na requisição (${response.statusCode})');
      }
      
    } catch (e) {
      print('❌ ERRO na conexão: $e');
      print('Verifique se o backend está rodando em $baseUrl');
    }
    
    print('=== FIM DO TESTE ===');
  }

}
