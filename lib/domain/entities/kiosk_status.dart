class KioskStatus {
  final String status;
  final String message;
  final String location;
  final DateTime lastUpdated;

  const KioskStatus({
    required this.status,
    required this.message,
    required this.location,
    required this.lastUpdated,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KioskStatus &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          message == other.message &&
          location == other.location &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode =>
      status.hashCode ^
      message.hashCode ^
      location.hashCode ^
      lastUpdated.hashCode;
}
