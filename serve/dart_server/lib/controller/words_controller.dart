import 'package:dart_server/dart_server.dart';
import 'package:dart_server/model/word.dart'; 

class WordsController extends ResourceController{

WordsController(this.context);
ManagedContext context;


// HTTP METHODS
  @Operation.get()
  Future<Response> getAllWords( {@Bind.query('q') String prefix}) async {     //binding query value
    // Word refers to Model class
    final query = Query<Word>(context);

    if(prefix != null) {
        query.where((w) => w.word).beginsWith(prefix, caseSensitive: false);   //  (w) => w.word is property identifier
    }

    // if we want to sort order then
    query
    ..sortBy((w) => w.word, QuerySortOrder.ascending)
    ..fetchLimit = 10;

    final wordList = await query.fetch();
    return Response.ok(wordList);
  }


  @Operation.get('id')
  Future<Response> getWordById(@Bind.path('id') /* casting here with int */ int id) async {

    final query = Query<Word>(context)
    ..where((w) => w.id).equalTo(id);
    final word = await query.fetchOne();
    return Response.ok(word);
  }



  @Operation.post()
  Future<Response> addWord(@Bind.body(ignore: ['id']) Word newWord) async{

    final query = Query<Word>(context)
      ..values = newWord;

    final insertedWord = await query.insert();

      return Response.ok(insertedWord);
  }



  @Operation.put('id')
  Future<Response> updateWord(@Bind.path('id') /* casting here with int */ int id,
  /* from post */ @Bind.body(ignore: ['id']) Word updateWord) async{

    final query = Query<Word>(context)
      ..values = updateWord
      ..where((w) => w.id).equalTo(id);

      final updatedWord = await query.updateOne();

      return Response.ok(updatedWord);
  }

  @Operation.delete('id')
  Future<Response> deleteWord(@Bind.path('id') /* casting here with int */ int id) async{

    final query = Query<Word>(context)
      ..where((w) => w.id).equalTo(id);

      final deleteWord = await query.delete();
      //final message
      final message = {'message': 'Deleted $deleteWord word(s)'};
      return Response.ok(message);
  }

}