enum UserRole {
  student,
  coach,
  headCoach,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String centerId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.centerId,
  });

  bool get isStudent => role == UserRole.student;
  bool get isCoach => role == UserRole.coach;
  bool get isHeadCoach => role == UserRole.headCoach;
} 