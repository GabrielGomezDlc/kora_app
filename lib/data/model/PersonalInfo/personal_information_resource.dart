class PersonalInfoResource {
  final int age;
  final String gender;
  final String surgeryType;
  final String surgeryDate;

  PersonalInfoResource({
    required this.age,
    required this.gender,
    required this.surgeryType,
    required this.surgeryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'gender':gender,
      'surgeryType':surgeryType,
      'surgeryDate':surgeryDate,
    };
  }
}