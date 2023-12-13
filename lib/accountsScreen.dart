import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/account_details_screen.dart';
import 'package:my_money/shared/components.dart';
import 'accounts_cubit/accounts_cubit.dart';
import 'add_account_dialog.dart';
import '../Models/Account.dart';

class AccountsScreen extends StatelessWidget {
  bool showGrid = true;

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0x00FFFFFF),
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ));
    return BlocBuilder<AccountsCubit, AccountsState>(
      builder: (context, state) {
        AccountsCubit accountsCubit = AccountsCubit.get(context);
        List<Account> _listOfAccounts = AccountsCubit.listOfAccounts
            .where((element) => element.deleted == false)
            .toList();
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Accounts",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000)),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          showGrid = !showGrid;
                          accountsCubit.emit(AccountsInitial());
                        },
                        icon: Icon(showGrid
                            ? Icons.view_list_rounded
                            : Icons.grid_view_outlined)),
                    IconButton(
                        onPressed: () {
                          addAccountDialog(context, accountsCubit);
                          // accountsCubit.addAccount();
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              showGrid
                  ? AccountsGridView(
                      listOfAccounts: AccountsCubit.listOfAccounts)
                  : AccountsListView(
                      listOfAccounts: AccountsCubit.listOfAccounts)
            ],
          ),
        );
      },
    );
  }
}

class AccountsListView extends StatelessWidget {
  const AccountsListView({
    Key? key,
    required List<Account> listOfAccounts,
  })  : _listOfAccounts = listOfAccounts,
        super(key: key);

  final List<Account> _listOfAccounts;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: _listOfAccounts.length,
        itemBuilder: (context, i) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 90,
                decoration: cardDecoration(),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountDetails(
                                  theAccount: _listOfAccounts[i],
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          child: Icon(
                            _listOfAccounts[i].icon,
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
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.fade),
                        ),
                        const Spacer(),
                        Text(
                          _listOfAccounts[i].balance.toString(),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}

class AccountsGridView extends StatelessWidget {
  AccountsGridView({
    Key? key,
    required this.listOfAccounts,
  }) : super(key: key);

  final List<Account> listOfAccounts;
  List<Widget> listt = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < listOfAccounts.length; i++) {
      listt.add(Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
            //clipBehavior: Clip.antiAlias,
            decoration: cardDecoration(),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountDetails(
                              theAccount: listOfAccounts[i],
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: Icon(
                      listOfAccounts[i].icon,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    listOfAccounts[i].name,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    listOfAccounts[i].balance.toString(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            )),
      ));
    }
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        crossAxisCount: 2,
        children: listt,
      ),
    );
  }
}
