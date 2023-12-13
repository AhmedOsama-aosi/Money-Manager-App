import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../Models/Operation.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);
  static List<Operation> operationsList = [];

  //  [
  //   Operation.newOperationInfo(
  //       id: "11",
  //       fromAccountId: "1",
  //       operationName: "فاتورة",
  //       value: 100,
  //       fromAccountBalanceAfter: 1300,
  //       dateTime: DateTime(2022, 2, 20, 17, 30),
  //       operationType: OperationType.cashout),
  //   Operation.newOperationInfo(
  //       id: "12",
  //       fromAccountId: "1",
  //       operationName: "عائد",
  //       value: 200,
  //       fromAccountBalanceAfter: 1500,
  //       dateTime: DateTime(2022, 3, 20, 7, 30),
  //       operationType: OperationType.cashIn),
  //   Operation.newOperationInfo(
  //       id: "31",
  //       fromAccountId: "3",
  //       operationName: "اجرة",
  //       value: 100,
  //       fromAccountBalanceAfter: 1300,
  //       dateTime: DateTime(2022, 2, 20, 17, 30),
  //       operationType: OperationType.cashout),
  //   Operation.newOperationInfo(
  //       id: "32",
  //       fromAccountId: "3",
  //       operationName: "دخل",
  //       value: 200,
  //       fromAccountBalanceAfter: 1500,
  //       dateTime: DateTime(2022, 3, 20, 7, 30),
  //       operationType: OperationType.cashIn),
  // ];
  static String hourDisplay12H(DateTime time) {
    String string_time = "";
    if (time.hour > 11) {
      if (time.hour == 12) {
        string_time = "${12}:${time.minute} PM";
      } else {
        string_time = "${time.hour - 12}:${time.minute} PM";
      }
    } else {
      if (time.hour == 0) {
        string_time = "${12}:${time.minute} AM";
      } else {
        string_time = "${time.hour}:${time.minute} AM";
      }
    }
    return string_time;
  }

  static String threeDigitSperator(double mony) {
    String stotal = mony.toStringAsFixed(2);
    String stotal2 = "";
    int count = 0;
    for (var i = stotal.length - 1; i > -1; i--) {
      if (i < stotal.length - 4) {
        count++;
        if (count == 3) {
          stotal2 += ",";
          count = 0;
        }
      }
      stotal2 += stotal[i];
    }
    stotal = "";
    for (var i = stotal2.length - 1; i > -1; i--) {
      stotal += stotal2[i];
    }
    return stotal;
  }
}
