import 'package:hive/hive.dart';
part 'Operation.g.dart';

@HiveType(typeId: 1)
class Operation {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String fromAccountId;
  @HiveField(2)
  String toAccountId = "";
  @HiveField(3)
  late String operationName;
  @HiveField(4)
  late String operationNotes;
  @HiveField(5)
  late double value;
  @HiveField(6)
  late double fromAccountBalanceAfter;
  @HiveField(7)
  double toAccountBalanceAfter = 0;
  @HiveField(8)
  late DateTime dateTime;
  @HiveField(9)
  late OperationType operationType;
  Operation();
  Operation.newOperationInfo(
      {required this.id,
      required this.fromAccountId,
      this.toAccountId = "",
      required this.operationName,
      this.operationNotes = "",
      required this.value,
      required this.fromAccountBalanceAfter,
      this.toAccountBalanceAfter = 0,
      required this.dateTime,
      required this.operationType});
}

@HiveType(typeId: 2)
enum OperationType {
  @HiveField(0)
  cashIn,
  @HiveField(1)
  cashout,
  @HiveField(2)
  transfare
}
