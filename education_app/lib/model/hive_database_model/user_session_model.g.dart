// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSessionModelAdapter extends TypeAdapter<UserSessionModel> {
  @override
  final int typeId = 1;

  @override
  UserSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSessionModel(
      userId: fields[0] as int,
      userType: fields[1] as String,
      testId: fields[2] as int,
      subscriptionName: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserSessionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userType)
      ..writeByte(2)
      ..write(obj.testId)
      ..writeByte(3)
      ..write(obj.subscriptionName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
