import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:my_money/app_cubit/app_cubit.dart';
import 'package:my_money/shared/components.dart';
import 'package:my_money/shared/styles/colors.dart';

import 'accounts_cubit/accounts_cubit.dart';
import 'add_account_dialog.dart';

import '../Models/Account.dart';
import '../Models/Operation.dart';

class AccountDetails extends StatelessWidget {
  AccountDetails({required this.theAccount});
  late Account theAccount;
  bool addToMyBalance = true;
  Color textColor = Colors.white;

  @override
  Widget build(context) {
    return BlocBuilder<AccountsCubit, AccountsState>(
      builder: (context, state) {
        AccountsCubit accountsCubit = AccountsCubit.get(context);
        // List<Operation> listOfOperations = theAccount.operations;
        var box = Hive.box<Operation>('Operations');
        AppCubit.operationsList = box.values.toList();
        List<Operation> listOfOperations = AppCubit.operationsList
            .where((element) =>
                element.fromAccountId == theAccount.id ||
                element.toAccountId == theAccount.id)
            .toList();
        listOfOperations.sort(
          (a, b) => a.dateTime.compareTo(b.dateTime),
        );
        listOfOperations = listOfOperations.reversed.toList();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          theAccount.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          accountsCubit.removeAccount(
                              theAccount, listOfOperations.length);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: cardDecoration(
                          backcolor: primaryblue, shadowColor: Colors.black),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          grediantBackground(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 12.0, 20.0, 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "الرصيد",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        theAccount.icon,
                                        color: textColor,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${AppCubit.threeDigitSperator(theAccount.balance)} ج.م ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: textColor),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      "اضاف الي ارصدتي",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    Switch(
                                        activeColor: Colors.white,
                                        value: addToMyBalance,
                                        onChanged: (value) {
                                          addToMyBalance = !addToMyBalance;
                                          accountsCubit.emit(AccountsInitial());
                                        }),
                                    Spacer(),
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
                                        onPressed: () {
                                          addAccountDialog(
                                              context, accountsCubit,
                                              theAccount: theAccount);
                                        },
                                        icon: CircleAvatar(
                                            maxRadius: 20,
                                            child: Icon(Icons.edit)))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: const [
                      Text(
                        "المعاملات",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xFF000000)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.zero,
                      itemCount: listOfOperations.length,
                      itemBuilder: (context, i) {
                        OperationType operationType =
                            listOfOperations[i].operationType;
                        String balanceAfter = listOfOperations[i]
                            .fromAccountBalanceAfter
                            .toString();
                        if (operationType == OperationType.transfare) {
                          if (listOfOperations[i].fromAccountId ==
                              theAccount.id) {
                            operationType = OperationType.cashout;
                            balanceAfter = listOfOperations[i]
                                .fromAccountBalanceAfter
                                .toString();
                          } else {
                            operationType = OperationType.cashIn;
                            balanceAfter = listOfOperations[i]
                                .toAccountBalanceAfter
                                .toString();
                          }
                        }
                        return OperationCard(
                          theOperation: listOfOperations[i],
                          operationType: operationType,
                          topRight: listOfOperations[i].operationName,
                          topLeft: listOfOperations[i].value.toString(),
                          downRight: "الرصيد",
                          downLeft: balanceAfter,
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
