import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/app_cubit/app_cubit.dart';
import 'package:my_money/cubit/newoperation_cubit.dart';

import '../Models/Account.dart';
import '../Models/Operation.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  AccountsCubit() : super(AccountsInitial());
  static AccountsCubit get(context) => BlocProvider.of(context);
  static List<Account> listOfAccounts = [];
  //  [
  //   Account.newAccountInfo(
  //       id: "1",
  //       name: "بنك مصر",
  //       balance: 1500.0,
  //       icon: Icons.account_balance,
  //       operations: []),
  //   Account.newAccountInfo(
  //       id: "2",
  //       name: "بنك القاهرة",
  //       balance: 1400.0,
  //       icon: Icons.account_balance,
  //       operations: []),
  //   Account.newAccountInfo(
  //       id: "3",
  //       name: "محفظة",
  //       balance: 1400.0,
  //       icon: Icons.account_balance_wallet,
  //       operations: []),
  // ];

  Future<void> addAccount({
    required String name,
    required double balance,
    required IconData icon,
    required String notes,
  }) async {
    DateTime current = DateTime.now();
    String accountId =
        "${current.year}${current.month}${current.day}${current.hour}${current.minute}${current.second}";
    var box = Hive.box<Account>('Accounts');

    await box.put(
        accountId,
        Account.newAccountInfo(
            id: accountId,
            name: name,
            balance: balance,
            icon: icon,
            notes: notes));
    // AppCubit.operationsList.add(newOperation);
    listOfAccounts =
        box.values.where((element) => element.deleted == false).toList();
    // listOfAccounts.add(
    //   Account.newAccountInfo(
    //       id: accountId,
    //       name: name,
    //       balance: balance,
    //       icon: icon,
    //       notes: notes),
    // );
    emit(AccountsInitial());
  }

  void removeAccount(Account _theAccount, int operationsCount) {
    var box = Hive.box<Account>('Accounts');
    if (operationsCount > 0) {
      _theAccount.deleted = true;
      box.put(_theAccount.id, _theAccount);
      listOfAccounts =
          box.values.where((element) => element.deleted == false).toList();
    } else {
      // listOfAccounts.remove(_theAccount);
      box.delete(_theAccount.id);
      listOfAccounts =
          box.values.where((element) => element.deleted == false).toList();
    }

    emit(AccountsInitial());
  }

  void editAccount(Account _theAccount, Account newCopy) {
    // _theAccount.name = newCopy.name;
    // _theAccount.balance = newCopy.balance;
    // _theAccount.notes = newCopy.notes;
    // _theAccount.icon = newCopy.icon;
    NewoperationCubit().saveEditingAccountbalaceOperation(_theAccount, newCopy);
    emit(AccountsInitial());
  }
}

// class Account {
//   late String id;
//   late String name;
//   late double balance;
//   late IconData icon;
//   String notes = "";
//   late List<Operation> operations;
//   bool deleted = false;

//   Account(
//       {required String theId,
//       required String theName,
//       String theNotes = "",
//       required double theBalance,
//       required IconData theIcon,
//       List<Operation>? theOperations}) {
//     id = theId;
//     name = theName;
//     balance = theBalance;
//     icon = theIcon;
//     notes = theNotes;
//     operations = theOperations ?? [];
//   }
// }

// class Operation {
//   late String id;
//   late String fromAccountId;
//   String toAccountId = "";
//   late String operationName;
//   late String operationNotes;
//   late double value;
//   late double fromAccountBalanceAfter;
//   double toAccountBalanceAfter = 0;
//   late DateTime dateTime;
//   late OperationType operationType;
//   Operation(
//       {required String theId,
//       required String thefromAccountId,
//       String thetoAccountId = "",
//       required String theOperationName,
//       String theOperationNotes = "",
//       required double theValue,
//       required double theFromAccountBalanceAfter,
//       double theToAccountBalanceAfter = 0,
//       required DateTime theDateTime,
//       required OperationType theOperationType}) {
//     id = theId;
//     fromAccountId = thefromAccountId;
//     toAccountId = thetoAccountId;
//     operationName = theOperationName;
//     operationNotes = theOperationNotes;
//     value = theValue;
//     fromAccountBalanceAfter = theFromAccountBalanceAfter;
//     toAccountBalanceAfter = theToAccountBalanceAfter;
//     operationType = theOperationType;
//     dateTime = theDateTime;
//   }
// }
