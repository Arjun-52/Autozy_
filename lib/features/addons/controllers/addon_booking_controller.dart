import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/addon_repository.dart';
import '../../../data/models/dto/addon_service_model.dart';
import '../../../data/models/dto/book_addon_request_model.dart';
import '../../../data/models/dto/book_addon_response_model.dart';

class AddonBookingController extends GetxController {
  final AddonRepository _repo;

  AddonBookingController(this._repo);

  final Rxn<AddonServiceModel> addon = Rxn<AddonServiceModel>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();
  final isBooking = false.obs;

  BookAddonResponseModel? bookingResponse;

  void setAddon(AddonServiceModel a) => addon.value = a;
  void setDate(DateTime d) => selectedDate.value = d;
  void setTime(TimeOfDay t) => selectedTime.value = t;

  DateTime? get combinedDateTime {
    final d = selectedDate.value;
    final t = selectedTime.value;
    if (d == null || t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  bool isAtLeast48Hours() {
    final dt = combinedDateTime;
    if (dt == null) return false;
    return dt.isAfter(DateTime.now().add(const Duration(hours: 48)).subtract(const Duration(seconds: 1)));
  }

  Future<bool> bookAddon({required String vehicleId, required String cityId}) async {
    final dt = combinedDateTime;
    final a = addon.value;
    if (dt == null || a == null) throw Exception('Date/time or add-on not selected');

    isBooking.value = true;
    try {
      final start = dt;
      final end = start.add(const Duration(hours: 1));

      String fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      String fmtTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

      final request = BookAddonRequestModel(
        vehicleId: vehicleId,
        addonServiceId: a.id,
        scheduledDate: fmtDate(start),
        scheduledSlotStart: fmtTime(TimeOfDay(hour: start.hour, minute: start.minute)),
        scheduledSlotEnd: fmtTime(TimeOfDay(hour: end.hour, minute: end.minute)),
        cityId: cityId,
      );

      final resp = await _repo.bookAddonService(request);
      bookingResponse = resp;
      return resp.success;
    } finally {
      isBooking.value = false;
    }
  }
}
