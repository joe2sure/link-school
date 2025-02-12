import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkschool/modules/E_library/e_library_dashbord.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/explore/explore_profile/explore_profileScreen.dart';
import '../../common/bottom_navigation_bar.dart';
import '../../common/bottom_nav_item.dart';
import 'explore_home.dart';
import 'package:linkschool/modules/explore/admission/explore_admission.dart';

class ExploreDashboard extends StatefulWidget {
  final Function(bool) onSwitch;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const ExploreDashboard({
    super.key,
    required this.onSwitch,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<ExploreDashboard> createState() => _ExploreDashboardState();
}

class _ExploreDashboardState extends State<ExploreDashboard> {
  bool _showSearchIcon = false;
  late List<Widget> _bodyItems;

  void _onSearchIconVisibilityChanged(bool isVisible) {
    setState(() {
      _showSearchIcon = isVisible;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeBodyItems();
  }

  void _initializeBodyItems() {
    _bodyItems = [
      ExploreHome(
        onSearchIconVisibilityChanged: _onSearchIconVisibilityChanged,
      ),
      ExploreAdmission(
        height: MediaQuery.of(context).size.height,
      ),
      ElibraryDashboard(
        height: MediaQuery.of(context).size.height,
      ),
      ProfileScreen(
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
      ),
    ];
  }

  List<FABBottomAppBarItem> _buildAppBarItems() {
    return [
      createBottomNavIcon(
        imagePath: 'assets/icons/home.svg',
        text: 'Home',
      ),
      createBottomNavIcon(
        imagePath: 'assets/icons/admission.svg',
        text: 'Admission',
      ),
      createBottomNavIcon(
        imagePath: 'assets/icons/e-books.svg',
        text: 'E-library',
        width: 24.0,
        height: 25.0,
      ),
      createBottomNavIcon(
        imagePath: 'assets/icons/settings.svg',
        text: 'Settings',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('explore_dashboard'),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.paymentTxtColor1,
        title: SvgPicture.asset('assets/icons/linkskool-logo.svg'),
        actions: [
          if (!_showSearchIcon)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle search action
              },
            ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          )
        ],
        elevation: 0,
      ),
      body: CustomNavigationBar(
        actionButtonImagePath: 'assets/icons/portal.svg',
        appBarItems: _buildAppBarItems(),
        bodyItems: _bodyItems,
        onTabSelected: widget.onTabSelected,
        onSwitch: widget.onSwitch,
        selectedIndex: widget.selectedIndex,
    ),
    );
  }
}
