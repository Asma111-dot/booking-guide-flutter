import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'account_page.dart';
import 'chalets_page.dart';
import 'my_reservations_page.dart';
import '../../utils/theme.dart';

class MainLayout extends StatefulWidget {
  final int currentIndex;
  final Widget? child;

  const MainLayout({Key? key, this.currentIndex = 0, this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int currentPage;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentIndex;
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    // إذا تم تمرير `child`، استخدمه بدلاً من PageView
    if (widget.child != null) {
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (page) {
            setState(() {
              currentPage = page;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(Icons.home),
              label: "الشاليهات",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "حجوزاتي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "الحساب",
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: <Widget>[
         // const ChaletsPage(facilityType:facilitytype ),
          const MyReservationsPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _pageController.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(Icons.home),
            label: "الشاليهات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "حجوزاتي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "الحساب",
          ),
        ],
      ),
    );
  }
}
