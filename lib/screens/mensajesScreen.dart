import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/screens/screens.dart';
import 'package:rrhh_movil/services/services.dart';

final GlobalKey<NavigatorState> _chatScreenKey = GlobalKey<NavigatorState>();

class MessageListScreen extends StatefulWidget {
  final String userId;

  MessageListScreen({required this.userId});

  @override
  _MessageListScreenState createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  MessageService? messageService;
  @override
  void initState() {
    super.initState();
    messageService = Provider.of<MessageService>(context, listen: false);
    messageService!.fetchRecentMessages(widget.userId);
    messageService!.startPollingList(widget.userId);
  }

  @override
  void dispose() {
    messageService!.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mensajes Recientes')),
      body: Consumer<MessageService>(
        builder: (context, messageService, child) {
          if (messageService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              await messageService.fetchRecentMessages(widget.userId);
            },
            child: ListView.builder(
              itemCount: messageService.recentMessages.length,
              itemBuilder: (context, index) {
                var message = messageService.recentMessages[index];
                return ListTile(
                  title: Text(message.name),
                  subtitle: Text(message.lastMessage),
                  leading: message.avatar != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://10.0.2.2:8000/${message.avatar}'))
                      : CircleAvatar(child: Text(message.name[0])),
                  trailing: message.pendiente > 0
                      ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Text(
                            message.pendiente.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          key: _chatScreenKey,
                          currentUserId: widget.userId,
                          otherUserId: message.id,
                          otherUserName: message.name,
                          avatar: message.avatar,
                        ),
                      ),
                    ).then((needsReload) {
                      if (needsReload == true) {
                        messageService.fetchRecentMessages(widget.userId);
                      }
                    });
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserListScreen(userId: widget.userId),
            ),
          );
        },
      ),
    );
  }
}
