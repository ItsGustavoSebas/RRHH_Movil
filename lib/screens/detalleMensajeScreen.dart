import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final int otherUserId;
  final String otherUserName;
  final String? avatar;

  ChatScreen({
    required Key key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    this.avatar,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  String? _errorMessage;
  MessageService? _messageService;

  @override
  @override
  void initState() {
    super.initState();
    _messageService = Provider.of<MessageService>(context, listen: false);
    _messageService!
        .fetchMessages(widget.currentUserId, widget.otherUserId.toString());
    _messageService!
        .startPolling(widget.currentUserId, widget.otherUserId.toString());
    _messageService!.messagesStream.listen((_) => _scrollToEnd());
  }

  @override
  void dispose() {
    _messageService!.stopPolling();
    super.dispose();
    _scrollController.dispose();
  }

  String formatTime(DateTime dateTime) {
    DateTime adjustedDateTime = adjustDateTime(dateTime);
    return DateFormat('hh:mm a').format(adjustedDateTime);
  }

  String formatTime2(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  String formatDate(DateTime dateTime) {
    DateTime adjustedDateTime = adjustDateTime(dateTime);
    final today = DateTime.now(); // También ajustamos 'hoy'
    final yesterday = today.subtract(Duration(days: 1));

    if (adjustedDateTime.year == today.year &&
        adjustedDateTime.month == today.month &&
        adjustedDateTime.day == today.day) {
      return 'Hoy';
    } else if (adjustedDateTime.year == yesterday.year &&
        adjustedDateTime.month == yesterday.month &&
        adjustedDateTime.day == yesterday.day) {
      return 'Ayer';
    } else {
      return DateFormat('dd MMM yyyy').format(adjustedDateTime);
    }
  }

  DateTime adjustDateTime(DateTime dateTime) {
    return dateTime.subtract(Duration(hours: 4));
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context,
            true); // Return true to indicate that the page needs to be reloaded
        return false; // Prevent the default pop behavior as we have already handled it
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              widget.avatar != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://137.184.179.201/${widget.avatar}'),
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

                  var groupedMessages = <String, List<Messages>>{};
                  for (var message in messageService.messagess) {
                    String dateKey = formatDate(message.createdAt);
                    if (!groupedMessages.containsKey(dateKey)) {
                      groupedMessages[dateKey] = [];
                    }
                    groupedMessages[dateKey]!.add(message);
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToEnd();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      String dateKey = groupedMessages.keys.elementAt(index);
                      List<Messages> messages = groupedMessages[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                dateKey,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          ...messages.map((message) {
                            bool isCurrentUser = message.emisorId.toString() ==
                                widget.currentUserId;

                            return Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.blueAccent
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.mensaje,
                                      style: TextStyle(
                                        color: isCurrentUser
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          formatTime(message
                                              .createdAt), // Usar la hora ajustada
                                          style: TextStyle(
                                            color: isCurrentUser
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (isCurrentUser)
                                          Icon(
                                            message.leido == 1
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 16,
                                            color: message.leido == 1
                                                ? Colors.white70
                                                : Colors.white54,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
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
                                await Provider.of<MessageService>(context,
                                        listen: false)
                                    .sendMessage(
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
      ),
    );
  }
}
