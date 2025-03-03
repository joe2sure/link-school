import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkschool/modules/admin/e_learning/empty_syllabus_screen.dart';
import 'package:linkschool/modules/model/admin/class_model.dart';
import 'package:linkschool/modules/providers/admin/class_provider.dart';
import 'package:linkschool/modules/providers/admin/level_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkschool/modules/admin/result/class_detail/class_detail_screen.dart';
// import 'package:linkschool/modules/common/app_colors.dart';
// import 'package:linkschool/modules/common/text_styles.dart';
// import 'package:linkschool/modules/providers/level_provider.dart';
// import 'package:linkschool/modules/providers/class_provider.dart';



class LevelSelection extends StatefulWidget {
  final bool isSecondScreen;
  final List<String> subjects;

  const LevelSelection({
    super.key,
    this.isSecondScreen = false,
    this.subjects = const [],
  });

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  // List of background images for level containers
  final List<String> _backgroundImages = [
    'assets/images/result/bg_box1.svg',
    'assets/images/result/bg_box2.svg',
    'assets/images/result/bg_box3.svg',
    'assets/images/result/bg_box4.svg',
    'assets/images/result/bg_box5.svg',
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.isSecondScreen) {
      // Fetch levels only if it's not the second screen (e.g., ResultDashboardScreen)
      Provider.of<LevelProvider>(context, listen: false).fetchLevels();
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);

    return Column(
      children: widget.isSecondScreen
          ? _buildSubjectBoxes()
          : _buildLevelBoxes(levelProvider, classProvider), 
    );
  }

  List<Widget> _buildLevelBoxes(LevelProvider levelProvider, ClassProvider classProvider) {
    if (levelProvider.levels.isEmpty) {
      return [const Center(child: CircularProgressIndicator())]; // Show loading indicator
    }

    return levelProvider.levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final backgroundImage = _backgroundImages[index % _backgroundImages.length]; // Cycle through background images

      return _buildLevelBox(
        level.levelName ?? 'N/A', // Handle null levelName
        backgroundImage, // Use different background image for each level
        () {
          // Fetch classes for the selected level
          classProvider.fetchClasses(level.id ?? '').then((_) {
            _showClassSelectionDialog(classProvider.classes);
          });
        },
      );
    }).toList();
  }

  List<Widget> _buildSubjectBoxes() {
    return widget.subjects.map((subject) {
      return _buildLevelBox(
        subject,
        'assets/images/result/bg_box1.svg', // Default background image for subjects
        () {
          _showCourseSelectionDialog();
        },
      );
    }).toList();
  }

  Widget _buildLevelBox(String text, String backgroundImagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              SvgPicture.asset(
                backgroundImagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: 170,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextButton(
                        onPressed: onTap,
                        child: Text(
                          widget.isSecondScreen ? 'View Subjects' : 'View level performance',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClassSelectionDialog(List<Class> classes) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Select Class',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: ListView.builder(
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final classItem = classes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: _buildClassButton(
                          classItem.className ?? 'N/A',
                          () {
                            Navigator.of(context).pop();
                            _navigateToClassDetail(classItem.className ?? 'N/A');
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCourseSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Select Course',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: ListView.builder(
                    itemCount: widget.subjects.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: _buildSubjectButton(widget.subjects[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClassButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Ink(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectButton(String subject) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EmptySyllabusScreen(selectedSubject: subject),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        subject,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _navigateToClassDetail(String className) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClassDetailScreen(className: className),
      ),
    );
  }
}


// // lib/widgets/level_selection.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:linkschool/modules/admin/e_learning/empty_syllabus_screen.dart';
// import 'package:linkschool/modules/admin/result/class_detail/class_detail_screen.dart';
// import 'package:linkschool/modules/common/app_colors.dart';
// import 'package:linkschool/modules/common/text_styles.dart';


// class LevelSelection extends StatefulWidget {
//   // const LevelSelection({Key? key}) : super(key: key);
//   final bool isSecondScreen;
//   final List<String> subjects;

//   const LevelSelection({
//     super.key,
//     this.isSecondScreen = false,
//     this.subjects = const [],
//   });

//   @override
//   State<LevelSelection> createState() => _LevelSelectionState();
// }

// class _LevelSelectionState extends State<LevelSelection> {
//   String _selectedLevel = '';

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildLevelBox('BASIC ONE', 'assets/images/result/bg_box1.svg'),
//         _buildLevelBox('BASIC TWO', 'assets/images/result/bg_box2.svg'),
//         _buildLevelBox('JSS ONE', 'assets/images/result/bg_box3.svg'),
//         _buildLevelBox('JSS TWO', 'assets/images/result/bg_box4.svg'),
//         _buildLevelBox('JSS THREE', 'assets/images/result/bg_box5.svg'),
//         const SizedBox(
//           height: 100,
//         )
//       ],
//     );
//   }

//   Widget _buildLevelBox(String levelText, String backgroundImagePath) {
//     return GestureDetector(
//       onTap: () => _toggleOverlay(levelText),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         child: Container(
//           height: 140,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.transparent,
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Stack(
//             children: [
//               SvgPicture.asset(
//                 backgroundImagePath,
//                 width: double.infinity,
//                 height: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       levelText,
//                       style: AppTextStyles.normal700P(
//                           fontSize: 20.0,
//                           color: AppColors.backgroundLight,
//                           height: 1.04),
//                     ),
//                     const SizedBox(height: 40),
//                     Container(
//                       width: 170,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: AppColors.backgroundLight, width: 1),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: TextButton(
//                         onPressed: () => _toggleOverlay(levelText),
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                           minimumSize: Size.zero,
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: Text(
//                           'View level performance',
//                           style: AppTextStyles.normal700P(
//                               fontSize: 12,
//                               color: AppColors.backgroundLight,
//                               height: 1.2),
//                           // overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
// // lib/widgets/level_selection.dart (continued)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleOverlay(String level) {
//     setState(() {
//       _selectedLevel = level;
//       if (widget.isSecondScreen) {
//         _showCourseSelectionDialog();
//       } else {
//         _showClassSelectionDialog();
//       }
//     });
//   }

// void _showClassSelectionDialog() {
//   final classes = [
//     'A',
//     'B',
//     'C',
//     'D',
//     'E',
//   ];
//   final levelPrefix = _selectedLevel.split(' ')[0];

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (BuildContext context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.6,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 24),
//               Text(
//                 'Select Class',
//                 style: AppTextStyles.normal600(
//                     fontSize: 24, color: Colors.black),
//               ),
//               const SizedBox(height: 24),
//               Flexible(
//                 child: ListView.builder(
//                   itemCount: classes.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       child: _buildClassButton(
//                         '$levelPrefix ${classes[index]}',
//                         () {
//                           Navigator.of(context).pop();
//                           _navigateToClassDetail(
//                               '$levelPrefix ${classes[index]}');
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// Widget _buildClassButton(String text, VoidCallback onPressed) {
//   return Container(
//     decoration: BoxDecoration(
//       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
//     ),
//     child: Material(
//       color: AppColors.dialogBtnColor,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(4),
//         child: Ink(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
//           child: Container(
//             width: double.infinity,
//             height: 50,
//             alignment: Alignment.center,
//             child: Text(text, style: AppTextStyles.normal600(fontSize: 16, color: AppColors.backgroundDark)),
//           ),
//         ),
//       ),
//     ),
//   );
// }


//   void _showCourseSelectionDialog() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.6,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 24),
//                 Text(
//                   'Select Course',
//                   style: AppTextStyles.normal600(
//                       fontSize: 24, color: Colors.black),
//                 ),
//                 const SizedBox(height: 24),
//                 Flexible(
//                   child: ListView.builder(
//                     itemCount: widget.subjects.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 8),
//                         child: _buildSubjectButton(widget.subjects[index]),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSubjectButton(String subject) {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => EmptySyllabusScreen(selectedSubject: subject),
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//       child: Text(
//         subject,
//         style: const TextStyle(fontSize: 16),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   void _navigateToClassDetail(String className) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ClassDetailScreen(className: className),
//       ),
//     );
//   }
// }
