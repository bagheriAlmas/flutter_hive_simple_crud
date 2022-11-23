import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'Model/User.dart';
import 'main.dart';

class AddUser extends StatefulWidget {
  final User user;
  const AddUser({Key? key,required this.user}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  int group = 1;
  IconData radioIcon = Icons.male;
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();

  InputDecoration decoration(String label, Icon icon) {
    return InputDecoration(
        border: const OutlineInputBorder(), labelText: label, prefixIcon: icon);
  }

  @override
  void initState() {
    group = widget.user.gender == Gender.male ? 1 : 0;
    txtFirstName.text = widget.user.firstName;
    txtLastName.text = widget.user.lastName;
    txtPhone.text = widget.user.phone;
    txtEmail.text = widget.user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.user.isInBox ? const Text("Edit User") : const Text("Add User")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: txtFirstName,
                        decoration:
                            decoration("FirstName", const Icon(Icons.person)))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: txtLastName,
                        decoration: decoration(
                            "LastName", const Icon(Icons.family_restroom)))),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black45, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    radioIcon,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 50),
                  const Text("Male"),
                  Radio(
                    value: 1,
                    groupValue: group,
                    onChanged: (value) {
                      setState(() {
                        group = value!;
                        radioIcon = Icons.male;
                      });
                    },
                  ),
                  const SizedBox(width: 50),
                  const Text("Female"),
                  Radio(
                    value: 0,
                    groupValue: group,
                    onChanged: (value) {
                      setState(() {
                        group = value!;
                        radioIcon = Icons.female;
                      });
                    },
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: txtPhone,
                keyboardType: TextInputType.phone,
                decoration: decoration("Phone", const Icon(Icons.phone))),
            const SizedBox(height: 10),
            TextField(
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: decoration("Email", const Icon(Icons.alternate_email))),
            const SizedBox(height: 50),
            ElevatedButton(onPressed: () {
              widget.user.firstName = txtFirstName.text;
              widget.user.lastName = txtLastName.text;
              widget.user.gender = group==1? Gender.male : Gender.female;
              widget.user.phone = txtPhone.text;
              widget.user.email = txtEmail.text;

              if (widget.user.isInBox) {
                widget.user.save();
              } else {
                final Box<User> box = Hive.box(UserBoxName);
                box.add(widget.user);
              }
              Navigator.pop(context);
            }, child: widget.user.isInBox ? const Text("Edit User") : const Text("Add User"))
          ],
        ),
      ),
    );
  }
}
