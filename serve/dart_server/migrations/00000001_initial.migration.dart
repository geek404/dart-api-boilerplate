import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration1 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Word", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("word", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),SchemaColumn("content", ManagedPropertyType.document, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {
    final rows = [
      {'word': 'horse', 'content': '{"description": "animal you can ride"}'},
      {'word': 'camel', 'content': '{"description": "animal with humps"}'},
      {'word': 'sheep', 'content': '{"description": "animal with wool"}'},
       {'word': 'goat', 'content': '{"description": "animal with horns"}'}
    ];

    for(final row in rows){
        await database.store.execute(
          "INSERT INTO _Word(word, content) VALUES (@word, @content)",
          substitutionValues: {
            "word": row['word'],
            "content": row['content'],
          }
        );
    }
  }
}
    