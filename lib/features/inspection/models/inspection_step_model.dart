class InspectionStepModel {
  final String title;
  final String subtitle;
  final bool completed;

  const InspectionStepModel({
    required this.title,
    required this.subtitle,
    required this.completed,
  });

  InspectionStepModel copyWith({bool? completed}) {
    return InspectionStepModel(
      title: title,
      subtitle: subtitle,
      completed: completed ?? this.completed,
    );
  }
}
