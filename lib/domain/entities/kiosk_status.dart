class KioskStatus {
  final String status;
  final String serverTime;

  const KioskStatus({
    required this.status,
    required this.serverTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KioskStatus &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          serverTime == other.serverTime;

  @override
  int get hashCode => status.hashCode ^ serverTime.hashCode;
}
