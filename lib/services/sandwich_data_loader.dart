import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';

/// Loads the sandwiches JSON file from assets and returns the raw list maps.
Future<List<Map<String, dynamic>>> loadSandwichData() async {
  final String jsonString =
      await rootBundle.loadString('assets/images/sandwiches.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  final list = jsonData['sandwiches'];
  if (list is List) {
    return List<Map<String, dynamic>>.from(list);
  }
  return const [];
}

/// Converts a dynamic map into a [Sandwich] if possible.
/// Expects fields: type (string), isFootlong (bool), breadType (string)
Sandwich? sandwichFromMap(Map<String, dynamic> map) {
  try {
    final typeStr = (map['type'] as String?) ?? '';
    final breadStr = (map['breadType'] as String?) ?? '';
    final isFootlong = (map['isFootlong'] as bool?) ?? true;

    final type = SandwichType.values.firstWhere(
      (t) => t.name.toLowerCase() == typeStr.toLowerCase(),
      orElse: () => SandwichType.veggieDelight,
    );
    final bread = BreadType.values.firstWhere(
      (b) => b.name.toLowerCase() == breadStr.toLowerCase(),
      orElse: () => BreadType.white,
    );

    return Sandwich(type: type, isFootlong: isFootlong, breadType: bread);
  } catch (_) {
    return null;
  }
}

/// Loads and parses sandwiches into [Sandwich] model objects.
Future<List<Sandwich>> loadSandwichModels() async {
  final raw = await loadSandwichData();
  final models = <Sandwich>[];
  for (final m in raw) {
    final s = sandwichFromMap(m);
    if (s != null) models.add(s);
  }
  return models;
}
