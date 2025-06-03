class Student {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String batchId;
  final String center;
  final String phoneNumber;
  final String parentName;
  final String parentPhone;
  final String address;
  final DateTime joiningDate;
  final String? photoUrl;
  final bool isActive;

  const Student({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.batchId,
    required this.center,
    required this.phoneNumber,
    required this.parentName,
    required this.parentPhone,
    required this.address,
    required this.joiningDate,
    this.photoUrl,
    this.isActive = true,
  });

  // Calculate age
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Create a copy of the student with some fields updated
  Student copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? batchId,
    String? center,
    String? phoneNumber,
    String? parentName,
    String? parentPhone,
    String? address,
    DateTime? joiningDate,
    String? photoUrl,
    bool? isActive,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      batchId: batchId ?? this.batchId,
      center: center ?? this.center,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      address: address ?? this.address,
      joiningDate: joiningDate ?? this.joiningDate,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  // Demo data for testing
  static List<Student> getDemoStudents() {
    return [
      Student(
        id: 'student_1',
        name: 'John Doe',
        dateOfBirth: DateTime(2014, 5, 15),
        batchId: 'batch1',
        center: 'Stadium of Hope, Khanapur',
        phoneNumber: '9876543210',
        parentName: 'Jane Doe',
        parentPhone: '9876543211',
        address: '123 Main St, Khanapur',
        joiningDate: DateTime(2023, 6, 1),
      ),
      Student(
        id: 'student_2',
        name: 'Alice Smith',
        dateOfBirth: DateTime(2013, 8, 22),
        batchId: 'batch1',
        center: 'Stadium of Hope, Khanapur',
        phoneNumber: '9876543212',
        parentName: 'Bob Smith',
        parentPhone: '9876543213',
        address: '456 Oak St, Khanapur',
        joiningDate: DateTime(2023, 7, 15),
      ),
      // Add more demo students as needed
    ];
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'batchId': batchId,
      'center': center,
      'phoneNumber': phoneNumber,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'address': address,
      'joiningDate': joiningDate.toIso8601String(),
      'photoUrl': photoUrl,
      'isActive': isActive,
    };
  }

  // Create from Map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      batchId: map['batchId'] as String,
      center: map['center'] as String,
      phoneNumber: map['phoneNumber'] as String,
      parentName: map['parentName'] as String,
      parentPhone: map['parentPhone'] as String,
      address: map['address'] as String,
      joiningDate: DateTime.parse(map['joiningDate'] as String),
      photoUrl: map['photoUrl'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
} 