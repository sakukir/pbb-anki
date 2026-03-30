import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/deck.dart';

part 'deck_model.g.dart';

@collection
class DeckModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index(type: IndexType.value)
  late String name;

  String? description;

  @Index()
  String? category;

  late int cardCount;
  late DateTime createdAt;
  late DateTime updatedAt;

  DeckModel();

  /// 从领域实体转换
  factory DeckModel.fromEntity(Deck deck) {
    return DeckModel()
      ..id = deck.id
      ..name = deck.name
      ..description = deck.description
      ..category = deck.category
      ..cardCount = deck.cardCount
      ..createdAt = deck.createdAt
      ..updatedAt = deck.updatedAt;
  }

  /// 转换为领域实体
  Deck toEntity() {
    return Deck(
      id: id,
      name: name,
      description: description,
      category: category,
      cardCount: cardCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
