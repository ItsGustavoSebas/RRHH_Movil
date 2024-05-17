import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:rrhh_movil/models/models.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final int otherUserId;
  final String otherUserName;
  final String? avatar;


  ChatScreen({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    this.avatar,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final messageService = Provider.of<MessageService>(context, listen: false);
    messageService.fetchMessages(widget.currentUserId, widget.otherUserId.toString());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            widget.avatar != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage('http://137.184.179.201/${widget.avatar}'),
                  )
                : CircleAvatar(
                    child: Text(widget.otherUserName[0]),
                  ),
            SizedBox(width: 10),
            Text(widget.otherUserName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessageService>(
              builder: (context, messageService, child) {
                if (messageService.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: messageService.messagess.length,
                  itemBuilder: (context, index) {
                    Messages message = messageService.messagess[index];
                    bool isCurrentUser = message.emisorId.toString() == widget.currentUserId;

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.mensaje,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                _isSending
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          if (_messageController.text.isNotEmpty) {
                            setState(() {
                              _isSending = true;
                              _errorMessage = null;
                            });
                            try {
                              await Provider.of<MessageService>(context, listen: false).sendMessage(
                                widget.currentUserId,
                                widget.otherUserId,
                                _messageController.text,
                              );
                              _messageController.clear();
                            } catch (e) {
                              setState(() {
                                _errorMessage = e.toString();
                              });
                            } finally {
                              setState(() {
                                _isSending = false;
                              });
                            }
                          }
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
