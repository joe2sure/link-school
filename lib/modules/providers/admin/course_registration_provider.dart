import 'package:flutter/material.dart';
import 'package:linkschool/modules/model/admin/course_registration_model.dart';
import 'package:linkschool/modules/services/admin/course_registration_service.dart';
import 'package:linkschool/modules/services/api/service_locator.dart';

class CourseRegistrationProvider with ChangeNotifier {
  final CourseRegistrationService _courseRegistrationService = locator<CourseRegistrationService>();
  List<CourseRegistrationModel> _registeredCourses = [];
  bool _isLoading = false;

  List<CourseRegistrationModel> get registeredCourses => _registeredCourses;
  bool get isLoading => _isLoading;

  // Fetch registered students (using the registered-students API)
  Future<void> fetchRegisteredCourses(String classId, String term, String year) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _courseRegistrationService.fetchRegisteredCourses(classId, term, year);

      if (response.success && response.data != null) {
        _registeredCourses = response.data!;
      } else {
        // If the API call was successful but returned no data
        _registeredCourses = [];
        debugPrint('No registered students found or ${response.message}');
      }
    } catch (e) {
      _registeredCourses = [];
      debugPrint('Error fetching registered students: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register a new course
  Future<void> registerCourse(CourseRegistrationModel course) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _courseRegistrationService.registerCourse(course);

      if (response.success && response.data == true) {
        // Update the course count for the student
        int index = _registeredCourses.indexWhere((s) => s.studentId == course.studentId);
        if (index != -1) {
          var updatedStudent = CourseRegistrationModel(
            studentId: course.studentId,
            studentName: course.studentName,
            courseCount: _registeredCourses[index].courseCount + 1,
            classId: course.classId,
            term: course.term,
            year: course.year,
          );
          _registeredCourses[index] = updatedStudent;
        }
        debugPrint('Course registered successfully');
      } else {
        debugPrint('Failed to register course: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error registering course: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing course registration
  Future<void> updateCourseRegistration(int studentId, int newCourseCount) async {
    int index = _registeredCourses.indexWhere((s) => s.studentId == studentId);
    if (index != -1) {
      var updatedStudent = CourseRegistrationModel(
        studentId: _registeredCourses[index].studentId,
        studentName: _registeredCourses[index].studentName,
        courseCount: newCourseCount,
        classId: _registeredCourses[index].classId,
        term: _registeredCourses[index].term,
        year: _registeredCourses[index].year,
      );
      _registeredCourses[index] = updatedStudent;
      notifyListeners();
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:linkschool/modules/model/admin/course_registration_model.dart';
// import 'package:linkschool/modules/services/admin/course_registration_service.dart';
// import 'package:linkschool/modules/services/api/service_locator.dart';

// class CourseRegistrationProvider with ChangeNotifier {
//   final CourseRegistrationService _courseRegistrationService = locator<CourseRegistrationService>();
//   List<CourseRegistrationModel> _registeredCourses = [];
//   bool _isLoading = false;

//   List<CourseRegistrationModel> get registeredCourses => _registeredCourses;
//   bool get isLoading => _isLoading;

//   // Fetch registered courses
//   Future<void> fetchRegisteredCourses(String classId, String term, String year) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await _courseRegistrationService.fetchRegisteredCourses(classId, term, year);

//       if (response.success && response.data != null) {
//         _registeredCourses = response.data!;
//       } else {
//         // If the API call was successful but returned no data
//         _registeredCourses = [];
//         debugPrint('No courses found or ${response.message}');
//       }
//     } catch (e) {
//       _registeredCourses = [];
//       debugPrint('Error fetching courses: ${e.toString()}');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Register a new course
//   Future<void> registerCourse(CourseRegistrationModel course) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await _courseRegistrationService.registerCourse(course);

//       if (response.success && response.data == true) {
//         // Add the newly registered course to the list
//         _registeredCourses.add(course);
//         debugPrint('Course registered successfully');
//       } else {
//         debugPrint('Failed to register course: ${response.message}');
//       }
//     } catch (e) {
//       debugPrint('Error registering course: ${e.toString()}');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Update an existing course
//   Future<void> updateCourse(CourseRegistrationModel course) async {
//     _isLoading = true;
//     notifyListeners();

//     // Implementation would use the ApiService to update the course
//     // This is just a placeholder for the method signature

//     _isLoading = false;
//     notifyListeners();
//   }

//   // Delete a course
//   Future<void> deleteCourse(String courseId) async {
//     _isLoading = true;
//     notifyListeners();

//     // Implementation would use the ApiService to delete the course
//     // This is just a placeholder for the method signature

//     _isLoading = false;
//     notifyListeners();
//   }
// }