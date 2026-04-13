// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BikeLogTableTable extends BikeLogTable
    with TableInfo<$BikeLogTableTable, BikeLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BikeLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
      'speed', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _odoMeta = const VerificationMeta('odo');
  @override
  late final GeneratedColumn<double> odo = GeneratedColumn<double>(
      'odo', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _voltageMeta =
      const VerificationMeta('voltage');
  @override
  late final GeneratedColumn<double> voltage = GeneratedColumn<double>(
      'voltage', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currentMeta =
      const VerificationMeta('current');
  @override
  late final GeneratedColumn<double> current = GeneratedColumn<double>(
      'current', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _socMeta = const VerificationMeta('soc');
  @override
  late final GeneratedColumn<double> soc = GeneratedColumn<double>(
      'soc', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempBalanceRegMeta =
      const VerificationMeta('tempBalanceReg');
  @override
  late final GeneratedColumn<double> tempBalanceReg = GeneratedColumn<double>(
      'temp_balance_reg', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempFetMeta =
      const VerificationMeta('tempFet');
  @override
  late final GeneratedColumn<double> tempFet = GeneratedColumn<double>(
      'temp_fet', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempPin1Meta =
      const VerificationMeta('tempPin1');
  @override
  late final GeneratedColumn<double> tempPin1 = GeneratedColumn<double>(
      'temp_pin1', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempPin2Meta =
      const VerificationMeta('tempPin2');
  @override
  late final GeneratedColumn<double> tempPin2 = GeneratedColumn<double>(
      'temp_pin2', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempPin3Meta =
      const VerificationMeta('tempPin3');
  @override
  late final GeneratedColumn<double> tempPin3 = GeneratedColumn<double>(
      'temp_pin3', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempPin4Meta =
      const VerificationMeta('tempPin4');
  @override
  late final GeneratedColumn<double> tempPin4 = GeneratedColumn<double>(
      'temp_pin4', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempMotorMeta =
      const VerificationMeta('tempMotor');
  @override
  late final GeneratedColumn<double> tempMotor = GeneratedColumn<double>(
      'temp_motor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tempControllerMeta =
      const VerificationMeta('tempController');
  @override
  late final GeneratedColumn<double> tempController = GeneratedColumn<double>(
      'temp_controller', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _cellVoltagesJsonMeta =
      const VerificationMeta('cellVoltagesJson');
  @override
  late final GeneratedColumn<String> cellVoltagesJson = GeneratedColumn<String>(
      'cell_voltages_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        timestamp,
        speed,
        odo,
        voltage,
        current,
        soc,
        tempBalanceReg,
        tempFet,
        tempPin1,
        tempPin2,
        tempPin3,
        tempPin4,
        tempMotor,
        tempController,
        cellVoltagesJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bike_logs';
  @override
  VerificationContext validateIntegrity(Insertable<BikeLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
          _speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    }
    if (data.containsKey('odo')) {
      context.handle(
          _odoMeta, odo.isAcceptableOrUnknown(data['odo']!, _odoMeta));
    }
    if (data.containsKey('voltage')) {
      context.handle(_voltageMeta,
          voltage.isAcceptableOrUnknown(data['voltage']!, _voltageMeta));
    }
    if (data.containsKey('current')) {
      context.handle(_currentMeta,
          current.isAcceptableOrUnknown(data['current']!, _currentMeta));
    }
    if (data.containsKey('soc')) {
      context.handle(
          _socMeta, soc.isAcceptableOrUnknown(data['soc']!, _socMeta));
    }
    if (data.containsKey('temp_balance_reg')) {
      context.handle(
          _tempBalanceRegMeta,
          tempBalanceReg.isAcceptableOrUnknown(
              data['temp_balance_reg']!, _tempBalanceRegMeta));
    }
    if (data.containsKey('temp_fet')) {
      context.handle(_tempFetMeta,
          tempFet.isAcceptableOrUnknown(data['temp_fet']!, _tempFetMeta));
    }
    if (data.containsKey('temp_pin1')) {
      context.handle(_tempPin1Meta,
          tempPin1.isAcceptableOrUnknown(data['temp_pin1']!, _tempPin1Meta));
    }
    if (data.containsKey('temp_pin2')) {
      context.handle(_tempPin2Meta,
          tempPin2.isAcceptableOrUnknown(data['temp_pin2']!, _tempPin2Meta));
    }
    if (data.containsKey('temp_pin3')) {
      context.handle(_tempPin3Meta,
          tempPin3.isAcceptableOrUnknown(data['temp_pin3']!, _tempPin3Meta));
    }
    if (data.containsKey('temp_pin4')) {
      context.handle(_tempPin4Meta,
          tempPin4.isAcceptableOrUnknown(data['temp_pin4']!, _tempPin4Meta));
    }
    if (data.containsKey('temp_motor')) {
      context.handle(_tempMotorMeta,
          tempMotor.isAcceptableOrUnknown(data['temp_motor']!, _tempMotorMeta));
    }
    if (data.containsKey('temp_controller')) {
      context.handle(
          _tempControllerMeta,
          tempController.isAcceptableOrUnknown(
              data['temp_controller']!, _tempControllerMeta));
    }
    if (data.containsKey('cell_voltages_json')) {
      context.handle(
          _cellVoltagesJsonMeta,
          cellVoltagesJson.isAcceptableOrUnknown(
              data['cell_voltages_json']!, _cellVoltagesJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BikeLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BikeLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      speed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed'])!,
      odo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}odo'])!,
      voltage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}voltage'])!,
      current: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current'])!,
      soc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}soc'])!,
      tempBalanceReg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}temp_balance_reg'])!,
      tempFet: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_fet'])!,
      tempPin1: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_pin1'])!,
      tempPin2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_pin2'])!,
      tempPin3: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_pin3'])!,
      tempPin4: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_pin4'])!,
      tempMotor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_motor'])!,
      tempController: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}temp_controller'])!,
      cellVoltagesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cell_voltages_json'])!,
    );
  }

  @override
  $BikeLogTableTable createAlias(String alias) {
    return $BikeLogTableTable(attachedDatabase, alias);
  }
}

class BikeLogTableData extends DataClass
    implements Insertable<BikeLogTableData> {
  final int id;
  final int timestamp;
  final double speed;
  final double odo;
  final double voltage;
  final double current;
  final double soc;
  final double tempBalanceReg;
  final double tempFet;
  final double tempPin1;
  final double tempPin2;
  final double tempPin3;
  final double tempPin4;
  final double tempMotor;
  final double tempController;
  final String cellVoltagesJson;
  const BikeLogTableData(
      {required this.id,
      required this.timestamp,
      required this.speed,
      required this.odo,
      required this.voltage,
      required this.current,
      required this.soc,
      required this.tempBalanceReg,
      required this.tempFet,
      required this.tempPin1,
      required this.tempPin2,
      required this.tempPin3,
      required this.tempPin4,
      required this.tempMotor,
      required this.tempController,
      required this.cellVoltagesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<int>(timestamp);
    map['speed'] = Variable<double>(speed);
    map['odo'] = Variable<double>(odo);
    map['voltage'] = Variable<double>(voltage);
    map['current'] = Variable<double>(current);
    map['soc'] = Variable<double>(soc);
    map['temp_balance_reg'] = Variable<double>(tempBalanceReg);
    map['temp_fet'] = Variable<double>(tempFet);
    map['temp_pin1'] = Variable<double>(tempPin1);
    map['temp_pin2'] = Variable<double>(tempPin2);
    map['temp_pin3'] = Variable<double>(tempPin3);
    map['temp_pin4'] = Variable<double>(tempPin4);
    map['temp_motor'] = Variable<double>(tempMotor);
    map['temp_controller'] = Variable<double>(tempController);
    map['cell_voltages_json'] = Variable<String>(cellVoltagesJson);
    return map;
  }

  BikeLogTableCompanion toCompanion(bool nullToAbsent) {
    return BikeLogTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      speed: Value(speed),
      odo: Value(odo),
      voltage: Value(voltage),
      current: Value(current),
      soc: Value(soc),
      tempBalanceReg: Value(tempBalanceReg),
      tempFet: Value(tempFet),
      tempPin1: Value(tempPin1),
      tempPin2: Value(tempPin2),
      tempPin3: Value(tempPin3),
      tempPin4: Value(tempPin4),
      tempMotor: Value(tempMotor),
      tempController: Value(tempController),
      cellVoltagesJson: Value(cellVoltagesJson),
    );
  }

  factory BikeLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BikeLogTableData(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      speed: serializer.fromJson<double>(json['speed']),
      odo: serializer.fromJson<double>(json['odo']),
      voltage: serializer.fromJson<double>(json['voltage']),
      current: serializer.fromJson<double>(json['current']),
      soc: serializer.fromJson<double>(json['soc']),
      tempBalanceReg: serializer.fromJson<double>(json['tempBalanceReg']),
      tempFet: serializer.fromJson<double>(json['tempFet']),
      tempPin1: serializer.fromJson<double>(json['tempPin1']),
      tempPin2: serializer.fromJson<double>(json['tempPin2']),
      tempPin3: serializer.fromJson<double>(json['tempPin3']),
      tempPin4: serializer.fromJson<double>(json['tempPin4']),
      tempMotor: serializer.fromJson<double>(json['tempMotor']),
      tempController: serializer.fromJson<double>(json['tempController']),
      cellVoltagesJson: serializer.fromJson<String>(json['cellVoltagesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<int>(timestamp),
      'speed': serializer.toJson<double>(speed),
      'odo': serializer.toJson<double>(odo),
      'voltage': serializer.toJson<double>(voltage),
      'current': serializer.toJson<double>(current),
      'soc': serializer.toJson<double>(soc),
      'tempBalanceReg': serializer.toJson<double>(tempBalanceReg),
      'tempFet': serializer.toJson<double>(tempFet),
      'tempPin1': serializer.toJson<double>(tempPin1),
      'tempPin2': serializer.toJson<double>(tempPin2),
      'tempPin3': serializer.toJson<double>(tempPin3),
      'tempPin4': serializer.toJson<double>(tempPin4),
      'tempMotor': serializer.toJson<double>(tempMotor),
      'tempController': serializer.toJson<double>(tempController),
      'cellVoltagesJson': serializer.toJson<String>(cellVoltagesJson),
    };
  }

  BikeLogTableData copyWith(
          {int? id,
          int? timestamp,
          double? speed,
          double? odo,
          double? voltage,
          double? current,
          double? soc,
          double? tempBalanceReg,
          double? tempFet,
          double? tempPin1,
          double? tempPin2,
          double? tempPin3,
          double? tempPin4,
          double? tempMotor,
          double? tempController,
          String? cellVoltagesJson}) =>
      BikeLogTableData(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        speed: speed ?? this.speed,
        odo: odo ?? this.odo,
        voltage: voltage ?? this.voltage,
        current: current ?? this.current,
        soc: soc ?? this.soc,
        tempBalanceReg: tempBalanceReg ?? this.tempBalanceReg,
        tempFet: tempFet ?? this.tempFet,
        tempPin1: tempPin1 ?? this.tempPin1,
        tempPin2: tempPin2 ?? this.tempPin2,
        tempPin3: tempPin3 ?? this.tempPin3,
        tempPin4: tempPin4 ?? this.tempPin4,
        tempMotor: tempMotor ?? this.tempMotor,
        tempController: tempController ?? this.tempController,
        cellVoltagesJson: cellVoltagesJson ?? this.cellVoltagesJson,
      );
  BikeLogTableData copyWithCompanion(BikeLogTableCompanion data) {
    return BikeLogTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      speed: data.speed.present ? data.speed.value : this.speed,
      odo: data.odo.present ? data.odo.value : this.odo,
      voltage: data.voltage.present ? data.voltage.value : this.voltage,
      current: data.current.present ? data.current.value : this.current,
      soc: data.soc.present ? data.soc.value : this.soc,
      tempBalanceReg: data.tempBalanceReg.present
          ? data.tempBalanceReg.value
          : this.tempBalanceReg,
      tempFet: data.tempFet.present ? data.tempFet.value : this.tempFet,
      tempPin1: data.tempPin1.present ? data.tempPin1.value : this.tempPin1,
      tempPin2: data.tempPin2.present ? data.tempPin2.value : this.tempPin2,
      tempPin3: data.tempPin3.present ? data.tempPin3.value : this.tempPin3,
      tempPin4: data.tempPin4.present ? data.tempPin4.value : this.tempPin4,
      tempMotor: data.tempMotor.present ? data.tempMotor.value : this.tempMotor,
      tempController: data.tempController.present
          ? data.tempController.value
          : this.tempController,
      cellVoltagesJson: data.cellVoltagesJson.present
          ? data.cellVoltagesJson.value
          : this.cellVoltagesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BikeLogTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('speed: $speed, ')
          ..write('odo: $odo, ')
          ..write('voltage: $voltage, ')
          ..write('current: $current, ')
          ..write('soc: $soc, ')
          ..write('tempBalanceReg: $tempBalanceReg, ')
          ..write('tempFet: $tempFet, ')
          ..write('tempPin1: $tempPin1, ')
          ..write('tempPin2: $tempPin2, ')
          ..write('tempPin3: $tempPin3, ')
          ..write('tempPin4: $tempPin4, ')
          ..write('tempMotor: $tempMotor, ')
          ..write('tempController: $tempController, ')
          ..write('cellVoltagesJson: $cellVoltagesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      timestamp,
      speed,
      odo,
      voltage,
      current,
      soc,
      tempBalanceReg,
      tempFet,
      tempPin1,
      tempPin2,
      tempPin3,
      tempPin4,
      tempMotor,
      tempController,
      cellVoltagesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BikeLogTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.speed == this.speed &&
          other.odo == this.odo &&
          other.voltage == this.voltage &&
          other.current == this.current &&
          other.soc == this.soc &&
          other.tempBalanceReg == this.tempBalanceReg &&
          other.tempFet == this.tempFet &&
          other.tempPin1 == this.tempPin1 &&
          other.tempPin2 == this.tempPin2 &&
          other.tempPin3 == this.tempPin3 &&
          other.tempPin4 == this.tempPin4 &&
          other.tempMotor == this.tempMotor &&
          other.tempController == this.tempController &&
          other.cellVoltagesJson == this.cellVoltagesJson);
}

class BikeLogTableCompanion extends UpdateCompanion<BikeLogTableData> {
  final Value<int> id;
  final Value<int> timestamp;
  final Value<double> speed;
  final Value<double> odo;
  final Value<double> voltage;
  final Value<double> current;
  final Value<double> soc;
  final Value<double> tempBalanceReg;
  final Value<double> tempFet;
  final Value<double> tempPin1;
  final Value<double> tempPin2;
  final Value<double> tempPin3;
  final Value<double> tempPin4;
  final Value<double> tempMotor;
  final Value<double> tempController;
  final Value<String> cellVoltagesJson;
  const BikeLogTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.speed = const Value.absent(),
    this.odo = const Value.absent(),
    this.voltage = const Value.absent(),
    this.current = const Value.absent(),
    this.soc = const Value.absent(),
    this.tempBalanceReg = const Value.absent(),
    this.tempFet = const Value.absent(),
    this.tempPin1 = const Value.absent(),
    this.tempPin2 = const Value.absent(),
    this.tempPin3 = const Value.absent(),
    this.tempPin4 = const Value.absent(),
    this.tempMotor = const Value.absent(),
    this.tempController = const Value.absent(),
    this.cellVoltagesJson = const Value.absent(),
  });
  BikeLogTableCompanion.insert({
    this.id = const Value.absent(),
    required int timestamp,
    this.speed = const Value.absent(),
    this.odo = const Value.absent(),
    this.voltage = const Value.absent(),
    this.current = const Value.absent(),
    this.soc = const Value.absent(),
    this.tempBalanceReg = const Value.absent(),
    this.tempFet = const Value.absent(),
    this.tempPin1 = const Value.absent(),
    this.tempPin2 = const Value.absent(),
    this.tempPin3 = const Value.absent(),
    this.tempPin4 = const Value.absent(),
    this.tempMotor = const Value.absent(),
    this.tempController = const Value.absent(),
    this.cellVoltagesJson = const Value.absent(),
  }) : timestamp = Value(timestamp);
  static Insertable<BikeLogTableData> custom({
    Expression<int>? id,
    Expression<int>? timestamp,
    Expression<double>? speed,
    Expression<double>? odo,
    Expression<double>? voltage,
    Expression<double>? current,
    Expression<double>? soc,
    Expression<double>? tempBalanceReg,
    Expression<double>? tempFet,
    Expression<double>? tempPin1,
    Expression<double>? tempPin2,
    Expression<double>? tempPin3,
    Expression<double>? tempPin4,
    Expression<double>? tempMotor,
    Expression<double>? tempController,
    Expression<String>? cellVoltagesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (speed != null) 'speed': speed,
      if (odo != null) 'odo': odo,
      if (voltage != null) 'voltage': voltage,
      if (current != null) 'current': current,
      if (soc != null) 'soc': soc,
      if (tempBalanceReg != null) 'temp_balance_reg': tempBalanceReg,
      if (tempFet != null) 'temp_fet': tempFet,
      if (tempPin1 != null) 'temp_pin1': tempPin1,
      if (tempPin2 != null) 'temp_pin2': tempPin2,
      if (tempPin3 != null) 'temp_pin3': tempPin3,
      if (tempPin4 != null) 'temp_pin4': tempPin4,
      if (tempMotor != null) 'temp_motor': tempMotor,
      if (tempController != null) 'temp_controller': tempController,
      if (cellVoltagesJson != null) 'cell_voltages_json': cellVoltagesJson,
    });
  }

  BikeLogTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? timestamp,
      Value<double>? speed,
      Value<double>? odo,
      Value<double>? voltage,
      Value<double>? current,
      Value<double>? soc,
      Value<double>? tempBalanceReg,
      Value<double>? tempFet,
      Value<double>? tempPin1,
      Value<double>? tempPin2,
      Value<double>? tempPin3,
      Value<double>? tempPin4,
      Value<double>? tempMotor,
      Value<double>? tempController,
      Value<String>? cellVoltagesJson}) {
    return BikeLogTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      speed: speed ?? this.speed,
      odo: odo ?? this.odo,
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      soc: soc ?? this.soc,
      tempBalanceReg: tempBalanceReg ?? this.tempBalanceReg,
      tempFet: tempFet ?? this.tempFet,
      tempPin1: tempPin1 ?? this.tempPin1,
      tempPin2: tempPin2 ?? this.tempPin2,
      tempPin3: tempPin3 ?? this.tempPin3,
      tempPin4: tempPin4 ?? this.tempPin4,
      tempMotor: tempMotor ?? this.tempMotor,
      tempController: tempController ?? this.tempController,
      cellVoltagesJson: cellVoltagesJson ?? this.cellVoltagesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (odo.present) {
      map['odo'] = Variable<double>(odo.value);
    }
    if (voltage.present) {
      map['voltage'] = Variable<double>(voltage.value);
    }
    if (current.present) {
      map['current'] = Variable<double>(current.value);
    }
    if (soc.present) {
      map['soc'] = Variable<double>(soc.value);
    }
    if (tempBalanceReg.present) {
      map['temp_balance_reg'] = Variable<double>(tempBalanceReg.value);
    }
    if (tempFet.present) {
      map['temp_fet'] = Variable<double>(tempFet.value);
    }
    if (tempPin1.present) {
      map['temp_pin1'] = Variable<double>(tempPin1.value);
    }
    if (tempPin2.present) {
      map['temp_pin2'] = Variable<double>(tempPin2.value);
    }
    if (tempPin3.present) {
      map['temp_pin3'] = Variable<double>(tempPin3.value);
    }
    if (tempPin4.present) {
      map['temp_pin4'] = Variable<double>(tempPin4.value);
    }
    if (tempMotor.present) {
      map['temp_motor'] = Variable<double>(tempMotor.value);
    }
    if (tempController.present) {
      map['temp_controller'] = Variable<double>(tempController.value);
    }
    if (cellVoltagesJson.present) {
      map['cell_voltages_json'] = Variable<String>(cellVoltagesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BikeLogTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('speed: $speed, ')
          ..write('odo: $odo, ')
          ..write('voltage: $voltage, ')
          ..write('current: $current, ')
          ..write('soc: $soc, ')
          ..write('tempBalanceReg: $tempBalanceReg, ')
          ..write('tempFet: $tempFet, ')
          ..write('tempPin1: $tempPin1, ')
          ..write('tempPin2: $tempPin2, ')
          ..write('tempPin3: $tempPin3, ')
          ..write('tempPin4: $tempPin4, ')
          ..write('tempMotor: $tempMotor, ')
          ..write('tempController: $tempController, ')
          ..write('cellVoltagesJson: $cellVoltagesJson')
          ..write(')'))
        .toString();
  }
}

class $TripTableTable extends TripTable
    with TableInfo<$TripTableTable, TripTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startOdoMeta =
      const VerificationMeta('startOdo');
  @override
  late final GeneratedColumn<double> startOdo = GeneratedColumn<double>(
      'start_odo', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _endOdoMeta = const VerificationMeta('endOdo');
  @override
  late final GeneratedColumn<double> endOdo = GeneratedColumn<double>(
      'end_odo', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _distanceKmMeta =
      const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
      'distance_km', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgSpeedKmhMeta =
      const VerificationMeta('avgSpeedKmh');
  @override
  late final GeneratedColumn<double> avgSpeedKmh = GeneratedColumn<double>(
      'avg_speed_kmh', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxSpeedKmhMeta =
      const VerificationMeta('maxSpeedKmh');
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
      'max_speed_kmh', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _energyWhMeta =
      const VerificationMeta('energyWh');
  @override
  late final GeneratedColumn<double> energyWh = GeneratedColumn<double>(
      'energy_wh', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startSocMeta =
      const VerificationMeta('startSoc');
  @override
  late final GeneratedColumn<double> startSoc = GeneratedColumn<double>(
      'start_soc', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _endSocMeta = const VerificationMeta('endSoc');
  @override
  late final GeneratedColumn<double> endSoc = GeneratedColumn<double>(
      'end_soc', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxTempMotorMeta =
      const VerificationMeta('maxTempMotor');
  @override
  late final GeneratedColumn<double> maxTempMotor = GeneratedColumn<double>(
      'max_temp_motor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startTime,
        endTime,
        startOdo,
        endOdo,
        distanceKm,
        durationSeconds,
        avgSpeedKmh,
        maxSpeedKmh,
        energyWh,
        startSoc,
        endSoc,
        maxTempMotor
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(Insertable<TripTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('start_odo')) {
      context.handle(_startOdoMeta,
          startOdo.isAcceptableOrUnknown(data['start_odo']!, _startOdoMeta));
    } else if (isInserting) {
      context.missing(_startOdoMeta);
    }
    if (data.containsKey('end_odo')) {
      context.handle(_endOdoMeta,
          endOdo.isAcceptableOrUnknown(data['end_odo']!, _endOdoMeta));
    } else if (isInserting) {
      context.missing(_endOdoMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(
          _distanceKmMeta,
          distanceKm.isAcceptableOrUnknown(
              data['distance_km']!, _distanceKmMeta));
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('avg_speed_kmh')) {
      context.handle(
          _avgSpeedKmhMeta,
          avgSpeedKmh.isAcceptableOrUnknown(
              data['avg_speed_kmh']!, _avgSpeedKmhMeta));
    } else if (isInserting) {
      context.missing(_avgSpeedKmhMeta);
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
          _maxSpeedKmhMeta,
          maxSpeedKmh.isAcceptableOrUnknown(
              data['max_speed_kmh']!, _maxSpeedKmhMeta));
    } else if (isInserting) {
      context.missing(_maxSpeedKmhMeta);
    }
    if (data.containsKey('energy_wh')) {
      context.handle(_energyWhMeta,
          energyWh.isAcceptableOrUnknown(data['energy_wh']!, _energyWhMeta));
    } else if (isInserting) {
      context.missing(_energyWhMeta);
    }
    if (data.containsKey('start_soc')) {
      context.handle(_startSocMeta,
          startSoc.isAcceptableOrUnknown(data['start_soc']!, _startSocMeta));
    } else if (isInserting) {
      context.missing(_startSocMeta);
    }
    if (data.containsKey('end_soc')) {
      context.handle(_endSocMeta,
          endSoc.isAcceptableOrUnknown(data['end_soc']!, _endSocMeta));
    } else if (isInserting) {
      context.missing(_endSocMeta);
    }
    if (data.containsKey('max_temp_motor')) {
      context.handle(
          _maxTempMotorMeta,
          maxTempMotor.isAcceptableOrUnknown(
              data['max_temp_motor']!, _maxTempMotorMeta));
    } else if (isInserting) {
      context.missing(_maxTempMotorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time'])!,
      startOdo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_odo'])!,
      endOdo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}end_odo'])!,
      distanceKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance_km'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      avgSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_speed_kmh'])!,
      maxSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_speed_kmh'])!,
      energyWh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}energy_wh'])!,
      startSoc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_soc'])!,
      endSoc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}end_soc'])!,
      maxTempMotor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_temp_motor'])!,
    );
  }

  @override
  $TripTableTable createAlias(String alias) {
    return $TripTableTable(attachedDatabase, alias);
  }
}

class TripTableData extends DataClass implements Insertable<TripTableData> {
  final int id;
  final int startTime;
  final int endTime;
  final double startOdo;
  final double endOdo;
  final double distanceKm;
  final int durationSeconds;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final double energyWh;
  final double startSoc;
  final double endSoc;
  final double maxTempMotor;
  const TripTableData(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.startOdo,
      required this.endOdo,
      required this.distanceKm,
      required this.durationSeconds,
      required this.avgSpeedKmh,
      required this.maxSpeedKmh,
      required this.energyWh,
      required this.startSoc,
      required this.endSoc,
      required this.maxTempMotor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    map['start_odo'] = Variable<double>(startOdo);
    map['end_odo'] = Variable<double>(endOdo);
    map['distance_km'] = Variable<double>(distanceKm);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh);
    map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    map['energy_wh'] = Variable<double>(energyWh);
    map['start_soc'] = Variable<double>(startSoc);
    map['end_soc'] = Variable<double>(endSoc);
    map['max_temp_motor'] = Variable<double>(maxTempMotor);
    return map;
  }

  TripTableCompanion toCompanion(bool nullToAbsent) {
    return TripTableCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: Value(endTime),
      startOdo: Value(startOdo),
      endOdo: Value(endOdo),
      distanceKm: Value(distanceKm),
      durationSeconds: Value(durationSeconds),
      avgSpeedKmh: Value(avgSpeedKmh),
      maxSpeedKmh: Value(maxSpeedKmh),
      energyWh: Value(energyWh),
      startSoc: Value(startSoc),
      endSoc: Value(endSoc),
      maxTempMotor: Value(maxTempMotor),
    );
  }

  factory TripTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripTableData(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      startOdo: serializer.fromJson<double>(json['startOdo']),
      endOdo: serializer.fromJson<double>(json['endOdo']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      avgSpeedKmh: serializer.fromJson<double>(json['avgSpeedKmh']),
      maxSpeedKmh: serializer.fromJson<double>(json['maxSpeedKmh']),
      energyWh: serializer.fromJson<double>(json['energyWh']),
      startSoc: serializer.fromJson<double>(json['startSoc']),
      endSoc: serializer.fromJson<double>(json['endSoc']),
      maxTempMotor: serializer.fromJson<double>(json['maxTempMotor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'startOdo': serializer.toJson<double>(startOdo),
      'endOdo': serializer.toJson<double>(endOdo),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'avgSpeedKmh': serializer.toJson<double>(avgSpeedKmh),
      'maxSpeedKmh': serializer.toJson<double>(maxSpeedKmh),
      'energyWh': serializer.toJson<double>(energyWh),
      'startSoc': serializer.toJson<double>(startSoc),
      'endSoc': serializer.toJson<double>(endSoc),
      'maxTempMotor': serializer.toJson<double>(maxTempMotor),
    };
  }

  TripTableData copyWith(
          {int? id,
          int? startTime,
          int? endTime,
          double? startOdo,
          double? endOdo,
          double? distanceKm,
          int? durationSeconds,
          double? avgSpeedKmh,
          double? maxSpeedKmh,
          double? energyWh,
          double? startSoc,
          double? endSoc,
          double? maxTempMotor}) =>
      TripTableData(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        startOdo: startOdo ?? this.startOdo,
        endOdo: endOdo ?? this.endOdo,
        distanceKm: distanceKm ?? this.distanceKm,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
        maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
        energyWh: energyWh ?? this.energyWh,
        startSoc: startSoc ?? this.startSoc,
        endSoc: endSoc ?? this.endSoc,
        maxTempMotor: maxTempMotor ?? this.maxTempMotor,
      );
  TripTableData copyWithCompanion(TripTableCompanion data) {
    return TripTableData(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      startOdo: data.startOdo.present ? data.startOdo.value : this.startOdo,
      endOdo: data.endOdo.present ? data.endOdo.value : this.endOdo,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      avgSpeedKmh:
          data.avgSpeedKmh.present ? data.avgSpeedKmh.value : this.avgSpeedKmh,
      maxSpeedKmh:
          data.maxSpeedKmh.present ? data.maxSpeedKmh.value : this.maxSpeedKmh,
      energyWh: data.energyWh.present ? data.energyWh.value : this.energyWh,
      startSoc: data.startSoc.present ? data.startSoc.value : this.startSoc,
      endSoc: data.endSoc.present ? data.endSoc.value : this.endSoc,
      maxTempMotor: data.maxTempMotor.present
          ? data.maxTempMotor.value
          : this.maxTempMotor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripTableData(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('startOdo: $startOdo, ')
          ..write('endOdo: $endOdo, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('energyWh: $energyWh, ')
          ..write('startSoc: $startSoc, ')
          ..write('endSoc: $endSoc, ')
          ..write('maxTempMotor: $maxTempMotor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      startTime,
      endTime,
      startOdo,
      endOdo,
      distanceKm,
      durationSeconds,
      avgSpeedKmh,
      maxSpeedKmh,
      energyWh,
      startSoc,
      endSoc,
      maxTempMotor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripTableData &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.startOdo == this.startOdo &&
          other.endOdo == this.endOdo &&
          other.distanceKm == this.distanceKm &&
          other.durationSeconds == this.durationSeconds &&
          other.avgSpeedKmh == this.avgSpeedKmh &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.energyWh == this.energyWh &&
          other.startSoc == this.startSoc &&
          other.endSoc == this.endSoc &&
          other.maxTempMotor == this.maxTempMotor);
}

class TripTableCompanion extends UpdateCompanion<TripTableData> {
  final Value<int> id;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<double> startOdo;
  final Value<double> endOdo;
  final Value<double> distanceKm;
  final Value<int> durationSeconds;
  final Value<double> avgSpeedKmh;
  final Value<double> maxSpeedKmh;
  final Value<double> energyWh;
  final Value<double> startSoc;
  final Value<double> endSoc;
  final Value<double> maxTempMotor;
  const TripTableCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.startOdo = const Value.absent(),
    this.endOdo = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.avgSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.energyWh = const Value.absent(),
    this.startSoc = const Value.absent(),
    this.endSoc = const Value.absent(),
    this.maxTempMotor = const Value.absent(),
  });
  TripTableCompanion.insert({
    this.id = const Value.absent(),
    required int startTime,
    required int endTime,
    required double startOdo,
    required double endOdo,
    required double distanceKm,
    required int durationSeconds,
    required double avgSpeedKmh,
    required double maxSpeedKmh,
    required double energyWh,
    required double startSoc,
    required double endSoc,
    required double maxTempMotor,
  })  : startTime = Value(startTime),
        endTime = Value(endTime),
        startOdo = Value(startOdo),
        endOdo = Value(endOdo),
        distanceKm = Value(distanceKm),
        durationSeconds = Value(durationSeconds),
        avgSpeedKmh = Value(avgSpeedKmh),
        maxSpeedKmh = Value(maxSpeedKmh),
        energyWh = Value(energyWh),
        startSoc = Value(startSoc),
        endSoc = Value(endSoc),
        maxTempMotor = Value(maxTempMotor);
  static Insertable<TripTableData> custom({
    Expression<int>? id,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<double>? startOdo,
    Expression<double>? endOdo,
    Expression<double>? distanceKm,
    Expression<int>? durationSeconds,
    Expression<double>? avgSpeedKmh,
    Expression<double>? maxSpeedKmh,
    Expression<double>? energyWh,
    Expression<double>? startSoc,
    Expression<double>? endSoc,
    Expression<double>? maxTempMotor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (startOdo != null) 'start_odo': startOdo,
      if (endOdo != null) 'end_odo': endOdo,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (avgSpeedKmh != null) 'avg_speed_kmh': avgSpeedKmh,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (energyWh != null) 'energy_wh': energyWh,
      if (startSoc != null) 'start_soc': startSoc,
      if (endSoc != null) 'end_soc': endSoc,
      if (maxTempMotor != null) 'max_temp_motor': maxTempMotor,
    });
  }

  TripTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? startTime,
      Value<int>? endTime,
      Value<double>? startOdo,
      Value<double>? endOdo,
      Value<double>? distanceKm,
      Value<int>? durationSeconds,
      Value<double>? avgSpeedKmh,
      Value<double>? maxSpeedKmh,
      Value<double>? energyWh,
      Value<double>? startSoc,
      Value<double>? endSoc,
      Value<double>? maxTempMotor}) {
    return TripTableCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startOdo: startOdo ?? this.startOdo,
      endOdo: endOdo ?? this.endOdo,
      distanceKm: distanceKm ?? this.distanceKm,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      energyWh: energyWh ?? this.energyWh,
      startSoc: startSoc ?? this.startSoc,
      endSoc: endSoc ?? this.endSoc,
      maxTempMotor: maxTempMotor ?? this.maxTempMotor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (startOdo.present) {
      map['start_odo'] = Variable<double>(startOdo.value);
    }
    if (endOdo.present) {
      map['end_odo'] = Variable<double>(endOdo.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (avgSpeedKmh.present) {
      map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (energyWh.present) {
      map['energy_wh'] = Variable<double>(energyWh.value);
    }
    if (startSoc.present) {
      map['start_soc'] = Variable<double>(startSoc.value);
    }
    if (endSoc.present) {
      map['end_soc'] = Variable<double>(endSoc.value);
    }
    if (maxTempMotor.present) {
      map['max_temp_motor'] = Variable<double>(maxTempMotor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripTableCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('startOdo: $startOdo, ')
          ..write('endOdo: $endOdo, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('energyWh: $energyWh, ')
          ..write('startSoc: $startSoc, ')
          ..write('endSoc: $endSoc, ')
          ..write('maxTempMotor: $maxTempMotor')
          ..write(')'))
        .toString();
  }
}

class $ChargeCycleTableTable extends ChargeCycleTable
    with TableInfo<$ChargeCycleTableTable, ChargeCycleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargeCycleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startAtMeta =
      const VerificationMeta('startAt');
  @override
  late final GeneratedColumn<int> startAt = GeneratedColumn<int>(
      'start_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<int> endAt = GeneratedColumn<int>(
      'end_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startSocMeta =
      const VerificationMeta('startSoc');
  @override
  late final GeneratedColumn<double> startSoc = GeneratedColumn<double>(
      'start_soc', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _endSocMeta = const VerificationMeta('endSoc');
  @override
  late final GeneratedColumn<double> endSoc = GeneratedColumn<double>(
      'end_soc', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _socUsedMeta =
      const VerificationMeta('socUsed');
  @override
  late final GeneratedColumn<double> socUsed = GeneratedColumn<double>(
      'soc_used', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startOdoMeta =
      const VerificationMeta('startOdo');
  @override
  late final GeneratedColumn<double> startOdo = GeneratedColumn<double>(
      'start_odo', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _endOdoMeta = const VerificationMeta('endOdo');
  @override
  late final GeneratedColumn<double> endOdo = GeneratedColumn<double>(
      'end_odo', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _distanceKmMeta =
      const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
      'distance_km', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _kmPerPercentMeta =
      const VerificationMeta('kmPerPercent');
  @override
  late final GeneratedColumn<double> kmPerPercent = GeneratedColumn<double>(
      'km_per_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _projectedFullRangeMeta =
      const VerificationMeta('projectedFullRange');
  @override
  late final GeneratedColumn<double> projectedFullRange =
      GeneratedColumn<double>('projected_full_range', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startAt,
        endAt,
        startSoc,
        endSoc,
        socUsed,
        startOdo,
        endOdo,
        distanceKm,
        kmPerPercent,
        projectedFullRange
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charge_cycles';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChargeCycleTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_at')) {
      context.handle(_startAtMeta,
          startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta));
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
          _endAtMeta, endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta));
    } else if (isInserting) {
      context.missing(_endAtMeta);
    }
    if (data.containsKey('start_soc')) {
      context.handle(_startSocMeta,
          startSoc.isAcceptableOrUnknown(data['start_soc']!, _startSocMeta));
    } else if (isInserting) {
      context.missing(_startSocMeta);
    }
    if (data.containsKey('end_soc')) {
      context.handle(_endSocMeta,
          endSoc.isAcceptableOrUnknown(data['end_soc']!, _endSocMeta));
    } else if (isInserting) {
      context.missing(_endSocMeta);
    }
    if (data.containsKey('soc_used')) {
      context.handle(_socUsedMeta,
          socUsed.isAcceptableOrUnknown(data['soc_used']!, _socUsedMeta));
    } else if (isInserting) {
      context.missing(_socUsedMeta);
    }
    if (data.containsKey('start_odo')) {
      context.handle(_startOdoMeta,
          startOdo.isAcceptableOrUnknown(data['start_odo']!, _startOdoMeta));
    } else if (isInserting) {
      context.missing(_startOdoMeta);
    }
    if (data.containsKey('end_odo')) {
      context.handle(_endOdoMeta,
          endOdo.isAcceptableOrUnknown(data['end_odo']!, _endOdoMeta));
    } else if (isInserting) {
      context.missing(_endOdoMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(
          _distanceKmMeta,
          distanceKm.isAcceptableOrUnknown(
              data['distance_km']!, _distanceKmMeta));
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('km_per_percent')) {
      context.handle(
          _kmPerPercentMeta,
          kmPerPercent.isAcceptableOrUnknown(
              data['km_per_percent']!, _kmPerPercentMeta));
    } else if (isInserting) {
      context.missing(_kmPerPercentMeta);
    }
    if (data.containsKey('projected_full_range')) {
      context.handle(
          _projectedFullRangeMeta,
          projectedFullRange.isAcceptableOrUnknown(
              data['projected_full_range']!, _projectedFullRangeMeta));
    } else if (isInserting) {
      context.missing(_projectedFullRangeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChargeCycleTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChargeCycleTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_at'])!,
      endAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_at'])!,
      startSoc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_soc'])!,
      endSoc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}end_soc'])!,
      socUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}soc_used'])!,
      startOdo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_odo'])!,
      endOdo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}end_odo'])!,
      distanceKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance_km'])!,
      kmPerPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}km_per_percent'])!,
      projectedFullRange: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}projected_full_range'])!,
    );
  }

  @override
  $ChargeCycleTableTable createAlias(String alias) {
    return $ChargeCycleTableTable(attachedDatabase, alias);
  }
}

class ChargeCycleTableData extends DataClass
    implements Insertable<ChargeCycleTableData> {
  final int id;
  final int startAt;
  final int endAt;
  final double startSoc;
  final double endSoc;
  final double socUsed;
  final double startOdo;
  final double endOdo;
  final double distanceKm;
  final double kmPerPercent;
  final double projectedFullRange;
  const ChargeCycleTableData(
      {required this.id,
      required this.startAt,
      required this.endAt,
      required this.startSoc,
      required this.endSoc,
      required this.socUsed,
      required this.startOdo,
      required this.endOdo,
      required this.distanceKm,
      required this.kmPerPercent,
      required this.projectedFullRange});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_at'] = Variable<int>(startAt);
    map['end_at'] = Variable<int>(endAt);
    map['start_soc'] = Variable<double>(startSoc);
    map['end_soc'] = Variable<double>(endSoc);
    map['soc_used'] = Variable<double>(socUsed);
    map['start_odo'] = Variable<double>(startOdo);
    map['end_odo'] = Variable<double>(endOdo);
    map['distance_km'] = Variable<double>(distanceKm);
    map['km_per_percent'] = Variable<double>(kmPerPercent);
    map['projected_full_range'] = Variable<double>(projectedFullRange);
    return map;
  }

  ChargeCycleTableCompanion toCompanion(bool nullToAbsent) {
    return ChargeCycleTableCompanion(
      id: Value(id),
      startAt: Value(startAt),
      endAt: Value(endAt),
      startSoc: Value(startSoc),
      endSoc: Value(endSoc),
      socUsed: Value(socUsed),
      startOdo: Value(startOdo),
      endOdo: Value(endOdo),
      distanceKm: Value(distanceKm),
      kmPerPercent: Value(kmPerPercent),
      projectedFullRange: Value(projectedFullRange),
    );
  }

  factory ChargeCycleTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChargeCycleTableData(
      id: serializer.fromJson<int>(json['id']),
      startAt: serializer.fromJson<int>(json['startAt']),
      endAt: serializer.fromJson<int>(json['endAt']),
      startSoc: serializer.fromJson<double>(json['startSoc']),
      endSoc: serializer.fromJson<double>(json['endSoc']),
      socUsed: serializer.fromJson<double>(json['socUsed']),
      startOdo: serializer.fromJson<double>(json['startOdo']),
      endOdo: serializer.fromJson<double>(json['endOdo']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      kmPerPercent: serializer.fromJson<double>(json['kmPerPercent']),
      projectedFullRange:
          serializer.fromJson<double>(json['projectedFullRange']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startAt': serializer.toJson<int>(startAt),
      'endAt': serializer.toJson<int>(endAt),
      'startSoc': serializer.toJson<double>(startSoc),
      'endSoc': serializer.toJson<double>(endSoc),
      'socUsed': serializer.toJson<double>(socUsed),
      'startOdo': serializer.toJson<double>(startOdo),
      'endOdo': serializer.toJson<double>(endOdo),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'kmPerPercent': serializer.toJson<double>(kmPerPercent),
      'projectedFullRange': serializer.toJson<double>(projectedFullRange),
    };
  }

  ChargeCycleTableData copyWith(
          {int? id,
          int? startAt,
          int? endAt,
          double? startSoc,
          double? endSoc,
          double? socUsed,
          double? startOdo,
          double? endOdo,
          double? distanceKm,
          double? kmPerPercent,
          double? projectedFullRange}) =>
      ChargeCycleTableData(
        id: id ?? this.id,
        startAt: startAt ?? this.startAt,
        endAt: endAt ?? this.endAt,
        startSoc: startSoc ?? this.startSoc,
        endSoc: endSoc ?? this.endSoc,
        socUsed: socUsed ?? this.socUsed,
        startOdo: startOdo ?? this.startOdo,
        endOdo: endOdo ?? this.endOdo,
        distanceKm: distanceKm ?? this.distanceKm,
        kmPerPercent: kmPerPercent ?? this.kmPerPercent,
        projectedFullRange: projectedFullRange ?? this.projectedFullRange,
      );
  ChargeCycleTableData copyWithCompanion(ChargeCycleTableCompanion data) {
    return ChargeCycleTableData(
      id: data.id.present ? data.id.value : this.id,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      startSoc: data.startSoc.present ? data.startSoc.value : this.startSoc,
      endSoc: data.endSoc.present ? data.endSoc.value : this.endSoc,
      socUsed: data.socUsed.present ? data.socUsed.value : this.socUsed,
      startOdo: data.startOdo.present ? data.startOdo.value : this.startOdo,
      endOdo: data.endOdo.present ? data.endOdo.value : this.endOdo,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      kmPerPercent: data.kmPerPercent.present
          ? data.kmPerPercent.value
          : this.kmPerPercent,
      projectedFullRange: data.projectedFullRange.present
          ? data.projectedFullRange.value
          : this.projectedFullRange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChargeCycleTableData(')
          ..write('id: $id, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('startSoc: $startSoc, ')
          ..write('endSoc: $endSoc, ')
          ..write('socUsed: $socUsed, ')
          ..write('startOdo: $startOdo, ')
          ..write('endOdo: $endOdo, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('kmPerPercent: $kmPerPercent, ')
          ..write('projectedFullRange: $projectedFullRange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startAt, endAt, startSoc, endSoc, socUsed,
      startOdo, endOdo, distanceKm, kmPerPercent, projectedFullRange);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChargeCycleTableData &&
          other.id == this.id &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.startSoc == this.startSoc &&
          other.endSoc == this.endSoc &&
          other.socUsed == this.socUsed &&
          other.startOdo == this.startOdo &&
          other.endOdo == this.endOdo &&
          other.distanceKm == this.distanceKm &&
          other.kmPerPercent == this.kmPerPercent &&
          other.projectedFullRange == this.projectedFullRange);
}

class ChargeCycleTableCompanion extends UpdateCompanion<ChargeCycleTableData> {
  final Value<int> id;
  final Value<int> startAt;
  final Value<int> endAt;
  final Value<double> startSoc;
  final Value<double> endSoc;
  final Value<double> socUsed;
  final Value<double> startOdo;
  final Value<double> endOdo;
  final Value<double> distanceKm;
  final Value<double> kmPerPercent;
  final Value<double> projectedFullRange;
  const ChargeCycleTableCompanion({
    this.id = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.startSoc = const Value.absent(),
    this.endSoc = const Value.absent(),
    this.socUsed = const Value.absent(),
    this.startOdo = const Value.absent(),
    this.endOdo = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.kmPerPercent = const Value.absent(),
    this.projectedFullRange = const Value.absent(),
  });
  ChargeCycleTableCompanion.insert({
    this.id = const Value.absent(),
    required int startAt,
    required int endAt,
    required double startSoc,
    required double endSoc,
    required double socUsed,
    required double startOdo,
    required double endOdo,
    required double distanceKm,
    required double kmPerPercent,
    required double projectedFullRange,
  })  : startAt = Value(startAt),
        endAt = Value(endAt),
        startSoc = Value(startSoc),
        endSoc = Value(endSoc),
        socUsed = Value(socUsed),
        startOdo = Value(startOdo),
        endOdo = Value(endOdo),
        distanceKm = Value(distanceKm),
        kmPerPercent = Value(kmPerPercent),
        projectedFullRange = Value(projectedFullRange);
  static Insertable<ChargeCycleTableData> custom({
    Expression<int>? id,
    Expression<int>? startAt,
    Expression<int>? endAt,
    Expression<double>? startSoc,
    Expression<double>? endSoc,
    Expression<double>? socUsed,
    Expression<double>? startOdo,
    Expression<double>? endOdo,
    Expression<double>? distanceKm,
    Expression<double>? kmPerPercent,
    Expression<double>? projectedFullRange,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (startSoc != null) 'start_soc': startSoc,
      if (endSoc != null) 'end_soc': endSoc,
      if (socUsed != null) 'soc_used': socUsed,
      if (startOdo != null) 'start_odo': startOdo,
      if (endOdo != null) 'end_odo': endOdo,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (kmPerPercent != null) 'km_per_percent': kmPerPercent,
      if (projectedFullRange != null)
        'projected_full_range': projectedFullRange,
    });
  }

  ChargeCycleTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? startAt,
      Value<int>? endAt,
      Value<double>? startSoc,
      Value<double>? endSoc,
      Value<double>? socUsed,
      Value<double>? startOdo,
      Value<double>? endOdo,
      Value<double>? distanceKm,
      Value<double>? kmPerPercent,
      Value<double>? projectedFullRange}) {
    return ChargeCycleTableCompanion(
      id: id ?? this.id,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      startSoc: startSoc ?? this.startSoc,
      endSoc: endSoc ?? this.endSoc,
      socUsed: socUsed ?? this.socUsed,
      startOdo: startOdo ?? this.startOdo,
      endOdo: endOdo ?? this.endOdo,
      distanceKm: distanceKm ?? this.distanceKm,
      kmPerPercent: kmPerPercent ?? this.kmPerPercent,
      projectedFullRange: projectedFullRange ?? this.projectedFullRange,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<int>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<int>(endAt.value);
    }
    if (startSoc.present) {
      map['start_soc'] = Variable<double>(startSoc.value);
    }
    if (endSoc.present) {
      map['end_soc'] = Variable<double>(endSoc.value);
    }
    if (socUsed.present) {
      map['soc_used'] = Variable<double>(socUsed.value);
    }
    if (startOdo.present) {
      map['start_odo'] = Variable<double>(startOdo.value);
    }
    if (endOdo.present) {
      map['end_odo'] = Variable<double>(endOdo.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (kmPerPercent.present) {
      map['km_per_percent'] = Variable<double>(kmPerPercent.value);
    }
    if (projectedFullRange.present) {
      map['projected_full_range'] = Variable<double>(projectedFullRange.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargeCycleTableCompanion(')
          ..write('id: $id, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('startSoc: $startSoc, ')
          ..write('endSoc: $endSoc, ')
          ..write('socUsed: $socUsed, ')
          ..write('startOdo: $startOdo, ')
          ..write('endOdo: $endOdo, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('kmPerPercent: $kmPerPercent, ')
          ..write('projectedFullRange: $projectedFullRange')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BikeLogTableTable bikeLogTable = $BikeLogTableTable(this);
  late final $TripTableTable tripTable = $TripTableTable(this);
  late final $ChargeCycleTableTable chargeCycleTable =
      $ChargeCycleTableTable(this);
  late final BikeLogDao bikeLogDao = BikeLogDao(this as AppDatabase);
  late final TripDao tripDao = TripDao(this as AppDatabase);
  late final ChargeCycleDao chargeCycleDao =
      ChargeCycleDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [bikeLogTable, tripTable, chargeCycleTable];
}

typedef $$BikeLogTableTableCreateCompanionBuilder = BikeLogTableCompanion
    Function({
  Value<int> id,
  required int timestamp,
  Value<double> speed,
  Value<double> odo,
  Value<double> voltage,
  Value<double> current,
  Value<double> soc,
  Value<double> tempBalanceReg,
  Value<double> tempFet,
  Value<double> tempPin1,
  Value<double> tempPin2,
  Value<double> tempPin3,
  Value<double> tempPin4,
  Value<double> tempMotor,
  Value<double> tempController,
  Value<String> cellVoltagesJson,
});
typedef $$BikeLogTableTableUpdateCompanionBuilder = BikeLogTableCompanion
    Function({
  Value<int> id,
  Value<int> timestamp,
  Value<double> speed,
  Value<double> odo,
  Value<double> voltage,
  Value<double> current,
  Value<double> soc,
  Value<double> tempBalanceReg,
  Value<double> tempFet,
  Value<double> tempPin1,
  Value<double> tempPin2,
  Value<double> tempPin3,
  Value<double> tempPin4,
  Value<double> tempMotor,
  Value<double> tempController,
  Value<String> cellVoltagesJson,
});

class $$BikeLogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BikeLogTableTable,
    BikeLogTableData,
    $$BikeLogTableTableFilterComposer,
    $$BikeLogTableTableOrderingComposer,
    $$BikeLogTableTableCreateCompanionBuilder,
    $$BikeLogTableTableUpdateCompanionBuilder> {
  $$BikeLogTableTableTableManager(_$AppDatabase db, $BikeLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BikeLogTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BikeLogTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<double> speed = const Value.absent(),
            Value<double> odo = const Value.absent(),
            Value<double> voltage = const Value.absent(),
            Value<double> current = const Value.absent(),
            Value<double> soc = const Value.absent(),
            Value<double> tempBalanceReg = const Value.absent(),
            Value<double> tempFet = const Value.absent(),
            Value<double> tempPin1 = const Value.absent(),
            Value<double> tempPin2 = const Value.absent(),
            Value<double> tempPin3 = const Value.absent(),
            Value<double> tempPin4 = const Value.absent(),
            Value<double> tempMotor = const Value.absent(),
            Value<double> tempController = const Value.absent(),
            Value<String> cellVoltagesJson = const Value.absent(),
          }) =>
              BikeLogTableCompanion(
            id: id,
            timestamp: timestamp,
            speed: speed,
            odo: odo,
            voltage: voltage,
            current: current,
            soc: soc,
            tempBalanceReg: tempBalanceReg,
            tempFet: tempFet,
            tempPin1: tempPin1,
            tempPin2: tempPin2,
            tempPin3: tempPin3,
            tempPin4: tempPin4,
            tempMotor: tempMotor,
            tempController: tempController,
            cellVoltagesJson: cellVoltagesJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int timestamp,
            Value<double> speed = const Value.absent(),
            Value<double> odo = const Value.absent(),
            Value<double> voltage = const Value.absent(),
            Value<double> current = const Value.absent(),
            Value<double> soc = const Value.absent(),
            Value<double> tempBalanceReg = const Value.absent(),
            Value<double> tempFet = const Value.absent(),
            Value<double> tempPin1 = const Value.absent(),
            Value<double> tempPin2 = const Value.absent(),
            Value<double> tempPin3 = const Value.absent(),
            Value<double> tempPin4 = const Value.absent(),
            Value<double> tempMotor = const Value.absent(),
            Value<double> tempController = const Value.absent(),
            Value<String> cellVoltagesJson = const Value.absent(),
          }) =>
              BikeLogTableCompanion.insert(
            id: id,
            timestamp: timestamp,
            speed: speed,
            odo: odo,
            voltage: voltage,
            current: current,
            soc: soc,
            tempBalanceReg: tempBalanceReg,
            tempFet: tempFet,
            tempPin1: tempPin1,
            tempPin2: tempPin2,
            tempPin3: tempPin3,
            tempPin4: tempPin4,
            tempMotor: tempMotor,
            tempController: tempController,
            cellVoltagesJson: cellVoltagesJson,
          ),
        ));
}

class $$BikeLogTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BikeLogTableTable> {
  $$BikeLogTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get speed => $state.composableBuilder(
      column: $state.table.speed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get odo => $state.composableBuilder(
      column: $state.table.odo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get voltage => $state.composableBuilder(
      column: $state.table.voltage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get current => $state.composableBuilder(
      column: $state.table.current,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get soc => $state.composableBuilder(
      column: $state.table.soc,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempBalanceReg => $state.composableBuilder(
      column: $state.table.tempBalanceReg,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempFet => $state.composableBuilder(
      column: $state.table.tempFet,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempPin1 => $state.composableBuilder(
      column: $state.table.tempPin1,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempPin2 => $state.composableBuilder(
      column: $state.table.tempPin2,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempPin3 => $state.composableBuilder(
      column: $state.table.tempPin3,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempPin4 => $state.composableBuilder(
      column: $state.table.tempPin4,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempMotor => $state.composableBuilder(
      column: $state.table.tempMotor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempController => $state.composableBuilder(
      column: $state.table.tempController,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cellVoltagesJson => $state.composableBuilder(
      column: $state.table.cellVoltagesJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BikeLogTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BikeLogTableTable> {
  $$BikeLogTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get speed => $state.composableBuilder(
      column: $state.table.speed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get odo => $state.composableBuilder(
      column: $state.table.odo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get voltage => $state.composableBuilder(
      column: $state.table.voltage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get current => $state.composableBuilder(
      column: $state.table.current,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get soc => $state.composableBuilder(
      column: $state.table.soc,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempBalanceReg => $state.composableBuilder(
      column: $state.table.tempBalanceReg,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempFet => $state.composableBuilder(
      column: $state.table.tempFet,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempPin1 => $state.composableBuilder(
      column: $state.table.tempPin1,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempPin2 => $state.composableBuilder(
      column: $state.table.tempPin2,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempPin3 => $state.composableBuilder(
      column: $state.table.tempPin3,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempPin4 => $state.composableBuilder(
      column: $state.table.tempPin4,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempMotor => $state.composableBuilder(
      column: $state.table.tempMotor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempController => $state.composableBuilder(
      column: $state.table.tempController,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cellVoltagesJson => $state.composableBuilder(
      column: $state.table.cellVoltagesJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TripTableTableCreateCompanionBuilder = TripTableCompanion Function({
  Value<int> id,
  required int startTime,
  required int endTime,
  required double startOdo,
  required double endOdo,
  required double distanceKm,
  required int durationSeconds,
  required double avgSpeedKmh,
  required double maxSpeedKmh,
  required double energyWh,
  required double startSoc,
  required double endSoc,
  required double maxTempMotor,
});
typedef $$TripTableTableUpdateCompanionBuilder = TripTableCompanion Function({
  Value<int> id,
  Value<int> startTime,
  Value<int> endTime,
  Value<double> startOdo,
  Value<double> endOdo,
  Value<double> distanceKm,
  Value<int> durationSeconds,
  Value<double> avgSpeedKmh,
  Value<double> maxSpeedKmh,
  Value<double> energyWh,
  Value<double> startSoc,
  Value<double> endSoc,
  Value<double> maxTempMotor,
});

class $$TripTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TripTableTable,
    TripTableData,
    $$TripTableTableFilterComposer,
    $$TripTableTableOrderingComposer,
    $$TripTableTableCreateCompanionBuilder,
    $$TripTableTableUpdateCompanionBuilder> {
  $$TripTableTableTableManager(_$AppDatabase db, $TripTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TripTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TripTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> startTime = const Value.absent(),
            Value<int> endTime = const Value.absent(),
            Value<double> startOdo = const Value.absent(),
            Value<double> endOdo = const Value.absent(),
            Value<double> distanceKm = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<double> avgSpeedKmh = const Value.absent(),
            Value<double> maxSpeedKmh = const Value.absent(),
            Value<double> energyWh = const Value.absent(),
            Value<double> startSoc = const Value.absent(),
            Value<double> endSoc = const Value.absent(),
            Value<double> maxTempMotor = const Value.absent(),
          }) =>
              TripTableCompanion(
            id: id,
            startTime: startTime,
            endTime: endTime,
            startOdo: startOdo,
            endOdo: endOdo,
            distanceKm: distanceKm,
            durationSeconds: durationSeconds,
            avgSpeedKmh: avgSpeedKmh,
            maxSpeedKmh: maxSpeedKmh,
            energyWh: energyWh,
            startSoc: startSoc,
            endSoc: endSoc,
            maxTempMotor: maxTempMotor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int startTime,
            required int endTime,
            required double startOdo,
            required double endOdo,
            required double distanceKm,
            required int durationSeconds,
            required double avgSpeedKmh,
            required double maxSpeedKmh,
            required double energyWh,
            required double startSoc,
            required double endSoc,
            required double maxTempMotor,
          }) =>
              TripTableCompanion.insert(
            id: id,
            startTime: startTime,
            endTime: endTime,
            startOdo: startOdo,
            endOdo: endOdo,
            distanceKm: distanceKm,
            durationSeconds: durationSeconds,
            avgSpeedKmh: avgSpeedKmh,
            maxSpeedKmh: maxSpeedKmh,
            energyWh: energyWh,
            startSoc: startSoc,
            endSoc: endSoc,
            maxTempMotor: maxTempMotor,
          ),
        ));
}

class $$TripTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TripTableTable> {
  $$TripTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startTime => $state.composableBuilder(
      column: $state.table.startTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endTime => $state.composableBuilder(
      column: $state.table.endTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get startOdo => $state.composableBuilder(
      column: $state.table.startOdo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get endOdo => $state.composableBuilder(
      column: $state.table.endOdo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get distanceKm => $state.composableBuilder(
      column: $state.table.distanceKm,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get durationSeconds => $state.composableBuilder(
      column: $state.table.durationSeconds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get avgSpeedKmh => $state.composableBuilder(
      column: $state.table.avgSpeedKmh,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get maxSpeedKmh => $state.composableBuilder(
      column: $state.table.maxSpeedKmh,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get energyWh => $state.composableBuilder(
      column: $state.table.energyWh,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get startSoc => $state.composableBuilder(
      column: $state.table.startSoc,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get endSoc => $state.composableBuilder(
      column: $state.table.endSoc,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get maxTempMotor => $state.composableBuilder(
      column: $state.table.maxTempMotor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TripTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TripTableTable> {
  $$TripTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startTime => $state.composableBuilder(
      column: $state.table.startTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endTime => $state.composableBuilder(
      column: $state.table.endTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get startOdo => $state.composableBuilder(
      column: $state.table.startOdo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get endOdo => $state.composableBuilder(
      column: $state.table.endOdo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get distanceKm => $state.composableBuilder(
      column: $state.table.distanceKm,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get durationSeconds => $state.composableBuilder(
      column: $state.table.durationSeconds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get avgSpeedKmh => $state.composableBuilder(
      column: $state.table.avgSpeedKmh,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get maxSpeedKmh => $state.composableBuilder(
      column: $state.table.maxSpeedKmh,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get energyWh => $state.composableBuilder(
      column: $state.table.energyWh,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get startSoc => $state.composableBuilder(
      column: $state.table.startSoc,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get endSoc => $state.composableBuilder(
      column: $state.table.endSoc,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get maxTempMotor => $state.composableBuilder(
      column: $state.table.maxTempMotor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ChargeCycleTableTableCreateCompanionBuilder
    = ChargeCycleTableCompanion Function({
  Value<int> id,
  required int startAt,
  required int endAt,
  required double startSoc,
  required double endSoc,
  required double socUsed,
  required double startOdo,
  required double endOdo,
  required double distanceKm,
  required double kmPerPercent,
  required double projectedFullRange,
});
typedef $$ChargeCycleTableTableUpdateCompanionBuilder
    = ChargeCycleTableCompanion Function({
  Value<int> id,
  Value<int> startAt,
  Value<int> endAt,
  Value<double> startSoc,
  Value<double> endSoc,
  Value<double> socUsed,
  Value<double> startOdo,
  Value<double> endOdo,
  Value<double> distanceKm,
  Value<double> kmPerPercent,
  Value<double> projectedFullRange,
});

class $$ChargeCycleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChargeCycleTableTable,
    ChargeCycleTableData,
    $$ChargeCycleTableTableFilterComposer,
    $$ChargeCycleTableTableOrderingComposer,
    $$ChargeCycleTableTableCreateCompanionBuilder,
    $$ChargeCycleTableTableUpdateCompanionBuilder> {
  $$ChargeCycleTableTableTableManager(
      _$AppDatabase db, $ChargeCycleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChargeCycleTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChargeCycleTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> startAt = const Value.absent(),
            Value<int> endAt = const Value.absent(),
            Value<double> startSoc = const Value.absent(),
            Value<double> endSoc = const Value.absent(),
            Value<double> socUsed = const Value.absent(),
            Value<double> startOdo = const Value.absent(),
            Value<double> endOdo = const Value.absent(),
            Value<double> distanceKm = const Value.absent(),
            Value<double> kmPerPercent = const Value.absent(),
            Value<double> projectedFullRange = const Value.absent(),
          }) =>
              ChargeCycleTableCompanion(
            id: id,
            startAt: startAt,
            endAt: endAt,
            startSoc: startSoc,
            endSoc: endSoc,
            socUsed: socUsed,
            startOdo: startOdo,
            endOdo: endOdo,
            distanceKm: distanceKm,
            kmPerPercent: kmPerPercent,
            projectedFullRange: projectedFullRange,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int startAt,
            required int endAt,
            required double startSoc,
            required double endSoc,
            required double socUsed,
            required double startOdo,
            required double endOdo,
            required double distanceKm,
            required double kmPerPercent,
            required double projectedFullRange,
          }) =>
              ChargeCycleTableCompanion.insert(
            id: id,
            startAt: startAt,
            endAt: endAt,
            startSoc: startSoc,
            endSoc: endSoc,
            socUsed: socUsed,
            startOdo: startOdo,
            endOdo: endOdo,
            distanceKm: distanceKm,
            kmPerPercent: kmPerPercent,
            projectedFullRange: projectedFullRange,
          ),
        ));
}

class $$ChargeCycleTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ChargeCycleTableTable> {
  $$ChargeCycleTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startAt => $state.composableBuilder(
      column: $state.table.startAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endAt => $state.composableBuilder(
      column: $state.table.endAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get startSoc => $state.composableBuilder(
      column: $state.table.startSoc,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get endSoc => $state.composableBuilder(
      column: $state.table.endSoc,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get socUsed => $state.composableBuilder(
      column: $state.table.socUsed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get startOdo => $state.composableBuilder(
      column: $state.table.startOdo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get endOdo => $state.composableBuilder(
      column: $state.table.endOdo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get distanceKm => $state.composableBuilder(
      column: $state.table.distanceKm,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get kmPerPercent => $state.composableBuilder(
      column: $state.table.kmPerPercent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get projectedFullRange => $state.composableBuilder(
      column: $state.table.projectedFullRange,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ChargeCycleTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ChargeCycleTableTable> {
  $$ChargeCycleTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startAt => $state.composableBuilder(
      column: $state.table.startAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endAt => $state.composableBuilder(
      column: $state.table.endAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get startSoc => $state.composableBuilder(
      column: $state.table.startSoc,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get endSoc => $state.composableBuilder(
      column: $state.table.endSoc,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get socUsed => $state.composableBuilder(
      column: $state.table.socUsed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get startOdo => $state.composableBuilder(
      column: $state.table.startOdo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get endOdo => $state.composableBuilder(
      column: $state.table.endOdo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get distanceKm => $state.composableBuilder(
      column: $state.table.distanceKm,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get kmPerPercent => $state.composableBuilder(
      column: $state.table.kmPerPercent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get projectedFullRange => $state.composableBuilder(
      column: $state.table.projectedFullRange,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BikeLogTableTableTableManager get bikeLogTable =>
      $$BikeLogTableTableTableManager(_db, _db.bikeLogTable);
  $$TripTableTableTableManager get tripTable =>
      $$TripTableTableTableManager(_db, _db.tripTable);
  $$ChargeCycleTableTableTableManager get chargeCycleTable =>
      $$ChargeCycleTableTableTableManager(_db, _db.chargeCycleTable);
}
