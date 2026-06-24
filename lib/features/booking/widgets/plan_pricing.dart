import '../../../providers/plan_provider.dart';
import '../../../data/models/plan_model.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/dto/nearby_areas_response.dart';

/// Resolves the monthly price (in rupees) for the given plan + vehicle size in
/// the selected area, using the loaded pricing list. Returns null if any input
/// is missing or no pricing row matches.
num? resolvePlanPrice({
  required PlanProvider planProvider,
  required Plan? plan,
  required Vehicle? vehicle,
  required Area? area,
}) {
  if (plan == null || vehicle == null) return null;
  final pricingId = planProvider.getPricingIdForPlanAndVehicle(
    planId: plan.id,
    vehicleSize: vehicle.sizeCategory,
    areaId: area?.id,
    cityId: area?.cityId,
  );
  if (pricingId == null) return null;
  return planProvider.getPriceForPricingId(pricingId);
}

/// Resolves the itemised price breakdown (base, GST, GST-inclusive total — all
/// in rupees) for the given plan + vehicle size in the selected area. Mirrors the
/// backend's create-subscription-order math so the displayed total matches the
/// charged amount. Returns null if any input is missing or no pricing row matches.
({num base, num gst, num total})? resolvePlanPriceBreakdown({
  required PlanProvider planProvider,
  required Plan? plan,
  required Vehicle? vehicle,
  required Area? area,
}) {
  if (plan == null || vehicle == null) return null;
  final pricingId = planProvider.getPricingIdForPlanAndVehicle(
    planId: plan.id,
    vehicleSize: vehicle.sizeCategory,
    areaId: area?.id,
    cityId: area?.cityId,
  );
  if (pricingId == null) return null;
  final base = planProvider.getPriceForPricingId(pricingId);
  if (base == null) return null;
  final rate = planProvider.getGstRateForPricingId(pricingId);
  final gst = double.parse((base * rate).toStringAsFixed(2));
  final total = double.parse((base + gst).toStringAsFixed(2));
  return (base: base, gst: gst, total: total);
}

/// "REGULAR_CLEANING" -> "Regular Cleaning"
String prettyPlanName(String name) => name
    .split(RegExp(r'[_\s]+'))
    .where((w) => w.isNotEmpty)
    .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
    .join(' ');

/// Drops a trailing .0 (1599.0 -> "1599"), keeps 2dp otherwise.
String formatPrice(num price) =>
    price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
