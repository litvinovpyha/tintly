class CalculatorLogicService {
  final Map<String, int> _quantities = {};
  final Map<String, double> _prices = {};
  final Map<String, String> _productNames = {};

  void setQuantity(String calculatorFieldId, int quantity) {
    _quantities[calculatorFieldId] = quantity;
  }

  int? getQuantity(String calculatorFieldId) {
    return _quantities[calculatorFieldId];
  }

  void setPrice(String calculatorFieldId, double price) {
    _prices[calculatorFieldId] = price;
  }

  void setProductName(String calculatorFieldId, String productName) {
    _productNames[calculatorFieldId] = productName;
  }

  double getFieldTotal(String calculatorFieldId) {
    final qty = _quantities[calculatorFieldId] ?? 0;
    final price = _prices[calculatorFieldId] ?? 0;
    return qty * price;
  }

  double get total {
    double sum = 0;
    for (final entry in _quantities.entries) {
      final id = entry.key;
      final qty = entry.value;
      final price = _prices[id] ?? 0;
      sum += qty * price;
    }
    return sum;
  }

  Map<String, double> getConsumptionData() {
    final Map<String, double> consumption = {};
    print('Getting consumption data:');
    print('Quantities: $_quantities');
    print('Product names: $_productNames');

    for (final entry in _quantities.entries) {
      final id = entry.key;
      final qty = entry.value.toDouble();
      final productName = _productNames[id];

      print('Processing: id=$id, qty=$qty, productName=$productName');

      if (qty > 0 && productName != null) {
        if (consumption.containsKey(productName)) {
          consumption[productName] = consumption[productName]! + qty;
        } else {
          consumption[productName] = qty;
        }
        print(
          'Added to consumption: $productName = ${consumption[productName]}',
        );
      }
    }
    print('Final consumption data: $consumption');
    return consumption;
  }

  void clear() {
    _quantities.clear();
    _prices.clear();
    _productNames.clear();
  }
}
