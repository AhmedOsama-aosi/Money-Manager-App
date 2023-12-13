// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Operation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationAdapter extends TypeAdapter<Operation> {
  @override
  final int typeId = 1;

  @override
  Operation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Operation()
      ..id = fields[0] as String
      ..fromAccountId = fields[1] as String
      ..toAccountId = fields[2] as String
      ..operationName = fields[3] as String
      ..operationNotes = fields[4] as String
      ..value = fields[5] as double
      ..fromAccountBalanceAfter = fields[6] as double
      ..toAccountBalanceAfter = fields[7] as double
      ..dateTime = fields[8] as DateTime
      ..operationType = fields[9] as OperationType;
  }

  @override
  void write(BinaryWriter writer, Operation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromAccountId)
      ..writeByte(2)
      ..write(obj.toAccountId)
      ..writeByte(3)
      ..write(obj.operationName)
      ..writeByte(4)
      ..write(obj.operationNotes)
      ..writeByte(5)
      ..write(obj.value)
      ..writeByte(6)
      ..write(obj.fromAccountBalanceAfter)
      ..writeByte(7)
      ..write(obj.toAccountBalanceAfter)
      ..writeByte(8)
      ..write(obj.dateTime)
      ..writeByte(9)
      ..write(obj.operationType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OperationTypeAdapter extends TypeAdapter<OperationType> {
  @override
  final int typeId = 2;

  @override
  OperationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OperationType.cashIn;
      case 1:
        return OperationType.cashout;
      case 2:
        return OperationType.transfare;
      default:
        return OperationType.cashIn;
    }
  }

  @override
  void write(BinaryWriter writer, OperationType obj) {
    switch (obj) {
      case OperationType.cashIn:
        writer.writeByte(0);
        break;
      case OperationType.cashout:
        writer.writeByte(1);
        break;
      case OperationType.transfare:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
