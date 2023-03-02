



class Cria {
  String _nomeV = "_nomeV";
  String _quantiaNasceu = "quantiaNasceu";
  String _dataInse = "dataInse";

  String get quantiaNasceu => _quantiaNasceu;

  set quantiaNasceu(String value) {
    _quantiaNasceu = value;
  }

  String _dataParto = "dataParto";





  String get nomeV => _nomeV;

  set nomeV(String value) {
    _nomeV = value;
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['_nomeV'] =_nomeV;
    map['quantiaNasceu'] =_quantiaNasceu;
    map['dataInse'] =_dataInse;
    map['dataParto'] =_dataParto;

    return map;
  }
  Cria.deMapParaModel(Map<String, dynamic> map) {
    this._nomeV = map['_nomeV'];
    this._quantiaNasceu = map['quantiaNasceu'];
    this._dataInse = map['dataInse'];
    this._dataParto = map['dataParto'];

  }
  Cria(this._nomeV,this._quantiaNasceu, this._dataInse, this._dataParto);

  String get dataInse => _dataInse;

  set dataInse(String value) {
    _dataInse = value;
  }

  String get dataParto => _dataParto;

  set dataParto(String value) {
    _dataParto = value;
  }
}
