/// Utility helpers for formatting prices consistently across the app.

/// Formats a nullable price into the project's currency string.
/// - If [amount] is `null` returns `-` (unknown)
/// - Otherwise returns the amount prefixed with the rupee symbol and formatted
///   using [fractionDigits]. Example: `₹299` or `₹299.00`.
String formatCurrency(double? amount, {int fractionDigits = 0}) {
  if (amount == null) return '-';
  // Treat NaN / infinite defensively
  if (amount.isNaN || amount.isInfinite) return '-';
  return '₹' + amount.toStringAsFixed(fractionDigits);
}
