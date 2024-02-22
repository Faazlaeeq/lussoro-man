import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_ecommerce/routes/route_manager.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:single_ecommerce/theme/sizes.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar(
      {super.key,
      this.currentIndex = 0,
      this.onPressed,
      this.cartCount,
      this.islogin,
      this.userid});
  final int currentIndex;
  final Function(int i)? onPressed;
  final int? cartCount;
  final String? islogin;
  final String? userid;
  @override
  State<MyBottomNavigationBar> createState() =>
      _MyBottomNavigationBarState(currentIndex);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  var _currentIndex = 0;
  _MyBottomNavigationBarState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          color: MyColors.secondaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      padding: const EdgeInsets.symmetric(
          horizontal: padding1 * 8, vertical: padding3),
      child: SalomonBottomBar(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        itemPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: padding1),
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });

          if (widget.onPressed != null) widget.onPressed!(i);
        },
        items: [
          SalomonBottomBarItem(
            icon: SizedBox(
              height: 30,
              width: 30,
              child: OverflowBox(
                maxHeight: 40,
                maxWidth: 40,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: _currentIndex == 0
                          ? MyColors.primaryColor
                          : Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.all(padding2),
                    child: Image.asset(
                      _currentIndex == 0
                          ? "Assets/Icons/home.png"
                          : "Assets/Icons/home-black.png",
                      alignment: Alignment.center,
                      height: 16,
                      width: 18,
                    ),
                  ),
                ),
              ),
            ),
            title: SizedBox(
                //   width: 50,
                //   child: Text("Home",
                //       textAlign: TextAlign.center,
                //       style: Theme.of(context)
                //           .textTheme
                //           .titleSmall!
                //           .copyWith(fontSize: 11)),
                ),
            selectedColor: MyColors.primaryColor,
          ),
          if (widget.islogin == "1" &&
              (widget.userid != "" && widget.islogin == "1")) ...[
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 30,
                width: 30,
                child: OverflowBox(
                  maxHeight: 40,
                  maxWidth: 40,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _currentIndex == 1
                            ? MyColors.primaryColor
                            : Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(padding2),
                      child: Image.asset(
                        _currentIndex == 1
                            ? "Assets/Icons/favorite-white-outline.png"
                            : "Assets/Icons/favorite-filled-black.png",
                        alignment: Alignment.center,
                        height: 16,
                        width: 18,
                      ),
                    ),
                  ),
                ),
              ),
              title: SizedBox(
                  // width: 50,
                  // // child: Text("Favorites",
                  // //     textAlign: TextAlign.center,
                  // //     style: Theme.of(context)
                  // //         .textTheme
                  // //         .titleSmall!
                  // //         .copyWith(fontSize: 11)),
                  ),
              selectedColor: MyColors.primaryColor,
            )
          ],
          SalomonBottomBarItem(
            icon: SizedBox(
              height: 30,
              width: 30,
              child: OverflowBox(
                maxHeight: 40,
                maxWidth: 40,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: _currentIndex ==
                              ((widget.userid != "" && widget.islogin == "1")
                                  ? 2
                                  : 1)
                          ? MyColors.primaryColor
                          : Colors.transparent),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(padding2),
                        child: Image.asset(
                          _currentIndex ==
                                  ((widget.userid != "" &&
                                          widget.islogin == "1")
                                      ? 2
                                      : 1)
                              ? "Assets/Icons/cart-white.png"
                              : "Assets/Icons/cart.png",
                          alignment: Alignment.center,
                          height: 18,
                          width: 18,
                        ),
                      ),
                      if (widget.cartCount != null && widget.cartCount! > 0)
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Badge(
                              label: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text("${widget.cartCount}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                        )),
                              ),
                            ))
                    ],
                  ),
                ),
              ),
            ),
            title: SizedBox(
                // width: 50,
                // child: Text("Cart",
                //     textAlign: TextAlign.center,
                //     style: Theme.of(context)
                //         .textTheme
                //         .titleSmall!
                //         .copyWith(fontSize: 11)),
                ),
            selectedColor: MyColors.primaryColor,
          ),
          if (widget.islogin == "1" && widget.userid != "") ...[
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 30,
                width: 30,
                child: OverflowBox(
                  maxHeight: 40,
                  maxWidth: 40,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _currentIndex == 3
                            ? MyColors.primaryColor
                            : Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(padding2),
                      child: Image.asset(
                        _currentIndex == 3
                            ? "Assets/Icons/bag.png"
                            : "Assets/Icons/bag-filled.png",
                        alignment: Alignment.center,
                        height: 16,
                        width: 18,
                      ),
                    ),
                  ),
                ),
              ),
              title: SizedBox(
                  // width: 50,
                  // child: Text("Orders",
                  //     textAlign: TextAlign.center,
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .titleSmall!
                  //         .copyWith(fontSize: 11)),
                  ),
              selectedColor: MyColors.primaryColor,
            ),
          ],
          SalomonBottomBarItem(
            icon: SizedBox(
              height: 30,
              width: 30,
              child: OverflowBox(
                maxHeight: 40,
                maxWidth: 40,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: _currentIndex ==
                              ((widget.userid != "" && widget.islogin == "1")
                                  ? 4
                                  : 2)
                          ? MyColors.primaryColor
                          : Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.all(padding2),
                    child: Image.asset(
                      _currentIndex ==
                              ((widget.userid != "" && widget.islogin == "1")
                                  ? 4
                                  : 2)
                          ? "Assets/Icons/profile-white.png"
                          : "Assets/Icons/profile.png",
                      alignment: Alignment.center,
                      height: 16,
                      width: 18,
                    ),
                  ),
                ),
              ),
            ),
            title: SizedBox(
                // width: 50,
                // child: Text("Profile",
                //     textAlign: TextAlign.center,
                //     style: Theme.of(context)
                //         .textTheme
                //         .titleSmall!
                //         .copyWith(fontSize: 11)),
                ),
            selectedColor: MyColors.primaryColor,
          ),
        ],
      ),
    );
    // return Container(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: BottomNavigationBar(
    //       backgroundColor: MyColors.secondaryColor,
    //       selectedItemColor: MyColors.primaryColor,
    //       unselectedItemColor: MyColors.accentColorDark,
    //       items: const <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //           //TODO: change this icon

    //           icon: ImageIcon(AssetImage('icons/home.png')),
    //           label: 'Home',
    //         ),
    //         BottomNavigationBarItem(
    //             //TODO: change this icon

    //             icon: ImageIcon(AssetImage('icons/cart.png')),
    //             label: 'Cart'),
    //         BottomNavigationBarItem(
    //             //TODO: change this icon
    //             icon: ImageIcon(AssetImage('icons/notifications.png')),
    //             label: 'Notifications'),
    //         BottomNavigationBarItem(
    //             //TODO: change this icon

    //             icon: ImageIcon(AssetImage('icons/profile.png')),
    //             label: 'Profile'),
    //       ],
    //     ),
    //   ),
    // );
  }
// }
}

// Widget myBottomNavigationBar(BuildContext context) {

//    return SalomonBottomBar(
//           currentIndex: _currentIndex,
//           onTap: (i) => setState(() => _currentIndex = i),
//           items: [
//             /// Home
//             SalomonBottomBarItem(
//               icon: Icon(Icons.home),
//               title: Text("Home"),
//               selectedColor: Colors.purple,
//             ),

//             /// Likes
//             SalomonBottomBarItem(
//               icon: Icon(Icons.favorite_border),
//               title: Text("Likes"),
//               selectedColor: Colors.pink,
//             ),

//             /// Search
//             SalomonBottomBarItem(
//               icon: Icon(Icons.search),
//               title: Text("Search"),
//               selectedColor: Colors.orange,
//             ),

//             /// Profile
//             SalomonBottomBarItem(
//               icon: Icon(Icons.person),
//               title: Text("Profile"),
//               selectedColor: Colors.teal,
//             ),
//           ],
//         ),
//   // return Container(
//   //   child: Padding(
//   //     padding: const EdgeInsets.all(8.0),
//   //     child: BottomNavigationBar(
//   //       backgroundColor: MyColors.secondaryColor,
//   //       selectedItemColor: MyColors.primaryColor,
//   //       unselectedItemColor: MyColors.accentColorDark,
//   //       items: const <BottomNavigationBarItem>[
//   //         BottomNavigationBarItem(
//   //           //TODO: change this icon

//   //           icon: ImageIcon(AssetImage('icons/home.png')),
//   //           label: 'Home',
//   //         ),
//   //         BottomNavigationBarItem(
//   //             //TODO: change this icon

//   //             icon: ImageIcon(AssetImage('icons/cart.png')),
//   //             label: 'Cart'),
//   //         BottomNavigationBarItem(
//   //             //TODO: change this icon
//   //             icon: ImageIcon(AssetImage('icons/notifications.png')),
//   //             label: 'Notifications'),
//   //         BottomNavigationBarItem(
//   //             //TODO: change this icon

//   //             icon: ImageIcon(AssetImage('icons/profile.png')),
//   //             label: 'Profile'),
//   //       ],
//   //     ),
//   //   ),
//   // );
// }
