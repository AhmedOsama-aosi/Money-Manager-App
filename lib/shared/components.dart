import 'package:flutter/material.dart';
import 'package:my_money/accounts_cubit/accounts_cubit.dart';
import 'dart:ui';
import '../new_operation_bottom_Sheet.dart';
import '../Models/Operation.dart';

BoxDecoration cardDecoration(
    {Color backcolor = Colors.white,
    Color shadowColor = const Color.fromARGB(255, 114, 156, 190)}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: backcolor,
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: shadowColor.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 1),
    ],
  );
}

class TextFieldTemplet extends StatelessWidget {
  TextFieldTemplet({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.valid = true,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool valid;

  @override
  Widget build(BuildContext context) {
    return CardBackgroundWithValidation(
      valid: valid,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        decoration:
            InputDecoration(hintText: hintText, border: InputBorder.none),
      ),
    );
  }
}

class CardBackgroundWithValidation extends StatelessWidget {
  const CardBackgroundWithValidation(
      {Key? key, required this.valid, required this.child})
      : super(key: key);
  final Widget child;
  final bool valid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Container(
          height: 60,
          width: double.maxFinite - 200,
          decoration: valid
              ? cardDecoration()
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.red.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                        spreadRadius: 2),
                  ],
                ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 9.0, 8.0, 1.0),
            child: child,
          )),
    );
  }
}

class OperationCard extends StatelessWidget {
  OperationCard({
    required this.operationType,
    required this.theOperation,
    this.topRight,
    this.topLeft,
    this.downRight,
    this.downLeft,
    Key? key,
  }) : super(key: key);
  late Operation theOperation;
  String? topRight;
  String? topLeft;
  String? downRight;
  String? downLeft;
  OperationType operationType;
  @override
  Widget build(BuildContext context) {
    const double? fontsize = 18;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
      child: Container(
        height: 70,
        decoration:
            cardDecoration(shadowColor: Color.fromARGB(255, 141, 182, 202)),
        child: InkWell(
          onTap: () {
            showNewOperationBottomSheet(context,
                anOperationForEditing: theOperation, isEditing: true);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  textDirection: TextDirection.rtl,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 8.0),
                      child: Text(
                        topRight ?? "",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            height: 1,
                            fontSize: fontsize,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        topLeft ?? "",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            height: 1,
                            fontSize: fontsize,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: operationType == OperationType.cashIn
                                ? const Color(0xFF25A244)
                                : operationType == OperationType.cashout
                                    ? const Color(0xFFDA1E37)
                                    : Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 8.0),
                        child: Text(
                          downRight ?? "",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              height: 1,
                              fontSize: 18,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    operationType == OperationType.transfare
                        ? RichText(
                            text: TextSpan(
                                text: theOperation.toAccountBalanceAfter
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                                children: [
                                  const TextSpan(
                                    text: " - ",
                                    children: [],
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: theOperation.fromAccountBalanceAfter
                                        .toString(),
                                    children: [],
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                                ]),
                          )
                        : Text(
                            downLeft ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget grediantBackground() {
  BorderRadius df = const BorderRadius.only(
    bottomLeft: Radius.circular(500),
  );
  return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(50),
              color: Colors.blue[800],
            ),
          ),
          Container(
            height: 400,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: df,
              color: Colors.blue[700],
            ),
          ),
          Container(
            height: 300,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: df,
              color: Colors.blue[600],
            ),
          ),
          Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: df,
              color: Colors.blue[500],
            ),
          ),
          Container(
            height: 500,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          )
        ],
      ));
}
