import 'dart:async';
import 'dart:io';

import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import 'filter.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();

  CartCounter counter = CartCounter();

  var _children = [];

  fetchAll(){
    getCartCount();
  }

  void onTapped(int i) {
    fetchAll();
    if (!is_logged_in.$ && ( i == 2)) {
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if(i== 3){
      app_language_rtl.$ ?slideLeftWidget(newPage: Profile(), context: context):slideRightWidget(newPage: Profile(), context: context);
      return;
    }

    setState(() {
      _currentIndex = i;
    });
    //print("i$i");
  }

  getCartCount()async {

    Provider.of<CartCounter>(context, listen: false).getCount();

  }

  void initState() {
    _children = [
      Home(counter: counter,),
      CategoryList(
        is_base_category: true,

      ),
      Cart(has_bottomnav: true,from_navigation:true,counter: counter,),
      Profile()
    ];
    fetchAll();
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        print("_currentIndex");
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
        app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          //specify the location of the FAB
          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom ==
                0.0, // if the kyeboard is open then hide, else show
            child: FloatingActionButton(
              highlightElevation: 10.0,
              backgroundColor: MyTheme.white,
              onPressed: () {},
              tooltip: "start FAB",
              child: Container(
                  margin: EdgeInsets.all(0.0),
                  child: IconButton(
                      icon: new Image.asset('assets/logo_trans.png'),
                      tooltip: 'Action',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return Filter(
                                selected_filter: "sellers",
                              );
                            }));
                      })),
              elevation: 0.0,
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: MyTheme.white,
            clipBehavior: Clip.hardEdge,
            shape: CircularNotchedRectangle(),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTapped,
              currentIndex: _currentIndex,
              backgroundColor: Colors.white.withOpacity(0.8),
              fixedColor: MyTheme.accent_color,
              unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/home.png",
                      color: _currentIndex == 0
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 20,
                    ),
                    label: AppLocalizations.of(context)
                        .main_screen_bottom_navigation_home),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/categories.png",
                      color: _currentIndex == 1
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 20,
                    ),
                    label: AppLocalizations.of(context)
                        .main_screen_bottom_navigation_categories),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.circle,
                    color: Colors.transparent,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/cart.png",
                      color: _currentIndex == 3
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 20,
                    ),
                    label: AppLocalizations.of(context)
                        .main_screen_bottom_navigation_cart=='العربة'?'السلة':
                    AppLocalizations.of(context)
                        .main_screen_bottom_navigation_cart),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/profile.png",
                    color: _currentIndex == 4
                        ? Theme.of(context).accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  label: AppLocalizations.of(context)
                      .main_screen_bottom_navigation_profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
