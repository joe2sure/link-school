class Skills {
  final String id;
  final String? skillName;
  final String? type; // "0" for skills, "1" for behaviors
  final String? level;
  
  Skills({
    required this.id,
    required this.skillName,
    required this.type,
    required this.level,
  });
  
  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      id: json['id'].toString(),
      skillName: json['skill_name'],
      type: json['type']?.toString(),
      level: json['level']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill_name': skillName,
      'type': type, // Already "0" or "1", don't convert
      'level': level,
    };
  }

}