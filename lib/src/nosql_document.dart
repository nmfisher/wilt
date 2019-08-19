
mixin NoSqlDocument {
  
  bool deleted;
  String id;
  String rev;
  String toJson();

}