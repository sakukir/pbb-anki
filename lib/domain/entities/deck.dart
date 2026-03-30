/// 卡组实体
class Deck {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final int cardCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Deck({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.cardCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Deck copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? cardCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      cardCount: cardCount ?? this.cardCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Deck && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Deck(id: $id, name: $name, cardCount: $cardCount)';
}
