import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_money/account_details_screen.dart';
import 'package:my_money/app_cubit/app_cubit.dart';
import '../Models/Account.dart';
import '../Models/Operation.dart';
import '../accounts_cubit/accounts_cubit.dart';
import 'package:hive/hive.dart';

part 'newoperation_state.dart';

class NewoperationCubit extends Cubit<NewoperationState> {
  NewoperationCubit() : super(NewoperationInitial());
  static NewoperationCubit get(context) => BlocProvider.of(context);
  OperationType currenttab = OperationType.cashout;
  late Operation anOperationForEditing;
  bool isEditing = false;
  Account? fromAccount;
  Account? toTheAccount;
  bool fromAccountValid = true;
  bool toAccountValid = true;
  bool valueValid = true;
  bool nameValid = true;
  bool dateValid = true;
  bool timeValid = true;

  bool validate(
      {required AccountsCubit accountsCubit,
      required String value,
      required String name,
      required String notes,
      required String date,
      required String time,
      Operation? theOperation}) {
    if (fromAccount == null) {
      fromAccountValid = false;
    } else {
      fromAccountValid = true;
      if (currenttab == OperationType.transfare) {
        toAccountValid = toTheAccount == null ? false : true;
      } else {
        toAccountValid = true;
      }
      if (value == "") {
        valueValid = false;
      } else {
        double? doubleValue = double.tryParse(value);
        if (doubleValue == null || doubleValue == 0) {
          valueValid = false;
        } else {
          valueValid = true;
          if (name == "") {
            switch (currenttab) {
              case OperationType.cashout:
                name = "مصروفات";
                break;
              case OperationType.cashIn:
                name = "دخل";
                break;
              case OperationType.transfare:
                name = "تحويل";
                break;
            }
          } else {
            nameValid = true;
            if (date == "") {
              dateValid = false;
            } else {
              dateValid = true;
              toAccountValid = time == "" ? false : true;
            }
          }
        }
      }
    }
    bool result = fromAccountValid &&
        toAccountValid &&
        valueValid &&
        nameValid &&
        dateValid &&
        timeValid;

    if (result) {
      if (isEditing) {
        saveOperation(
            accountsCubit: accountsCubit,
            value: value,
            name: name,
            notes: notes,
            date: date,
            time: time,
            theOperation: anOperationForEditing);
      } else {
        saveOperation(
            accountsCubit: accountsCubit,
            value: value,
            name: name,
            notes: notes,
            date: date,
            time: time);
      }
    } else {
      emit(NewoperationInitial());
    }
    return result;
  }

  Future<void> saveOperation(
      {required AccountsCubit accountsCubit,
      required String value,
      required String name,
      required String notes,
      required String date,
      required String time,
      Operation? theOperation}) async {
    DateTime current = DateTime.now();
    String operationId =
        "${current.year}${current.month}${current.day}${current.hour}${current.minute}${current.second}${current.millisecond}";
    current = DateTime(current.year, current.month, current.day, current.hour,
        current.minute, current.second);
    String _thefromAccountId = fromAccount!.id;
    String _thetoAccountId = "";
    double _value = double.parse(value);
    double _fromAccountbalanceAfter = 0;
    double _toAccountbalanceAfter = 0;
    OperationType _operationType = OperationType.cashout;
    if (isEditing) {
      switch (currenttab) {
        case OperationType.cashout:
          _fromAccountbalanceAfter = fromAccount!.balance - _value;
          _operationType = OperationType.cashout;

          //     fromAccount!.balance = _fromAccountbalanceAfter;
          break;
        case OperationType.cashIn:
          _fromAccountbalanceAfter = fromAccount!.balance + _value;
          _operationType = OperationType.cashIn;

          //     fromAccount!.balance = _fromAccountbalanceAfter;
          break;
        case OperationType.transfare:
          _fromAccountbalanceAfter = fromAccount!.balance - _value;
          _toAccountbalanceAfter = toTheAccount!.balance + _value;
          _thetoAccountId = toTheAccount!.id;
          _operationType = OperationType.transfare;
          //    fromAccount!.balance = _fromAccountbalanceAfter;
          //    toTheAccount!.balance = _toAccountbalanceAfter;
          break;
      }
    } else {
      switch (currenttab) {
        case OperationType.cashout:
          _fromAccountbalanceAfter = fromAccount!.balance - _value;
          _operationType = OperationType.cashout;

          fromAccount!.balance = _fromAccountbalanceAfter;
          break;
        case OperationType.cashIn:
          _fromAccountbalanceAfter = fromAccount!.balance + _value;
          _operationType = OperationType.cashIn;

          fromAccount!.balance = _fromAccountbalanceAfter;
          break;
        case OperationType.transfare:
          _fromAccountbalanceAfter = fromAccount!.balance - _value;
          _toAccountbalanceAfter = toTheAccount!.balance + _value;
          _thetoAccountId = toTheAccount!.id;
          _operationType = OperationType.transfare;
          fromAccount!.balance = _fromAccountbalanceAfter;
          toTheAccount!.balance = _toAccountbalanceAfter;
          break;
      }
    }

    var box = Hive.box<Account>('Accounts');
    box.put(fromAccount!.id, fromAccount!);
    if (_operationType == OperationType.transfare) {
      box.put(toTheAccount!.id, toTheAccount!);
    }
    AccountsCubit.listOfAccounts =
        box.values.where((element) => element.deleted == false).toList();

    Operation newOperation = Operation.newOperationInfo(
        id: operationId,
        fromAccountId: _thefromAccountId,
        toAccountId: _thetoAccountId,
        operationName: name,
        value: _value,
        fromAccountBalanceAfter: _fromAccountbalanceAfter,
        toAccountBalanceAfter: _toAccountbalanceAfter,
        dateTime: current,
        operationType: _operationType,
        operationNotes: notes);
    if (isEditing) {
      editOperation(anOperationForEditing, newOperation);
    } else {
      var box = Hive.box<Operation>('Operations');

      await box.put(newOperation.id, newOperation);
      // AppCubit.operationsList.add(newOperation);
      AppCubit.operationsList = box.values.toList();
    }

    accountsCubit.emit(AccountsInitial());
  }

  void changeCurrentTabTO(OperationType _currenttab) {
    currenttab = _currenttab;
    emit(NewoperationInitial());
  }

  Future<void> removeOperation(
      Operation operation, AccountsCubit accountsCubit) async {
    var box = Hive.box<Operation>('Operations');
    var _operation =
        box.values.toList().indexWhere((element) => element.id == operation.id);
    //box.keyAt(key)
    await box.deleteAt(_operation);
    // await box.delete(operation.id);
    // AppCubit.operationsList.remove(operation);
    AppCubit.operationsList = box.values.toList();
    accountsCubit.emit(AccountsInitial());
  }

  Future<void> editOperation(
      Operation theOperation, Operation theNewOne) async {
    theOperation.fromAccountId = theNewOne.fromAccountId;
    theOperation.toAccountId = theNewOne.toAccountId;
    theOperation.operationName = theNewOne.operationName;
    theOperation.value = theNewOne.value;
    theOperation.operationNotes = theNewOne.operationNotes;
    theOperation.operationType = theNewOne.operationType;
    theOperation.toAccountBalanceAfter = theNewOne.toAccountBalanceAfter;
    theOperation.fromAccountBalanceAfter = theNewOne.fromAccountBalanceAfter;
    var box = Hive.box<Operation>('Operations');

    await box.put(theOperation.id, theOperation);
    // AppCubit.operationsList.add(newOperation);
    AppCubit.operationsList = box.values.toList();
    // theOperation.dateTime = theNewOne.dateTime;
  }

  Future<void> saveEditingAccountbalaceOperation(
      Account _theAccount, Account newCopy) async {
    double newBalance = newCopy.balance;
    double currentBalance = _theAccount.balance;
    if (newBalance != currentBalance ||
        _theAccount.balance == newCopy.balance ||
        _theAccount.name == newCopy.name ||
        _theAccount.icon == newCopy.icon ||
        _theAccount.notes == newCopy.notes) {
      double _theValue = 0;
      OperationType _operationType = OperationType.cashIn;
      DateTime current = DateTime.now();
      String operationId =
          "${current.year}${current.month}${current.day}${current.hour}${current.minute}${current.second}";
      current = DateTime(current.year, current.month, current.day, current.hour,
          current.minute, current.second);
      if (newBalance > currentBalance) {
        _theValue = newBalance - currentBalance;
        _operationType = OperationType.cashIn;
      } else if (newBalance < currentBalance) {
        _theValue = currentBalance - newBalance;
        _operationType = OperationType.cashout;
      }
      if (newBalance != currentBalance) {
        Operation newOperation = Operation.newOperationInfo(
            id: operationId,
            fromAccountId: _theAccount.id,
            operationName: "تعديل الرصيد",
            value: _theValue,
            fromAccountBalanceAfter: newBalance,
            dateTime: current,
            operationType: _operationType);
        var box = Hive.box<Operation>('Operations');

        await box.put(newOperation.id, newOperation);
        // AppCubit.operationsList.add(newOperation);
        AppCubit.operationsList = box.values.toList();
      }

      _theAccount.balance = newCopy.balance;
      _theAccount.name = newCopy.name;
      _theAccount.icon = newCopy.icon;
      _theAccount.notes = newCopy.notes;
      var box = Hive.box<Account>('Accounts');
      box.put(_theAccount.id, _theAccount);
      AccountsCubit.listOfAccounts =
          box.values.where((element) => element.deleted == false).toList();
    }
  }
}
