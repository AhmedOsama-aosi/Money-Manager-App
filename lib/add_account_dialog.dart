import 'package:flutter/material.dart';
import 'package:my_money/shared/components.dart';
import 'package:my_money/shared/styles/colors.dart';

import 'accounts_cubit/accounts_cubit.dart';
import '../Models/Account.dart';

addAccountDialog(BuildContext context, AccountsCubit cubit,
    {Account? theAccount}) {
  bool isEditing = theAccount != null;
  return showDialog(
      context: context,
      builder: (context) {
        final namedialogcontroller = TextEditingController();
        final balancedialogcontroller = TextEditingController();
        final notesdialogcontroller = TextEditingController();

        final formkey = GlobalKey<FormState>();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
              //  backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(isEditing ? "تعديل الحساب" : "اضافة حساب"),
              content: AlerrtDialogBody(
                formkey: formkey,
                namedialogcontroller: namedialogcontroller,
                balancedialogcontroller: balancedialogcontroller,
                notesdialogcontroller: notesdialogcontroller,
                cubit: cubit,
                isEditing: isEditing,
                theAccount: isEditing ? theAccount : null,
              )),
        );
      });
}

class AlerrtDialogBody extends StatefulWidget {
  AlerrtDialogBody(
      {Key? key,
      required this.formkey,
      required this.namedialogcontroller,
      required this.balancedialogcontroller,
      required this.notesdialogcontroller,
      required this.cubit,
      required this.isEditing,
      this.theAccount})
      : super(key: key);

  final GlobalKey<FormState> formkey;
  final TextEditingController namedialogcontroller;
  final TextEditingController balancedialogcontroller;
  final TextEditingController notesdialogcontroller;
  final AccountsCubit cubit;
  final bool isEditing;
  final Account? theAccount;
  bool nameValid = true;
  bool balanceValid = true;
  int selectedIcon = 0;
  List<IconData> iconsList = const [
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.credit_card,
    Icons.savings,
  ];
  @override
  State<AlerrtDialogBody> createState() => _AlerrtDialogBodyState();
}

class _AlerrtDialogBodyState extends State<AlerrtDialogBody> {
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      widget.namedialogcontroller.text = widget.theAccount!.name;
      widget.balancedialogcontroller.text =
          widget.theAccount!.balance.toString();
      widget.notesdialogcontroller.text = widget.theAccount!.notes;
      widget.selectedIcon = widget.iconsList.indexOf(widget.theAccount!.icon!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 70,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.iconsList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  widget.selectedIcon = index;
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  backgroundColor: widget.selectedIcon == index
                                      ? primaryblue
                                      : Colors.grey[350],
                                  foregroundColor: Colors.white,
                                  radius: 25,
                                  child: Icon(
                                    widget.iconsList[index],
                                    size: 25,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            TextFieldTemplet(
                hintText: "الاسم",
                keyboardType: TextInputType.text,
                valid: widget.nameValid,
                controller: widget.namedialogcontroller),
            TextFieldTemplet(
                hintText: "القيمة",
                keyboardType: TextInputType.number,
                valid: widget.balanceValid,
                controller: widget.balancedialogcontroller),
            TextFieldTemplet(
                hintText: "الملاحظات",
                keyboardType: TextInputType.text,
                controller: widget.notesdialogcontroller),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                color: const Color(0xFF0466C8),
                onPressed: () {
                  if (widget.formkey.currentState!.validate()) {}
                  if (widget.namedialogcontroller.text == "") {
                    widget.nameValid = false;
                  } else {
                    widget.nameValid = true;
                  }
                  if (widget.balancedialogcontroller.text == "") {
                    widget.balanceValid = false;
                  } else {
                    widget.balanceValid = true;
                  }
                  if (widget.nameValid && widget.balanceValid) {
                    try {
                      if (widget.isEditing) {
                        Account newCopy = Account.newAccountInfo(
                            id: "",
                            name: widget.namedialogcontroller.text,
                            balance: double.parse(
                                widget.balancedialogcontroller.text),
                            icon: widget.iconsList[widget.selectedIcon],
                            notes: widget.notesdialogcontroller.text);

                        widget.cubit.editAccount(widget.theAccount!, newCopy);
                        Navigator.pop(context);
                      } else {
                        widget.cubit.addAccount(
                            name: widget.namedialogcontroller.text,
                            balance: double.parse(
                              widget.balancedialogcontroller.text,
                            ),
                            icon: widget.iconsList[widget.selectedIcon],
                            notes: widget.notesdialogcontroller.text);
                        widget.namedialogcontroller.text = "";
                        widget.balancedialogcontroller.text = "";
                        widget.notesdialogcontroller.text = "";
                        widget.selectedIcon = 0;
                        setState(() {});
                      }
                    } catch (e) {}
                  } else {
                    setState(() {});
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                textColor: Colors.white,
                child: const Text("حفظ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
