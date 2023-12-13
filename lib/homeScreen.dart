import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money/add_account_dialog.dart';
import 'package:my_money/app_cubit/app_cubit.dart';
import 'package:my_money/shared/components.dart';
import 'package:my_money/shared/styles/colors.dart';

import 'accounts_cubit/accounts_cubit.dart';
import '../Models/Account.dart';
import '../Models/Operation.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
      statusBarColor: Color(0x00FFFFFF),
      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ));
    var accountsBox = Hive.box<Account>('Accounts');
    AccountsCubit.listOfAccounts = accountsBox.values.toList();
    var operationsBox = Hive.box<Operation>('Operations');
    AppCubit.operationsList = operationsBox.values
        .skip(operationsBox.values.length > 30
            ? operationsBox.values.length - 30
            : 0)
        .toList();

    return Container(
      //color: Color.fromARGB(255, 16, 67, 96),
      //color: Colors.blue[800],
      color: primaryblue,
      child: Stack(
        children: [
          grediantBackground(),
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: primaryblue,
                            size: 25,
                          ),
                          radius: 18,
                          backgroundColor: Colors.white,
                        ),
                        Text(
                          "Hello, Ahmed",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  clipBehavior: Clip.none,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Center(
                          child: Text(
                            "Current Balance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<AccountsCubit, AccountsState>(
                          builder: (context, state) {
                            double total = 0.0;
                            //AccountsCubit accountsCubit = AccountsCubit.get(context);
                            for (Account item in AccountsCubit.listOfAccounts) {
                              if (!item.deleted) {
                                total += item.balance;
                              }
                            }

                            return Center(
                              child: Text(
                                "\$" + AppCubit.threeDigitSperator(total),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     color: Colors.white.withOpacity(0.2),
                        //     border:
                        //         Border.all(color: Colors.white.withOpacity(0.4)),
                        //     boxShadow: <BoxShadow>[
                        //       BoxShadow(
                        //           color: Colors.white.withOpacity(0.3),
                        //           blurRadius: 100,
                        //           offset: const Offset(0, 0),
                        //           blurStyle: BlurStyle.normal,
                        //           spreadRadius: 0),
                        //     ],
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Expanded(
                        //           child: Column(
                        //             children: const [
                        //               Text(
                        //                 "اجمالي المصروفات",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                     fontSize: 18, color: textColor),
                        //               ),
                        //               Text(
                        //                 "493.0",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                     fontSize: 30,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: Color(0xFFDA1E37)),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Container(
                        //           color: const Color(0xFFADB5BD),
                        //           height: 35,
                        //           width: 0.8,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             children: const [
                        //               Text(
                        //                 "اجمالي الدخل",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                     fontSize: 18, color: textColor),
                        //               ),
                        //               Text(
                        //                 "257.0",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                     fontSize: 30,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: Color(0xFF25A244)),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<AccountsCubit, AccountsState>(
                builder: (context, state) {
                  AccountsCubit accountsCubit = AccountsCubit.get(context);
                  List<Map> listOfOperations = [];
                  for (Operation operation in AppCubit.operationsList) {
                    final fromAccountResult = AccountsCubit.listOfAccounts
                        .where(
                            (element) => element.id == operation.fromAccountId)
                        .toList();
                    String accountname = "";
                    if (fromAccountResult.isNotEmpty) {
                      accountname = fromAccountResult[0].name;
                    }
                    if (operation.operationType == OperationType.transfare) {
                      final toAccountresult = AccountsCubit.listOfAccounts
                          .where(
                              (element) => element.id == operation.toAccountId)
                          .toList();

                      if (toAccountresult.isNotEmpty) {
                        accountname =
                            "${fromAccountResult[0].name} > ${toAccountresult[0].name}";
                      }

                      listOfOperations.add({
                        "theOperation": operation,
                        "name": operation.operationName,
                        "value": operation.value,
                        "type": operation.operationType,
                        "balanceAfter":
                            "${operation.toAccountBalanceAfter} - ${operation.fromAccountBalanceAfter}",
                        "account": accountname,
                        "date": operation.dateTime
                      });
                    } else {
                      if (!fromAccountResult[0].deleted)
                        listOfOperations.add({
                          "theOperation": operation,
                          "name": operation.operationName,
                          "value": operation.value,
                          "type": operation.operationType,
                          "balanceAfter": operation.fromAccountBalanceAfter,
                          "account": accountname,
                          "date": operation.dateTime
                        });
                    }
                  }
                  // for (Account account in accountsCubit.listOfAccounts) {
                  //   for (Operation operation in account.operations) {
                  //     if (operation.operationType == OperationType.transfare) {
                  //       if (operation.fromAccountId == account.id) {
                  //         final result = accountsCubit.listOfAccounts
                  //             .where((element) => element.id == operation.toAccountId)
                  //             .toList();
                  //         String accountname = "";
                  //         if (result.isNotEmpty) {
                  //           Account toAccount = result[0];
                  //           accountname = "${account.name} > ${toAccount.name}";
                  //         }

                  //         listOfOperations.add({
                  //           "theOperation": operation,
                  //           "name": operation.operationName,
                  //           "value": operation.value,
                  //           "type": operation.operationType,
                  //           "balanceAfter":
                  //               "${operation.toAccountBalanceAfter} - ${operation.fromAccountBalanceAfter}",
                  //           "account": accountname,
                  //           "date": operation.dateTime
                  //         });
                  //       }
                  //     } else {
                  //       listOfOperations.add({
                  //         "theOperation": operation,
                  //         "name": operation.operationName,
                  //         "value": operation.value,
                  //         "type": operation.operationType,
                  //         "balanceAfter": operation.fromAccountBalanceAfter,
                  //         "account": account.name,
                  //         "date": operation.dateTime
                  //       });
                  //     }

                  //     // listOfOperations.add(Operation(
                  //     //     theId: operation.id,
                  //     //     thefromAccountId: operation.fromAccountId,
                  //     //     theOperationName: operation.operationName,
                  //     //     theValue: operation.value,
                  //     //     theBalanceAfter: operation.balanceAfter,
                  //     //     theDateTime: operation.dateTime,
                  //     //     theOperationType: operation.operationType));
                  //   }
                  // }
                  listOfOperations.sort(
                    (a, b) => a["date"].compareTo(b["date"]),
                  );
                  listOfOperations = listOfOperations.reversed.toList();
                  return Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  child: Text(
                                    "Last 30",
                                    style: TextStyle(
                                        fontSize: 15, color: lightGreyColor),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  child: Text(
                                    "Operations List",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                padding: EdgeInsets.zero,
                                itemCount: listOfOperations.length,
                                itemBuilder: (context, i) {
                                  return OperationCard(
                                    theOperation: listOfOperations[i]
                                        ["theOperation"],
                                    operationType: listOfOperations[i]["type"],
                                    topRight: listOfOperations[i]["name"],
                                    topLeft:
                                        listOfOperations[i]["value"].toString(),
                                    downRight: listOfOperations[i]["account"],
                                    downLeft: listOfOperations[i]
                                            ["balanceAfter"]
                                        .toString(),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
