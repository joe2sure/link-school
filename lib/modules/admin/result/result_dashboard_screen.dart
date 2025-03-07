import 'package:flutter/material.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/constants.dart';
import 'package:linkschool/modules/common/widgets/portal/result_dashboard/level_selection.dart';
import 'package:linkschool/modules/common/widgets/portal/result_dashboard/performance_chart.dart';
import 'package:linkschool/modules/common/widgets/portal/result_dashboard/settings_section.dart';
import 'package:hive/hive.dart';

class ResultDashboardScreen extends StatefulWidget {
  final PreferredSizeWidget appBar;

  const ResultDashboardScreen({
    super.key,
    required this.appBar,
  });

  @override
  State<ResultDashboardScreen> createState() => _ResultDashboardScreenState();
}

class _ResultDashboardScreenState extends State<ResultDashboardScreen> {
  Map<String, dynamic>? userData;
  List<dynamic>? levelNames;
  List<dynamic>? classNames;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userBox = Hive.box('userData');
    final userData = userBox.get('userData');

    if (userData != null) {
      print('User Data: $userData'); // Debugging: Print the userData structure

      // Extract levelName and className from the persisted JSON
      final levelNameData = userData['levelName']?['rows'] ?? [];
      final classNameData = userData['className']?['rows'] ?? [];

      print('Level Names: $levelNameData'); // Debugging: Print level names
      print('Class Names: $classNameData'); // Debugging: Print class names

      setState(() {
        this.userData = userData;
        this.levelNames = levelNameData;
        this.classNames = classNameData;
      });
    } else {
      print('User data is null or not found in Hive');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
        decoration: Constants.customBoxDecoration(context),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverToBoxAdapter(
              child: Constants.heading600(
                title: 'Overall Performance',
                titleSize: 18.0,
                titleColor: AppColors.resultColor1,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
            const SliverToBoxAdapter(child: PerformanceChart()),
            const SliverToBoxAdapter(child: SizedBox(height: 28.0)),
            SliverToBoxAdapter(
              child: Constants.heading600(
                title: 'Settings',
                titleSize: 18.0,
                titleColor: AppColors.resultColor1,
              ),
            ),
            const SliverToBoxAdapter(child: SettingsSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 48.0)),
            SliverToBoxAdapter(
              child: Constants.heading600(
                title: 'Select Level',
                titleSize: 18.0,
                titleColor: AppColors.resultColor1,
              ),
            ),
            SliverToBoxAdapter(
              child: LevelSelection(
                levelNames: levelNames ?? [], // Pass the list of level names
                classNames: classNames ?? [], // Pass the list of class names
                isSecondScreen: false, // Set to true for course selection
                subjects: [
                  'Math',
                  'Science',
                  'English'
                ], // Pass the list of subjects
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class _ResultDashboardScreenState extends State<ResultDashboardScreen> {
//   Map<String, dynamic>? userData;
//   List<dynamic>? levelNames;
//   List<dynamic>? classNames;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final userBox = Hive.box('userData');
//     final userData = userBox.get('userData');
//     final levelName =
//         userData['levelName']; // Assuming levelName is part of the user data
//     final className =
//         userData['className']; // Assuming className is part of the user data

//     setState(() {
//       this.userData = userData;
//       this.classNames = className;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: widget.appBar,
//       body: Container(
//         decoration: Constants.customBoxDecoration(context),
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
//             SliverToBoxAdapter(
//               child: Constants.heading600(
//                 title: 'Overall Performance',
//                 titleSize: 18.0,
//                 titleColor: AppColors.resultColor1,
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
//             const SliverToBoxAdapter(child: PerformanceChart()),
//             const SliverToBoxAdapter(child: SizedBox(height: 28.0)),
//             SliverToBoxAdapter(
//               child: Constants.heading600(
//                 title: 'Settings',
//                 titleSize: 18.0,
//                 titleColor: AppColors.resultColor1,
//               ),
//             ),
//             const SliverToBoxAdapter(child: SettingsSection()),
//             const SliverToBoxAdapter(child: SizedBox(height: 48.0)),
//             SliverToBoxAdapter(
//               child: Constants.heading600(
//                 title: 'Select Level',
//                 titleSize: 18.0,
//                 titleColor: AppColors.resultColor1,
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: LevelSelection(
//                 levelName: userData?['levelName']?['level_name'] ?? 'BASIC ONE',
//                 classNames: classNames,
//                 isSecondScreen: false, // Set to true for course selection
//                 subjects: [
//                   'Math',
//                   'Science',
//                   'English'
//                 ], // Pass the list of subjects
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ResultDashboardScreen extends StatefulWidget {
//   final PreferredSizeWidget appBar;

//   const ResultDashboardScreen({
//     super.key,
//     required this.appBar,
//   });

//   @override
//   State<ResultDashboardScreen> createState() => _ResultDashboardScreenState();
// }

// class _ResultDashboardScreenState extends State<ResultDashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: widget.appBar,
//       body: Container(
//         decoration: Constants.customBoxDecoration(context),
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
//             SliverToBoxAdapter(
//               child: Constants.heading600(
//                 title: 'Overall Performance',
//                 titleSize: 18.0,
//                 titleColor: AppColors.resultColor1,
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
//             const SliverToBoxAdapter(child: PerformanceChart()),
//             const SliverToBoxAdapter(child: SizedBox(height: 28.0)),
//             SliverToBoxAdapter(
//               child: Constants.heading600(
//                 title: 'Settings',
//                 titleSize: 18.0,
//                 titleColor: AppColors.resultColor1,
//               ),
//             ),
//             const SliverToBoxAdapter(child: SettingsSection()),
//             const SliverToBoxAdapter(child: SizedBox(height: 48.0)),
//             SliverToBoxAdapter(
//               child: Constants.heading600(
//                 title: 'Select Level',
//                 titleSize: 18.0,
//                 titleColor: AppColors.resultColor1,
//               ),
//             ),
//             const SliverToBoxAdapter(child: LevelSelection()),
//           ],
//         ),
//       ),
//     );
//   }
// }
