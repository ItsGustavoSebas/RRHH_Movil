import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/screens/screens.dart';
import 'package:rrhh_movil/services/services.dart';

class MessageListScreen extends StatelessWidget {
  final String userId;

  MessageListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final messageService = Provider.of<MessageService>(context, listen: false);
    messageService.fetchRecentMessages(userId);

    return Scaffold(
      appBar: AppBar(title: Text('Mensajes Recientes')),
      body: Consumer<MessageService>(
        builder: (context, messageService, child) {
          if (messageService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: messageService.recentMessages.length,
            itemBuilder: (context, index) {
              var message = messageService.recentMessages[index];
              return ListTile(
                title: Text(message.name),
                subtitle: Text(message.lastMessage),
                leading: message.avatar != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            'http://137.184.179.201/${message.avatar}'))
                    : CircleAvatar(child: Text(message.name[0])),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        currentUserId: userId,
                        otherUserId: message.id,
                        otherUserName: message.name,
                        avatar: message.avatar,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserListScreen(userId: userId),
            ),
          );
        },
      ),
    );
  }
}
