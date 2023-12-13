// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 0;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..balance = fields[2] as double
      ..icon = fields[3] as IconData?
      ..notes = fields[4] as String
      ..operations = (fields[5] as List).cast<Operation>()
      ..deleted = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.operations)
      ..writeByte(6)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final int typeId = 3;

  @override
  IconData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IconData(
      fields[0] as int,
      fontFamily: fields[1] as String?,
      fontPackage: fields[2] as String?,
      matchTextDirection: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.codePoint)
      ..writeByte(1)
      ..write(obj.fontFamily)
      ..writeByte(2)
      ..write(obj.fontPackage)
      ..writeByte(3)
      ..write(obj.matchTextDirection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
