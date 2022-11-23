import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/Model/User.dart';
import 'package:hive_flutter/adapters.dart';
import 'AddUser.dart';

const UserBoxName = 'users';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(GenderAdapter());
  await Hive.openBox<User>(UserBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtSearch = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<User>(UserBoxName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("HIVE CRUD"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: txtSearch,
              onChanged: (value) {
                searchKeywordNotifier.value = txtSearch.text;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(CupertinoIcons.search),
                  hintText: 'Search User...'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<User>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      final List<User> items;
                      if (txtSearch.text.isEmpty) {
                        items = box.values.toList();
                      } else {
                        items = box.values
                            .where((task) =>
                                task.firstName.contains(txtSearch.text) ||
                                task.lastName.contains(txtSearch.text))
                            .toList();
                      }
                      if (items.isNotEmpty) {
                        return ListView.builder(
                            itemCount: items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: listViewHeader(context),
                                );
                              } else {
                                final User user = items[index - 1];
                                return UserItem(user);
                              }
                            });
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.hourglass_empty),
                            SizedBox(height: 20),
                            Text("Click + to Add New User"),
                            SizedBox(height: 200),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddUser(
                    user: User(),
                  )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget listViewHeader(BuildContext context) {
    final box = Hive.box<User>(UserBoxName);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: ListTile(
            dense: true,
            title: Text(
              "LongPress to Delete",
              style: TextStyle(fontSize: 14),
            ),
            leading: CircleAvatar(
                backgroundColor: Color(0xffeaeff5),
                child: Icon(
                  Icons.touch_app_outlined,
                  color: Colors.black54,
                )),
          ),
        ),
        MaterialButton(
          onPressed: () {
            box.clear();
          },
          color: const Color(0xffeaeff5),
          elevation: 0,
          child: Row(
            children: const [
              Text("Delete All"),
              SizedBox(width: 4),
              Icon(
                CupertinoIcons.delete_solid,
                color: Colors.black54,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget UserItem(User user) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddUser(user: user),
        ));
      },
      onLongPress: () {
        user.delete();
      },
      child: Card(
        child: ListTile(
          minLeadingWidth: 0,
          leading: SizedBox(
            width: 20,
            height: 48,
            child: Icon(
                user.gender == Gender.male ? Icons.male : Icons.female,
                color: user.gender == Gender.male
                    ? Colors.blueAccent.shade100
                    : Colors.pinkAccent.shade100),
          ),
          title: Text("${user.firstName} ${user.lastName}",
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(user.email,
              style: const TextStyle(color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          trailing: Text(user.phone),
        ),
      ),
    );
  }
}

//
// class UserItem extends StatefulWidget {
//   const UserItem({
//     Key? key,
//     required this.user,
//   }) : super(key: key);
//
//   final User user;
//
//   @override
//   State<UserItem> createState() => _UserItemState();
// }
//
// class _UserItemState extends State<UserItem> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => AddUser(user: widget.user),
//         ));
//       },
//       onLongPress: () {
//         widget.user.delete();
//       },
//       child: Card(
//         child: ListTile(
//           minLeadingWidth: 0,
//           leading: SizedBox(
//             width: 20,
//             height: 48,
//             child: Icon(
//                 widget.user.gender == Gender.male ? Icons.male : Icons.female,
//                 color: widget.user.gender == Gender.male
//                     ? Colors.blueAccent.shade100
//                     : Colors.pinkAccent.shade100),
//           ),
//           title: Text("${widget.user.firstName} ${widget.user.lastName}",
//               maxLines: 1, overflow: TextOverflow.ellipsis),
//           subtitle: Text(widget.user.email,
//               style: const TextStyle(color: Colors.black54),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis),
//           trailing: Text(widget.user.phone),
//         ),
//       ),
//     );
//   }
// }
