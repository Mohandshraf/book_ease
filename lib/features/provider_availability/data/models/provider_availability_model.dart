class ProviderAvailabilityModel {
  final String providerId;
  final List<String> workingDays;
  final String startHour;
  final String endHour;
  final int slotDurationMinutes;
  final List<String> slots;
  final bool isAvailable;
  final String? notes;

  ProviderAvailabilityModel({
    required this.providerId,
    this.workingDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    this.startHour = '09:00',
    this.endHour = '17:00',
    this.slotDurationMinutes = 60,
    this.slots = const [
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
    ],
    this.isAvailable = true,
    this.notes,
  });

  factory ProviderAvailabilityModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    return ProviderAvailabilityModel(
      providerId: docId ?? json['providerId'] ?? '',
      workingDays: (json['workingDays'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      startHour: json['startHour'] ?? '09:00',
      endHour: json['endHour'] ?? '17:00',
      slotDurationMinutes: (json['slotDurationMinutes'] as num?)?.toInt() ?? 60,
      slots: (json['slots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [
            '09:00 AM',
            '10:00 AM',
            '11:00 AM',
            '01:00 PM',
            '02:00 PM',
            '03:00 PM',
            '04:00 PM',
          ],
      isAvailable: json['isAvailable'] ?? true,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'workingDays': workingDays,
      'startHour': startHour,
      'endHour': endHour,
      'slotDurationMinutes': slotDurationMinutes,
      'slots': slots,
      'isAvailable': isAvailable,
      if (notes != null) 'notes': notes,
    };
  }

  ProviderAvailabilityModel copyWith({
    String? providerId,
    List<String>? workingDays,
    String? startHour,
    String? endHour,
    int? slotDurationMinutes,
    List<String>? slots,
    bool? isAvailable,
    String? notes,
  }) {
    return ProviderAvailabilityModel(
      providerId: providerId ?? this.providerId,
      workingDays: workingDays ?? this.workingDays,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      slots: slots ?? this.slots,
      isAvailable: isAvailable ?? this.isAvailable,
      notes: notes ?? this.notes,
    );
  }
}
