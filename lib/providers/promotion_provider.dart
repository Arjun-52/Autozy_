import 'package:flutter/foundation.dart';
import '../data/repositories/promotion_repository.dart';
import '../data/models/promotion_model.dart';

class PromotionProvider extends ChangeNotifier {
  final PromotionRepository _promotionRepository;

  PromotionProvider(this._promotionRepository);

  List<PromotionModel> _promotions = [];
  bool _isLoading = false;
  String? _error;

  List<PromotionModel> get promotions => _promotions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPromotions => _promotions.isNotEmpty;

  Future<void> fetchPromotions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _promotions = await _promotionRepository.getActivePromotions();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
