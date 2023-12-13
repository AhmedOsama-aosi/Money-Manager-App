import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money/Models/Operation.dart';
import 'package:my_money/splashScreen.dart';
import 'Models/Account.dart';
import 'accountsScreen.dart';
import 'accounts_cubit/accounts_cubit.dart';
import 'app_cubit/app_cubit.dart';
import 'homeScreen.dart';
import 'new_operation_bottom_Sheet.dart';
import 'operationsScreen.dart';
import 'shared/styles/colors.dart';

void main() async {
  // var path = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  Hive.registerAdapter(OperationTypeAdapter());
  Hive.registerAdapter(OperationAdapter());
  Hive.registerAdapter(IconDataAdapter());
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<Operation>('Operations');
  await Hive.openBox<Account>('Accounts');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => AccountsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Money',

        theme: ThemeData(
          // textTheme: GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme),
          textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.white,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.light, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
          ),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: materialBlue,
        ),
        // home: HomeScreen(),
        home: SplashScreen(),
      ),
    );
  }
}

class ScreenNavigator extends StatelessWidget {
  ScreenNavigator({
    Key? key,
  }) : super(key: key);

  int currentIndex = 0;
  List<Widget> screensList = [
    HomeScreen(),
    AccountsScreen(),
    OperationsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) {
        if (current.runtimeType == ChangeIndex) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
          // backgroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Directionality(
              textDirection: TextDirection.rtl,
              child: screensList[currentIndex]),
          bottomNavigationBar: Row(
            children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        currentIndex = 0;
                        appCubit.emit(ChangeIndex());
                      },
                      icon: Icon(Icons.home))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        currentIndex = 1;
                        appCubit.emit(ChangeIndex());
                      },
                      icon: Icon(Icons.account_balance))),
              Expanded(
                  child: IconButton(
                      iconSize: 50,
                      onPressed: () {
                        showNewOperationBottomSheet(context);
                        // showModalBottomSheet(
                        //   backgroundColor: Colors.white,
                        //   useRootNavigator: true,
                        //   enableDrag: true,
                        //   isScrollControlled: true,
                        //   shape: const RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(20),
                        //           topRight: Radius.circular(20))),
                        //   context: context,
                        //   builder: (context) {
                        //     return NewOperationBottomSheet();
                        //   },
                        // );
                      },
                      icon: const CircleAvatar(
                        child: Icon(
                          Icons.add_rounded,
                          size: 50,
                        ),
                        radius: 50,
                      ))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        currentIndex = 2;
                        appCubit.emit(ChangeIndex());
                      },
                      icon: const Icon(Icons.view_list_rounded))),
              Expanded(
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.settings))),
            ],
          ),
        );
      },
    );
  }
}
