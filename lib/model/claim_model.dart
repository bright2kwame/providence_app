import 'package:sqfentity_gen/sqfentity_gen.dart';


const tableClaim = SqfEntityTable(
  tableName: 'claim',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('isActive', DbType.bool, defaultValue: true),
  ]
);
