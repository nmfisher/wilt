import 'package:json_object_lite/json_object_lite.dart';
import 'package:wilt/src/nosql_document.dart';

class NoSqlJsonObjectLite extends JsonObjectLite with NoSqlDocument {
  
  String toJson() {
    return this.toString();
  }
}