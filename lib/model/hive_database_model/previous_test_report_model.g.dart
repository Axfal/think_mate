// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'previous_test_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreviousTestReportModelAdapter
    extends TypeAdapter<PreviousTestReportModel> {
  @override
  final int typeId = 2;

  @override
  PreviousTestReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreviousTestReportModel(
      date: fields[0] as String,
      subject: fields[1] as String,
      percentage: fields[2] as int,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreviousTestReportModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.percentage)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreviousTestReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
