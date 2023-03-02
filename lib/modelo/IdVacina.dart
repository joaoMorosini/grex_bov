class IdVacina {
  late int _id_vaca = 0;
  late String _nomeVacaId = "_nomeVacaId";
late String _nomeVacina = "";

  String get nomeVacina => _nomeVacina;

  set nomeVacina(String value) {
    _nomeVacina = value;
  }

  IdVacina( this._nomeVacaId,this._id_vaca, this._nomeVacina);

  String get nomeVacaId => _nomeVacaId;

  set nomeVacaId(String value) {
    _nomeVacaId = value;
  }

  int get id_vaca => _id_vaca;

  set id_vaca(int value) {
    _id_vaca = value;
  }
  IdVacina.deMapParaModel(Map<String, dynamic> map) {
    this._id_vaca = map['id'];
    this._nomeVacaId = map["nome"];
    this._nomeVacina = map["nomeVacina"];


  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] =_id_vaca;
    map['nome'] =_nomeVacaId;
    map['nomeVacina'] =_nomeVacina;
    return map;
  }
}