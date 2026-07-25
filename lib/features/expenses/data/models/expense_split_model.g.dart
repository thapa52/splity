// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_split_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseSplitModelAdapter extends TypeAdapter<ExpenseSplitModel> {
  @override
  final int typeId = 2;

  @override
  ExpenseSplitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseSplitModel(
      memberName: fields[0] as String,
      amount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseSplitModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.memberName)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseSplitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
