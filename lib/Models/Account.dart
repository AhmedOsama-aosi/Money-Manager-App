import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Models/Operation.dart';

part 'Account.g.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late double balance;
  @HiveField(3)
  IconData? icon;
  @HiveField(4)
  String notes = "";
  @HiveField(5)
  late List<Operation> operations;
  @HiveField(6)
  bool deleted = false;
  Account();

  Account.newAccountInfo(
      {required this.id,
      required this.name,
      this.notes = "",
      required this.balance,
      required this.icon,
      this.operations = const []});
}
