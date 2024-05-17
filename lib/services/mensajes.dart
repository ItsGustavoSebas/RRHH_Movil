import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/message.dart';
import 'package:rrhh_movil/models/detallesMessage.dart';
import 'package:rrhh_movil/services/server.dart';

class MessageService extends ChangeNotifier {
  List<Message> recentMessages = [];
  List<Messages> messagess = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<void> fetchRecentMessages(String userId) async {
    isLoading = true;

    final response =
        await http.get(Uri.parse('${servidor.baseUrl}/mensaje/nuevos/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> messageJson = json.decode(response.body);
      recentMessages =
          messageJson.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMessages(String userId, String otroId) async {
    isLoading = true;

    final response = await http
        .get(Uri.parse('${servidor.baseUrl}/mensaje/mostrar/$userId/$otroId'));

    if (response.statusCode == 200) {
      final List<dynamic> messagesJson = json.decode(response.body);
      messagess = messagesJson.map((json) => Messages.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(
      String userId, int receptorId, String messageText) async {
    try {
      final response = await http.post(
        Uri.parse('${servidor.baseUrl}/mensaje/enviar/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'receptor_id': receptorId,
          'message': messageText,
        }),
      );

      if (response.statusCode == 200) {
        fetchMessages(userId, receptorId.toString()); // Recarga los detalles del mensaje
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}
