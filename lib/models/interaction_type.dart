enum InteractionType {
  FAVORITED,
  DISCARDED;

  static InteractionType fromString(String value) {
    return InteractionType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => throw ArgumentError('Invalid interaction type: $value'),
    );
  }

  String toJson() => toString().split('.').last;
}
