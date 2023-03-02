class IdCria {
  late int _id_vaca = 0;



  IdCria(this._id_vaca);




  int get id_vaca => _id_vaca;

  set id_vaca(int value) {
    _id_vaca = value;
  }
  IdCria.deMapParaModel(Map<String, dynamic> map) {
    this._id_vaca = map['id'];



  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] =_id_vaca;
    return map;
  }
}