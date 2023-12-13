import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/app_cubit/app_cubit.dart';
import 'package:my_money/cubit/newoperation_cubit.dart';
import '../Models/Account.dart';
import '../Models/Operation.dart';
import 'package:my_money/shared/components.dart';
import 'accounts_cubit/accounts_cubit.dart';

showNewOperationBottomSheet(context,
    {Operation? anOperationForEditing, bool isEditing = false}) {
  // Operation? anOperationForEditing;
  // bool isEditing = false;
  bool isValuesHasBeenAssigned = false;
  DateTime currentdatetime = DateTime.now();
  final valueBottomSheetcontroller = TextEditingController();
  final nameBottomSheetcontroller = TextEditingController();
  final notesBottomSheetcontroller = TextEditingController();
  final timeBottomSheetcontroller =
      TextEditingController(text: AppCubit.hourDisplay12H(DateTime.now()));
  final dateBottomSheetcontroller = TextEditingController(
      text:
          "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}");
  if (isEditing) {}
  final formkey = GlobalKey<FormState>();

  showModalBottomSheet(
    backgroundColor: Colors.white,

    useRootNavigator: true,
    //  enableDrag: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (context) => NewoperationCubit(),
        child: BlocBuilder<NewoperationCubit, NewoperationState>(
          buildWhen: (previous, current) {
            if (current.runtimeType == NewoperationInitial) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            AccountsCubit accountsCubit = AccountsCubit.get(context);
            NewoperationCubit newoperationCubit =
                NewoperationCubit.get(context);
            if (isEditing && !isValuesHasBeenAssigned) {
              newoperationCubit.anOperationForEditing = anOperationForEditing!;
              newoperationCubit.isEditing = isEditing;
              final fromAccountResult = AccountsCubit.listOfAccounts
                  .where((element) =>
                      element.id == anOperationForEditing.fromAccountId)
                  .toList();
              newoperationCubit.fromAccount = fromAccountResult[0];
              newoperationCubit
                  .changeCurrentTabTO(anOperationForEditing.operationType);
              if (anOperationForEditing.operationType ==
                  OperationType.transfare) {
                final toAccountResult = AccountsCubit.listOfAccounts
                    .where((element) =>
                        element.id == anOperationForEditing.toAccountId)
                    .toList();
                newoperationCubit.toTheAccount = toAccountResult[0];
              }
              valueBottomSheetcontroller.text =
                  anOperationForEditing.value.toString();
              nameBottomSheetcontroller.text =
                  anOperationForEditing.operationName;
              notesBottomSheetcontroller.text =
                  anOperationForEditing.operationNotes;
              timeBottomSheetcontroller.text =
                  AppCubit.hourDisplay12H(anOperationForEditing.dateTime);

              dateBottomSheetcontroller.text =
                  "${anOperationForEditing.dateTime.day}/${anOperationForEditing.dateTime.month}/${anOperationForEditing.dateTime.year}";
              isValuesHasBeenAssigned = true;
            }
            List<Account> _listOfAccounts = AccountsCubit.listOfAccounts;
            Account? theAccount = newoperationCubit.fromAccount;
            Account? toTheAccount = newoperationCubit.toTheAccount;
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Text(
                          isEditing ? "تعديل العملية" : "عملية جديدة",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        isEditing
                            ? IconButton(
                                onPressed: () {
                                  newoperationCubit.removeOperation(
                                      anOperationForEditing!, accountsCubit);

                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.delete))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  TabBar(newoperationCubit: newoperationCubit),
                  SizedBox(
                    height: 500,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Form(
                          key: formkey,
                          child: Wrap(
                            children: [
                              ChooseAccount(
                                  listOfAccounts: _listOfAccounts,
                                  newoperationCubit: newoperationCubit,
                                  theAccount: theAccount,
                                  vaild: newoperationCubit.fromAccountValid,
                                  fromAcount: true),
                              newoperationCubit.currenttab ==
                                      OperationType.transfare
                                  ? ChooseAccount(
                                      listOfAccounts: _listOfAccounts,
                                      newoperationCubit: newoperationCubit,
                                      theAccount: toTheAccount,
                                      vaild: newoperationCubit.toAccountValid,
                                      fromAcount: false)
                                  : const SizedBox(),
                              TextFieldTemplet(
                                controller: valueBottomSheetcontroller,
                                hintText: "القيمة",
                                keyboardType: TextInputType.number,
                                valid: newoperationCubit.valueValid,
                              ),
                              TextFieldTemplet(
                                controller: nameBottomSheetcontroller,
                                hintText: "اسم العملية",
                                keyboardType: TextInputType.text,
                                valid: newoperationCubit.nameValid,
                              ),
                              TextFieldTemplet(
                                  controller: notesBottomSheetcontroller,
                                  hintText: "الملاحظات",
                                  keyboardType: TextInputType.text),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFieldTemplet(
                                      controller: dateBottomSheetcontroller,
                                      hintText: "التاريخ",
                                      keyboardType: TextInputType.datetime,
                                      valid: newoperationCubit.dateValid,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldTemplet(
                                      controller: timeBottomSheetcontroller,
                                      hintText: "الساعة",
                                      keyboardType: TextInputType.datetime,
                                      valid: newoperationCubit.timeValid,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 15),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 45,
                                  color: const Color(0xFF0466C8),
                                  onPressed: () {
                                    if (isEditing) {
                                      if (newoperationCubit.validate(
                                          accountsCubit: accountsCubit,
                                          value:
                                              valueBottomSheetcontroller.text,
                                          name: nameBottomSheetcontroller.text,
                                          notes:
                                              notesBottomSheetcontroller.text,
                                          date: dateBottomSheetcontroller.text,
                                          time: timeBottomSheetcontroller.text,
                                          theOperation:
                                              anOperationForEditing)) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      if (newoperationCubit.validate(
                                          accountsCubit: accountsCubit,
                                          value:
                                              valueBottomSheetcontroller.text,
                                          name: nameBottomSheetcontroller.text,
                                          notes:
                                              notesBottomSheetcontroller.text,
                                          date: dateBottomSheetcontroller.text,
                                          time:
                                              timeBottomSheetcontroller.text)) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  textColor: Colors.white,
                                  child: const Text("حفظ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

class ChooseAccount extends StatelessWidget {
  const ChooseAccount({
    Key? key,
    required List<Account> listOfAccounts,
    required this.newoperationCubit,
    required this.theAccount,
    required this.vaild,
    required this.fromAcount,
  })  : _listOfAccounts = listOfAccounts,
        super(key: key);

  final List<Account> _listOfAccounts;
  final NewoperationCubit newoperationCubit;
  final Account? theAccount;
  final bool vaild;
  final bool fromAcount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAccountListDialog(context, _listOfAccounts, newoperationCubit,
            fromAcount: fromAcount);
      },
      child: CardBackgroundWithValidation(
        valid: vaild,
        child: Align(
            child: Text(
              theAccount?.name ?? "الحساب",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            alignment: Alignment.center),
      ),
    );
  }
}

Future<dynamic> showAccountListDialog(BuildContext context,
    List<Account> _listOfAccounts, NewoperationCubit newoperationCubit,
    {required bool fromAcount}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          title: Text("الحسابات"),
          content: Container(
            width: 400,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: _listOfAccounts.length,
              itemBuilder: (context, i) {
                return _listOfAccounts[i].deleted
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          if (fromAcount) {
                            newoperationCubit.fromAccount = _listOfAccounts[i];
                          } else {
                            newoperationCubit.toTheAccount = _listOfAccounts[i];
                          }

                          newoperationCubit.emit(NewoperationInitial());
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: Container(
                              height: 90,
                              decoration: cardDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      child: Icon(
                                        _listOfAccounts[i].icon as IconData,
                                        size: 25,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _listOfAccounts[i].name,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _listOfAccounts[i].balance.toString(),
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      );
              },
            ),
          ),
        ),
      );
    },
  );
}

class TabBar extends StatelessWidget {
  TabBar({
    required this.newoperationCubit,
    Key? key,
  }) : super(key: key);
  NewoperationCubit newoperationCubit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 50.0),
      child: Container(
        height: 40,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //  color: const Color(0xFFcddafd),
                color: Color.fromARGB(255, 247, 247, 247),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      newoperationCubit
                          .changeCurrentTabTO(OperationType.cashout);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: newoperationCubit.currenttab == OperationType.cashout
                        ? Container(
                            child: const Center(
                              child: Text(
                                "مصروفات",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF0466C8)),
                          )
                        : Container(
                            child: const Center(
                              child: Text(
                                "مصروفات",
                                style: TextStyle(color: Color(0xFFDA1E37)),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0x00cddafd)),
                          ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      newoperationCubit
                          .changeCurrentTabTO(OperationType.cashIn);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: Center(
                          child: Text(
                        "دخل",
                        style: TextStyle(
                            color: newoperationCubit.currenttab ==
                                    OperationType.cashIn
                                ? Colors.white
                                : const Color(0xFF25A244)),
                      )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            newoperationCubit.currenttab == OperationType.cashIn
                                ? const Color(0xFF0466C8)
                                : const Color(0x00cddafd),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      newoperationCubit
                          .changeCurrentTabTO(OperationType.transfare);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: Center(
                          child: Text(
                        "تحويل",
                        style: TextStyle(
                            color: newoperationCubit.currenttab ==
                                    OperationType.transfare
                                ? Colors.white
                                : Colors.black),
                      )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: newoperationCubit.currenttab ==
                                OperationType.transfare
                            ? const Color(0xFF0466C8)
                            : const Color(0x00cddafd),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
