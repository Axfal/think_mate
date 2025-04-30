// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submitted_questions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubmittedQuestionsModelAdapter
    extends TypeAdapter<SubmittedQuestionsModel> {
  @override
  final int typeId = 3;

  @override
  SubmittedQuestionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubmittedQuestionsModel(
      questionId: fields[0] as int? ?? 0,
      chapterId: fields[3] as int? ?? 0,
      questionResult: fields[1] as String? ?? '',
      selectedOption: fields[2] as int? ?? -1,
    );
  }

  @override
  void write(BinaryWriter writer, SubmittedQuestionsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.questionResult)
      ..writeByte(2)
      ..write(obj.selectedOption)
      ..writeByte(3)
      ..write(obj.chapterId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SubmittedQuestionsModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
