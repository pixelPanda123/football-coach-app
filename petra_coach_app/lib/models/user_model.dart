enum UserRole { student, coach, headCoach }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? centerId;
  final List<String>? assignedBatches;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.centerId,
    this.assignedBatches,
    this.additionalInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.toString() == 'UserRole.${json['role']}',
      ),
      centerId: json['centerId'] as String?,
      assignedBatches: (json['assignedBatches'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'centerId': centerId,
      'assignedBatches': assignedBatches,
      'additionalInfo': additionalInfo,
    };
  }

  bool get isStudent => role == UserRole.student;
  bool get isCoach => role == UserRole.coach;
  bool get isHeadCoach => role == UserRole.headCoach;
} 