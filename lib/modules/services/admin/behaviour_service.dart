import 'package:linkschool/modules/model/admin/behaviour_model.dart';
import 'package:linkschool/modules/services/api/api_service.dart';

class SkillService {
  final ApiService _apiService;

  SkillService(this._apiService);
  
  Future<List<Skills>> getSkills() async {
    final response = await _apiService.get<List<Skills>>(
      endpoint: 'skills.php',
      fromJson: (json) {
        if (json.containsKey('skills')) {
          final List<dynamic> data = json['skills'];
          return data.map((skillJson) => Skills.fromJson(skillJson)).toList();
        }
        throw Exception('Invalid API response: Missing "skills" key');
      },
    );

    if (response.success) {
      return response.data ?? [];
    } else {
      throw Exception('Failed to load skills: ${response.message}');
    }
  }
  
  Future<void> addSkill(Skills skill) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      endpoint: 'skills.php',
      body: skill.toJson(),
    );

    if (!response.success) {
      throw Exception('Failed to add skill: ${response.message}');
    }
  }
  
  Future<void> deleteSkill(String id) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      endpoint: 'skills.php',
      body: {'id': id},
    );

    if (!response.success) {
      throw Exception('Failed to delete skill: ${response.message}');
    }
  }
}






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:linkschool/modules/model/admin/behaviour_model.dart';

// class SkillService {
//   static const String baseUrl = 'http://linkskool.com/developmentportal/api';
  
//   Future<List<Skills>> getSkills() async {
//     final response = await http.get(Uri.parse('$baseUrl/skills.php'));
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody.containsKey('skills')) {
//         final List<dynamic> data = responseBody['skills'];
//         return data.map((json) => Skills.fromJson(json)).toList();
//       } else {
//         throw Exception('Invalid API response: Missing "skills" key');
//       }
//     } else {
//       throw Exception('Failed to load skills: ${response.statusCode}');
//     }
//   }
  
//   Future<void> addSkill(Skills skill) async {
//   final requestBody = skill.toJson();
//   print('Sending to API: $requestBody'); // Debug the request
  
//   final response = await http.post(
//     Uri.parse('$baseUrl/skills.php'),
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode(requestBody),
//   );
  
//   print('Add Skill Response: ${response.body}'); // Debug the response
  
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> responseBody = json.decode(response.body);
//     if (responseBody['success'] == true) {
//       return; // Success
//     } else {
//       throw Exception('Failed to add skill: ${responseBody['message']}');
//     }
//   } else {
//     throw Exception('Failed to add skill: ${response.statusCode}');
//   }
// }
  
//   Future<void> deleteSkill(String id) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/skills.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'id': id}), // Send the id in the correct format
//     );
//     print('Delete Response: ${response.body}'); // Debug the response
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody['success'] == true) {
//         return; // Success
//       } else {
//         throw Exception('Failed to delete skill: ${responseBody['message']}');
//       }
//     } else {
//       throw Exception('Failed to delete skill: ${response.statusCode}');
//     }
//   }
// }