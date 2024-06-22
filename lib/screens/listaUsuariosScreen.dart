import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:rrhh_movil/models/users.dart';
import 'package:rrhh_movil/screens/screens.dart';
final GlobalKey<NavigatorState> _chatScreenKey = GlobalKey<NavigatorState>();
class UserListScreen extends StatelessWidget {
  final String userId;

  UserListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    userService.fetchUsers(userId);

    return Scaffold(
      appBar: AppBar(title: Text('Usuarios Disponibles')),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          if (userService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: userService.users.length,
            itemBuilder: (context, index) {
              Users user = userService.users[index];
              return ListTile(
                title: Text('${user.name} - ${user.cargo}'),
                leading: user.avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            'http://10.0.2.2:8000/${user.avatarUrl}'))
                    : CircleAvatar(child: Text(user.name[0])),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        key: _chatScreenKey,
                        currentUserId: userId,
                        otherUserId: user.id,
                        otherUserName: user.name,
                        avatar: user.avatarUrl,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
