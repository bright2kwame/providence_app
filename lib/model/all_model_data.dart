import 'dart:convert';
import 'dart:typed_data';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'user_model.dart';
import 'claim_model.dart';


const SqfEntitySequence seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  //modelName: 'SQEidentity', 
                      /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  //cycle : false,    /* optional. default is false; */
  //minValue = 0;     /* optional. default is 0 */
  //incrementBy = 1;  /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

// STEP 3: Create your Database Model constant instanced from SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases. So you can create many Database Models and use them in the application.
@SqfEntityBuilder(myDbModel)
const SqfEntityModel myDbModel = SqfEntityModel(
    modelName: null,
    databaseName: 'providenceORM.db',
    // put defined tables into the tables list.
    databaseTables: [tableUser, tableClaim,],
     // You can define tables to generate add/edit view forms if you want to use Form Generator property
    formTables: [tableUser, tableClaim,],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    bundledDatabasePath:
        null // 'assets/sample.db' // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
);
