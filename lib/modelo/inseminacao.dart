

class Inseminacao{
  String _dataInseminacao = "inseminada";
  late String _dataEnxertou = "dataEnxertou";

  String get dataInseminacao => _dataInseminacao;

  set dataInseminacao(String value) {
    _dataInseminacao = value;
  }

  late String _nomeVac;

  String get nomeVac => _nomeVac;

  set nomeVac(String value) {
    _nomeVac = value;
  }



  String get inseminacao => _dataInseminacao;

  set inseminacao(String value) {
    _dataInseminacao = value;
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['_nomeVac'] =_nomeVac;
    map['_dataInseminacao'] = _dataInseminacao;
    map['dataEnxertou'] = _dataEnxertou;

    return map;
  }
  Inseminacao.deMapParaModel(Map<String, dynamic> map) {
    this._nomeVac = map['_nomeVac'];
    this._dataInseminacao = map['_dataInseminacao'];
    this._dataEnxertou = map['dataEnxertou'];

  }
  Inseminacao(this._nomeVac,this._dataInseminacao, this._dataEnxertou);

  String get dataEnxertou => _dataEnxertou;

  set dataEnxertou(String value) {
    _dataEnxertou = value;
  }
}