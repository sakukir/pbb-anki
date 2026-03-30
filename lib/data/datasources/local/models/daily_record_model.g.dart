// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_record_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyRecordModelCollection on Isar {
  IsarCollection<DailyRecordModel> get dailyRecordModels => this.collection();
}

const DailyRecordModelSchema = CollectionSchema(
  name: r'DailyRecordModel',
  id: -3283885705235519275,
  properties: {
    r'cardsReviewed': PropertySchema(
      id: 0,
      name: r'cardsReviewed',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.string,
    ),
    r'newCardsStudied': PropertySchema(
      id: 2,
      name: r'newCardsStudied',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyRecordModelEstimateSize,
  serialize: _dailyRecordModelSerialize,
  deserialize: _dailyRecordModelDeserialize,
  deserializeProp: _dailyRecordModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyRecordModelGetId,
  getLinks: _dailyRecordModelGetLinks,
  attach: _dailyRecordModelAttach,
  version: '3.1.0+1',
);

int _dailyRecordModelEstimateSize(
  DailyRecordModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  return bytesCount;
}

void _dailyRecordModelSerialize(
  DailyRecordModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cardsReviewed);
  writer.writeString(offsets[1], object.date);
  writer.writeLong(offsets[2], object.newCardsStudied);
}

DailyRecordModel _dailyRecordModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyRecordModel();
  object.cardsReviewed = reader.readLong(offsets[0]);
  object.date = reader.readString(offsets[1]);
  object.isarId = id;
  object.newCardsStudied = reader.readLong(offsets[2]);
  return object;
}

P _dailyRecordModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyRecordModelGetId(DailyRecordModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _dailyRecordModelGetLinks(DailyRecordModel object) {
  return [];
}

void _dailyRecordModelAttach(
    IsarCollection<dynamic> col, Id id, DailyRecordModel object) {
  object.isarId = id;
}

extension DailyRecordModelByIndex on IsarCollection<DailyRecordModel> {
  Future<DailyRecordModel?> getByDate(String date) {
    return getByIndex(r'date', [date]);
  }

  DailyRecordModel? getByDateSync(String date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(String date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(String date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyRecordModel?>> getAllByDate(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyRecordModel?> getAllByDateSync(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyRecordModel object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyRecordModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyRecordModel> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyRecordModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyRecordModelQueryWhereSort
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QWhere> {
  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyRecordModelQueryWhere
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QWhereClause> {
  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      dateEqualTo(String date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterWhereClause>
      dateNotEqualTo(String date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DailyRecordModelQueryFilter
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QFilterCondition> {
  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      cardsReviewedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardsReviewed',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      cardsReviewedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cardsReviewed',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      cardsReviewedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cardsReviewed',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      cardsReviewedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cardsReviewed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      newCardsStudiedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newCardsStudied',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      newCardsStudiedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'newCardsStudied',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      newCardsStudiedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'newCardsStudied',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterFilterCondition>
      newCardsStudiedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'newCardsStudied',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyRecordModelQueryObject
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QFilterCondition> {}

extension DailyRecordModelQueryLinks
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QFilterCondition> {}

extension DailyRecordModelQuerySortBy
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QSortBy> {
  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      sortByCardsReviewed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsReviewed', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      sortByCardsReviewedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsReviewed', Sort.desc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      sortByNewCardsStudied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newCardsStudied', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      sortByNewCardsStudiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newCardsStudied', Sort.desc);
    });
  }
}

extension DailyRecordModelQuerySortThenBy
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QSortThenBy> {
  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByCardsReviewed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsReviewed', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByCardsReviewedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsReviewed', Sort.desc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByNewCardsStudied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newCardsStudied', Sort.asc);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QAfterSortBy>
      thenByNewCardsStudiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newCardsStudied', Sort.desc);
    });
  }
}

extension DailyRecordModelQueryWhereDistinct
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QDistinct> {
  QueryBuilder<DailyRecordModel, DailyRecordModel, QDistinct>
      distinctByCardsReviewed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardsReviewed');
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyRecordModel, DailyRecordModel, QDistinct>
      distinctByNewCardsStudied() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'newCardsStudied');
    });
  }
}

extension DailyRecordModelQueryProperty
    on QueryBuilder<DailyRecordModel, DailyRecordModel, QQueryProperty> {
  QueryBuilder<DailyRecordModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DailyRecordModel, int, QQueryOperations>
      cardsReviewedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardsReviewed');
    });
  }

  QueryBuilder<DailyRecordModel, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyRecordModel, int, QQueryOperations>
      newCardsStudiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'newCardsStudied');
    });
  }
}
