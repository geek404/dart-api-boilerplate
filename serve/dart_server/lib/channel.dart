import 'package:dart_server/controller/words_controller.dart';

import 'dart_server.dart';

class DartServerChannel extends ApplicationChannel {
//member variable
ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final datamodel = ManagedDataModel.fromCurrentMirrorSystem();

    final config = WordsConfig(options.configurationFilePath);  //configutationFilePath gets info from config.yaml  

    final database = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName,
      );

      context = ManagedContext(datamodel,database);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/words/[:id]") 
      .link(() => WordsController(context));

    return router;
  }
}

//gettings variable value from config.yaml
class WordsConfig extends Configuration{
  WordsConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;   //this is refering to database keyword in config.yaml
}