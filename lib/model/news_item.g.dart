// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsItemAdapter extends TypeAdapter<NewsItem> {
  @override
  final int typeId = 0;

  @override
  NewsItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsItem(
      title: fields[0] as String,
      summary: fields[1] as String,
      details: fields[2] as String,
      sourceUrl: fields[3] as String?,
      source: fields[6] as String?,
      date: fields[4] as String?,
      responseType: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NewsItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.details)
      ..writeByte(3)
      ..write(obj.sourceUrl)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.responseType)
    ..writeByte(6)
    ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
