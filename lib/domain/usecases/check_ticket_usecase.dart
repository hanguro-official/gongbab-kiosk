import 'package:gongbab/domain/repositories/kiosk_repository.dart';

class CheckTicketUseCase {
  final KioskRepository repository;

  CheckTicketUseCase(this.repository);

  Future<void> call(String ticketId) {
    return repository.checkTicket(ticketId);
  }
}
