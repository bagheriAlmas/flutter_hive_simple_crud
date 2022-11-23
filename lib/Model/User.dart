import 'package:hive_flutter/adapters.dart';

part 'User.g.dart';
@HiveType(typeId:0)
class User extends HiveObject{
  @HiveField(0)
  String firstName = '';
  @HiveField(1)
  String lastName = '';
  @HiveField(2)
  Gender gender = Gender.male;
  @HiveField(3)
  String phone = '';
  @HiveField(4)
  String email = '';

}

@HiveType(typeId: 1)
enum Gender{
  @HiveField(0)
  male,
  @HiveField(1)
  female
}