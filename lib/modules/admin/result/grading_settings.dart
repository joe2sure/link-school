import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/constants.dart';
import 'package:linkschool/modules/common/text_styles.dart';

import 'package:linkschool/modules/providers/admin/grade_provider.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../../model/admin/grade _model.dart';

class GradingSettingsScreen extends StatefulWidget {
  const GradingSettingsScreen({super.key});

  @override
  _GradingSettingsScreenState createState() => _GradingSettingsScreenState();
}

class _GradingSettingsScreenState extends State<GradingSettingsScreen> {
  String? focusedField;
  bool isHoveringEdit = false;
  bool isHoveringDelete = false;
  bool isHoveringAdd = false;
  bool isHoveringSave = false;

  final TextEditingController gradeController = TextEditingController();
  final TextEditingController rangeController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  final Map<String, bool> editingStates = {};
  final Map<String, TextEditingController> editingControllers = {};
  final Map<String, FocusNode> focusNodes = {};
  final _addFormKey =
      GlobalKey<FormState>(); // Key for the "add new grade" form
  final Map<String, GlobalKey<FormState>> formKeys =
      {}; // Form keys for each grade item

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gradeProvider = Provider.of<GradeProvider>(context, listen: false);
      gradeProvider.fetchGrades().then((_) {
        // Initialize controllers after grades are fetched
        initializeControllers(gradeProvider.grades);
      });
    });
  }

  void initializeControllers(List<Grade> grades) {
    for (var grade in grades) {
      String itemId = grade.id;
      if (itemId.isNotEmpty) {
        editingControllers['$itemId-Grade'] =
            TextEditingController(text: grade.grade_Symbol);
        editingControllers['$itemId-Range'] =
            TextEditingController(text: grade.start);
        editingControllers['$itemId-Remark'] =
            TextEditingController(text: grade.remark);

        focusNodes['$itemId-Grade'] = FocusNode();
        focusNodes['$itemId-Range'] = FocusNode();
        focusNodes['$itemId-Remark'] = FocusNode();

        // Ensure editing state is initialized, defaults to false
        editingStates[itemId] = false;
      }
    }
  }

  @override
  void dispose() {
    for (var controller in editingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    gradeController.dispose();
    rangeController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  // Future<void> _saveChanges(
  //     BuildContext context, GradeProvider gradeProvider) async {
  //   try {
  //     // Validate the form

  //     // Add the new grade
  //     await gradeProvider.addGrade(
  //       gradeController.text,
  //       rangeController.text,
  //       remarkController.text,
  //     );

  //     // Clear the form fields
  //     gradeController.clear();
  //     rangeController.clear();
  //     remarkController.clear();

  //     // Show success message

  //   } catch (error) {
  //     // Show error message

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'assets/icons/arrow_back.png',
            color: AppColors.primaryLight,
            width: 34.0,
            height: 34.0,
          ),
        ),
        title: Text(
          'Grade Settings',
          style: AppTextStyles.normal600(
            fontSize: 18.0,
            color: AppColors.primaryLight,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Consumer<GradeProvider>(
        builder: (context, gradeProvider, child) {
          if (gradeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(Constants.padding),
              child: ListView(
                children: [
                  const Text(
                    'Add and update grade details',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...gradeProvider.grades
                      .map((grade) => buildFirstCard(grade, gradeProvider)),
                  const SizedBox(height: Constants.gap),
                  buildSecondCard(gradeProvider),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: MouseRegion(
        onEnter: (_) => setState(() => isHoveringSave = true),
        onExit: (_) => setState(() => isHoveringSave = false),
        child: FloatingActionButton(
          onPressed: () =>
              () {}, //_saveChanges(context, context.read<GradeProvider>()),
          backgroundColor:
              isHoveringSave ? Colors.blueGrey : AppColors.primaryLight,
          shape: const CircleBorder(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 7,
                  spreadRadius: 7,
                  offset: const Offset(3, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.save,
              color: AppColors.backgroundLight,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstCard(Grade grade, GradeProvider gradeProvider) {
    String itemId = grade.id;
    bool isEditing = editingStates[itemId] ?? false;

    if (!formKeys.containsKey(itemId)) {
      formKeys[itemId] = GlobalKey<FormState>();
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: Form(
          key: formKeys[itemId],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => isHoveringEdit = true),
                    onExit: (_) => setState(() => isHoveringEdit = false),
                    child: GestureDetector(
                      onTap: () {
                        if (isEditing) {
                          if (formKeys[itemId]!.currentState!.validate()) {
                            // Save changes if validation passes
                            setState(() {
                              editingStates[itemId] = false;
                            });
                          }
                        } else {
                          editItem(itemId);
                        }
                      },
                      child: SvgPicture.asset(
                        isEditing
                            ? 'assets/icons/result/check.svg'
                            : 'assets/icons/result/edit.svg',
                        color: isHoveringEdit ? Colors.blueGrey : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  MouseRegion(
                    onEnter: (_) => setState(() => isHoveringDelete = true),
                    onExit: (_) => setState(() => isHoveringDelete = false),
                    child: SvgPicture.asset(
                      'assets/icons/result/delete.svg',
                      color: isHoveringDelete ? Colors.blueGrey : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Constants.gap),
              buildEditableRow('Grade:', itemId, isEditing,
                  (value) => _validateField(value, 'Grade')),
              buildEditableRow('Range:', itemId, isEditing,
                  (value) => _validateField(value, 'Range')),
              buildEditableRow('Remark:', itemId, isEditing,
                  (value) => _validateField(value, 'Remark')),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableRow(
    String title,
    String itemId,
    bool isEditing,
    String? Function(String?)? validator,
  ) {
    String key = '$itemId-${title.replaceAll(':', '')}';
    TextEditingController? controller = editingControllers[key];
    FocusNode? focusNode = focusNodes[key];

    if (controller == null || focusNode == null) {
      return const SizedBox();
    }

    focusNode.addListener(() {
      setState(() {
        focusedField = focusNode.hasFocus ? key : null;
      });
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.gap),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.normal500(
              fontSize: 16.0,
              color: AppColors.assessmentColor2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isEditing
                ? TextFormField(
                    key: Key(key),
                    focusNode: focusNode,
                    controller: controller,
                    style: AppTextStyles.normal500(
                      fontSize: 18.0,
                      color: AppColors.backgroundDark,
                    ),
                    cursorColor: AppColors.primaryLight,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryLight),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    validator: validator,
                  )
                : Text(
                    controller.text,
                    style: AppTextStyles.normal500(
                      fontSize: 18.0,
                      color: AppColors.backgroundDark,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void editItem(String itemId) {
    setState(() {
      editingStates[itemId] = true;
    });
  }

  Widget buildSecondCard(GradeProvider gradeProvider) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: Form(
          key: _addFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField('Grade', gradeController, (value) {},
                  validator: (value) => _validateField(value, 'Grade')),
              buildInputField('Range', rangeController, (value) {},
                  validator: (value) => _validateField(value, 'Range')),
              buildInputField('Remark', remarkController, (value) {},
                  validator: (value) => _validateField(value, 'Remark')),
              const SizedBox(height: Constants.gap),
              Align(
                alignment: Alignment.bottomRight,
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHoveringAdd = true),
                  onExit: (_) => setState(() => isHoveringAdd = false),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_addFormKey.currentState!.validate()) {
                        try {
                          await gradeProvider.addGrade(
                            gradeController.text,
                            rangeController.text,
                            remarkController.text,
                          );
                          gradeController.clear();
                          rangeController.clear();
                          remarkController.clear();
                          MotionToast.success(
                            title: Text(
                              "Grade Added",
                              style: AppTextStyles.normal600(
                                fontSize: 16,
                                color: AppColors.assessmentColor1,
                              ),
                            ),
                            description: Text(
                              "Grade added successfully!",
                              style: AppTextStyles.normal400(
                                fontSize: 14,
                                color: AppColors.assessmentColor1,
                              ),
                            ),
                          ).show(context);
                        } catch (error) {
                          print(
                              'hey man this is my issue : ${error.toString()}');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isHoveringAdd
                          ? Colors.blueGrey
                          : AppColors.secondaryLight,
                      fixedSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constants.borderRadius),
                      ),
                    ),
                    child: const Text(
                      'Add +',
                      style: AppTextStyles.normal5Light,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged, {
    String? Function(String?)? validator,
  }) {
    final FocusNode focusNode =
        focusNodes[label] ?? FocusNode(); // Ensure focusNode is not null

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.gap),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: AppTextStyles.normal600(fontSize: 12, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller, // Ensure controller is not null
              focusNode: focusNode,
              onChanged: onChanged,
              validator: validator,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: focusedField == label
                        ? AppColors.primaryLight
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $fieldName';
    }

    return null;
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:linkschool/modules/common/app_colors.dart';
// import 'package:linkschool/modules/common/constants.dart';
// import 'package:linkschool/modules/common/text_styles.dart';
// import 'package:linkschool/modules/model/admin/grade_model.dart';
// import 'package:linkschool/modules/providers/admin/grade_provider.dart';
// import 'package:provider/provider.dart';


// class GradingSettingsScreen extends StatefulWidget {
//   const GradingSettingsScreen({super.key});

//   @override
//   _GradingSettingsScreenState createState() => _GradingSettingsScreenState();
// }

// class _GradingSettingsScreenState extends State<GradingSettingsScreen> {
//   String? selectedGrade;
//   String? selectedRange;
//   String? selectedRemark;
//   String? focusedField;

//   bool isHoveringEdit = false;
//   bool isHoveringDelete = false;
//   bool isHoveringAdd = false;
//   bool isHoveringSave = false;

//   TextEditingController gradeController = TextEditingController();
//   TextEditingController rangeController = TextEditingController();
//   TextEditingController remarkController = TextEditingController();

//   Map<String, bool> editingStates = {};
//   Map<String, TextEditingController> editingControllers = {};
//   Map<String, FocusNode> focusNodes = {};

//   @override
//   void initState() {
//     super.initState();
//     initializeControllers();
//     context.read<GradeProvider>().fetchGrades();
//   }

//   void initializeControllers() {
//     for (var item in gradingList) {
//       String itemId = item['id'] ?? '';
//       if (itemId.isNotEmpty) {
//         editingControllers['$itemId-Grade'] =
//             TextEditingController(text: item['grade']);
//         editingControllers['$itemId-Range'] =
//             TextEditingController(text: item['range']);
//         editingControllers['$itemId-Remark'] =
//             TextEditingController(text: item['remark']);

//         // Initialize focus nodes for each input field
//         focusNodes['$itemId-Grade'] = FocusNode();
//         focusNodes['$itemId-Range'] = FocusNode();
//         focusNodes['$itemId-Remark'] = FocusNode();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in editingControllers.values) {
//       controller.dispose();
//     }
//     for (var focusNode in focusNodes.values) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   List<Map<String, String>> gradingList = [
//     {'id': '1', 'grade': 'A', 'range': '80 - 100', 'remark': 'Excellent'}
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final gradeProvider = context.watch<GradeProvider>();
//     final grades = gradeProvider.grades;

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Image.asset(
//             'assets/icons/arrow_back.png',
//             color: AppColors.primaryLight,
//             width: 34.0,
//             height: 34.0,
//           ),
//         ),
//         title: Text(
//           'Grade Settings',
//           style: AppTextStyles.normal600(
//             fontSize: 18.0,
//             color: AppColors.primaryLight,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.backgroundLight,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(Constants.padding),
//         child: ListView(
//           children: [
//             const Text(
//               'Add and update grade details',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ...grades.map((grade) => buildFirstCard(grade)),
//             const SizedBox(height: Constants.gap),
//             buildSecondCard(gradeProvider),
//           ],
//         ),
//       ),
//       floatingActionButton: MouseRegion(
//         onEnter: (_) => setState(() => isHoveringSave = true),
//         onExit: (_) => setState(() => isHoveringSave = false),
//         child: FloatingActionButton(
//           onPressed: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text('Grade settings saved successfully')),
//             );
//           },
//           backgroundColor:
//               isHoveringSave ? Colors.blueGrey : AppColors.primaryLight,
//           shape: const CircleBorder(),
//           child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(100)),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 7,
//                       spreadRadius: 7,
//                       offset: const Offset(3, 5)),
//                 ]),
//             child: const Icon(
//               Icons.save,
//               color: AppColors.backgroundLight,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildFirstCard(Grade grade) {
//     String itemId = grade.id;
//     bool isEditing = editingStates[itemId] ?? false;

//     if (itemId.isEmpty) {
//       return const SizedBox(); 
//     }

//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Constants.borderRadius),
//       ),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(Constants.padding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 MouseRegion(
//                   onEnter: (_) => setState(() => isHoveringEdit = true),
//                   onExit: (_) => setState(() => isHoveringEdit = false),
//                   child: GestureDetector(
//                     onTap: () =>
//                         isEditing ? saveItem(itemId) : editItem(itemId),
//                     child: SvgPicture.asset(
//                       isEditing
//                           ? 'assets/icons/result/check.svg'
//                           : 'assets/icons/result/edit.svg',
//                       color: isHoveringEdit ? Colors.blueGrey : Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 MouseRegion(
//                   onEnter: (_) => setState(() => isHoveringDelete = true),
//                   onExit: (_) => setState(() => isHoveringDelete = false),
//                   child: GestureDetector(
//                     onTap: () => deleteItem(grade),
//                     child: SvgPicture.asset(
//                       'assets/icons/result/delete.svg',
//                       color: isHoveringDelete ? Colors.blueGrey : Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: Constants.gap),
//             buildEditableRow('Grade:', itemId, isEditing),
//             buildEditableRow('Range:', itemId, isEditing),
//             buildEditableRow('Remark:', itemId, isEditing),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildEditableRow(String title, String itemId, bool isEditing) {
//     String key = '$itemId-${title.replaceAll(':', '')}';
//     TextEditingController? controller = editingControllers[key];
//     FocusNode? focusNode = focusNodes[key];

//     if (controller == null || focusNode == null) {
//       return const SizedBox(); 
//     }

//     focusNode.addListener(() {
//       setState(() {
//         focusedField = focusNode.hasFocus ? key : null;
//       });
//     });

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: Constants.gap),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: AppTextStyles.normal500(
//               fontSize: 16.0,
//               color: AppColors.assessmentColor2,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: isEditing
//                 ? TextField(
//                     focusNode: focusNode,
//                     controller: controller,
//                     style: AppTextStyles.normal500(
//                       fontSize: 18.0,
//                       color: AppColors.backgroundDark,
//                     ),
//                     cursorColor: AppColors.primaryLight,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: AppColors.primaryLight),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   )
//                 : Text(
//                     controller.text,
//                     style: AppTextStyles.normal500(
//                       fontSize: 18.0,
//                       color: AppColors.backgroundDark,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   void editItem(String itemId) {
//     setState(() {
//       editingStates[itemId] = true;
//     });
//   }

//   void deleteItem(Grade grade) {
//     setState(() {
//       gradingList.removeWhere((item) => item['id'] == grade.id);
//       editingControllers.remove('${grade.id}-Grade');
//       editingControllers.remove('${grade.id}-Range');
//       editingControllers.remove('${grade.id}-Remark');
//       editingStates.remove(grade.id);
//     });
//   }

//   void saveItem(String itemId) {
//     setState(() {
//       editingStates[itemId] = false;
//       int index = gradingList.indexWhere((item) => item['id'] == itemId);
//       if (index != -1) {
//         gradingList[index]['grade'] = editingControllers['$itemId-Grade']!.text;
//         gradingList[index]['range'] = editingControllers['$itemId-Range']!.text;
//         gradingList[index]['remark'] =
//             editingControllers['$itemId-Remark']!.text;
//       }
//     });
//   }

//   Widget buildSecondCard(GradeProvider gradeProvider) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Constants.borderRadius),
//       ),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(Constants.padding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildInputField('Grade', gradeController, (value) {}),
//             buildInputField('Range', rangeController, (value) {}),
//             buildInputField('Remark', remarkController, (value) {}),
//             const SizedBox(height: Constants.gap),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: MouseRegion(
//                 onEnter: (_) => setState(() => isHoveringAdd = true),
//                 onExit: (_) => setState(() => isHoveringAdd = false),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (gradeController.text.isNotEmpty &&
//                         rangeController.text.isNotEmpty &&
//                         remarkController.text.isNotEmpty) {
//                       gradeProvider.addGrade(
//                         gradeController.text,
//                         rangeController.text,
//                         remarkController.text,
//                       );
//                       gradeController.clear();
//                       rangeController.clear();
//                       remarkController.clear();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isHoveringAdd
//                         ? Colors.blueGrey
//                         : AppColors.secondaryLight,
//                     fixedSize: const Size(100, 30),
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(Constants.borderRadius),
//                     ),
//                   ),
//                   child: const Text(
//                     'Add +',
//                     style: AppTextStyles.normal5Light,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInputField(String label, TextEditingController controller, ValueChanged<String> onChanged) {
//     final FocusNode focusNode = FocusNode();
    
//     focusNode.addListener(() {
//       setState(() {
//         focusedField = focusNode.hasFocus ? label : null;
//       });
//     });

//     bool isNumericOnly = label == 'Grade' || label == 'Range';

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: Constants.gap),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 50,
//             child: Text(
//               label,
//               style: AppTextStyles.normal600(fontSize: 12, color: Colors.black),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Container(
//               height: 34,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: focusedField == label ? AppColors.primaryLight : Colors.grey,
//                 ),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: TextField(
//                 focusNode: focusNode,
//                 controller: controller,
//                 onChanged: onChanged,
//                 textAlignVertical: TextAlignVertical.center,
//                 keyboardType: isNumericOnly ? TextInputType.number : TextInputType.text,
//                 inputFormatters: isNumericOnly
//                     ? [FilteringTextInputFormatter.digitsOnly]
//                     : null,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppColors.primaryLight),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 style: TextStyle(fontSize: 14),
//                 cursorColor: AppColors.primaryLight,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

