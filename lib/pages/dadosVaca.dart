import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:grex_bov/modelo/Cria.dart';
import 'package:grex_bov/modelo/Vacina.dart';
import 'package:grex_bov/pages/Partos.dart';

import 'package:grex_bov/pages/vacinas.dart';

import '../modelo/inseminacao.dart';
import '../modelo/Vaca.dart';

import '../utils/AjudaVaca.dart';
import 'Dados.dart';

class DadosVaca extends StatefulWidget {
  const DadosVaca({Key? key}) : super(key: key);

  @override
  State<DadosVaca> createState() => _DadosVacaState();
}

class _DadosVacaState extends State<DadosVaca> {
  String? erroQtd;
  String dataEnxertou = "";
  String secar = "";
  String dataParto = "";
  String dataCriar = "";
  String inseminada = "";
  String situacaoAtual = "0";
  String dataMostar = "null";
  String? valor;
  String? situacaoCria;
  Vaca v = Dados.vacas[0];
  String nomeV = "";
  AjudaVaca _db = AjudaVaca();
  TextEditingController dataIn = TextEditingController();
  TextEditingController quantia = TextEditingController();
  DateTime? _dateTime;
  List<Inseminacao> inseminacaos = <Inseminacao>[];
  List<Inseminacao> crias = <Inseminacao>[];
  String dataConf = "";
  List<String> sexo = ["Macho", "Fêmea"];
  List<String> situacao = ["Vivo", "Morto"];
  List<Inseminacao> listaEnxertou = <Inseminacao>[];
  List<Cria> partos = <Cria>[];
  String primeiroParto = "";
  String ultimoParto = "";
  int filhos = 0;
  int qtdPartos = 0;

  void salvarCio() {
    setState(() {
      Inseminacao i = Inseminacao(
          nomeV, DateFormat('dd/MM/yy').format(_dateTime!).toString(), "null");
      _db.inserirCio(i);
    });
  }

  editaCio() {
    Inseminacao i = Inseminacao(
        nomeV, DateFormat('dd/MM/yy').format(_dateTime!).toString(), "null");
    _db.alterarInseminacao(i, nomeV);
  }

  /* void salvarCria() {
    setState(() {
      Cria c = Cria(nomeV, situacaoAtual);
      _db.inserirCria(c);
    });
  }
  */

  /*mostraCria() async {
    List cria = await _db.listarInseminacoes();

    List<Inseminacao> vTemp = <Inseminacao>[];

    for (var x in cria) {
      Inseminacao c = Inseminacao.deMapParaModel(x);

      vTemp.add(c);
    }
    setState(() {
      crias = vTemp;
      int s = -1;
      for (var x in crias) {
        s++;
        if (x.nomeVac == nomeV) {
          if (x.dataEnxertou != "null"){
            situacaoAtual = "1";
            dataEnxertou = x.dataEnxertou;
          }

        }
      }
    });
  }
*/
  void removerCria(String cria) async {
    await _db.excluirCria(cria);
    await _db.excluirInseminacao(cria);
  }

  mostraParto() async {
    List cioRec = await _db.listarCria();
    List<Cria> vTemp = <Cria>[];
    for (var x in cioRec) {
      Cria c = Cria.deMapParaModel(x);

      vTemp.add(c);
    }
    partos.clear();
    for (var x in vTemp) {
      if (v.nome == x.nomeV) {
        partos.add(x);
      }
    }
    setState(() {
      qtdPartos = 0;
      qtdPartos = partos.length;
      primeiroParto = partos[0].dataParto;
      ultimoParto = partos[partos.length - 1].dataParto;
      filhos = 0;
    });

    for (var x in partos) {
      setState(() {
        filhos += int.parse(x.quantiaNasceu);
      });
    }
  }

  void removerIns(String ins) async {
    await _db.excluirInseminacao(ins);
    situacaoAtual = "0";
    dataMostar = "null";
  }

  mostraCio() async {
    List cioRec = await _db.listarInseminacoes();

    print(cioRec);
    List<Inseminacao> vTemp = <Inseminacao>[];

    for (var x in cioRec) {
      Inseminacao cio = Inseminacao.deMapParaModel(x);

      vTemp.add(cio);
    }
    setState(() {
      inseminacaos = vTemp;
      int s = -1;
      for (var x in inseminacaos) {
        s++;
        if (x.nomeVac == v.nome) {
          dataMostar = x.dataInseminacao;

          if (x.dataEnxertou != "null") {
            setState(() {
              dataEnxertou = x.dataEnxertou;
              situacaoAtual = "1";
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    nomeV = v.nome;
    mostraParto();
    mostraCio();
  }

  onSelected(BuildContext context, int item) {
    setState(() {
      Dados.vacaVac.clear();
      Dados.vacaVac.add(v.nome);
      Dados.vacaVac.add(v.numero);
    });
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Partos()));
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime data = DateTime.now();
    int dataAtual = int.parse(DateFormat('yy').format(data).toString());
    List<String> dataVaca = v.dateTime.split("/");
    int dataArrumar = int.parse(dataVaca[dataVaca.length - 1]);
    print(dataArrumar == dataAtual);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          // here the desired height
          child: AppBar(
            actions: [
              PopupMenuButton<int>(
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) =>
                      [PopupMenuItem<int>(value: 0, child: Text("Partos"))]),
            ],
            centerTitle: true,
            leading: Padding(
                padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back))),
            backgroundColor: Color(0xB30A3638),
            automaticallyImplyLeading: true,
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Text(
                '${v.nome}',
                style: TextStyle(fontSize: 30),
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "GERAIS",
                ),
                Tab(
                  text: "REPRODUÇÂO",
                ),
                Tab(
                  text: "PRODUÇÂO",
                ),
              ],
              indicatorColor: Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text(
                        "Nome: ${v.nome}",
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text("Número: ${v.numero}",
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text(
                        "Nascimento: ${v.dateTime}",
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text(
                        "Raça: ${v.raca}",
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text("Idade: ${dataAtual - dataArrumar} anos",
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF2FA0B0),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: 250,
                      child: TextButton(
                          onPressed: () {
                            Dados.vacaVac.clear();
                            Dados.vacaVac.add(v.nome);
                            Dados.vacaVac.add(v.numero);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Vacinas()));
                          },
                          child: Text("VACINAS",
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                color: Colors.black,
                                fontSize: 23,
                              ))),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text(
                        "Quantidade de Partos: ${qtdPartos}",
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text("Quantidade de Filhos: ${filhos}",
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text(
                        "Primeiro parto: ${primeiroParto}",
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffAAC7C4),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      child: Text("Ultimo parto: ${ultimoParto}",
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Color(0xffAAC7C4),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text("Situação Atual",
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  color: Colors.black,
                                  fontSize: 25,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            dataMostar == "null" && situacaoAtual == "0"
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Color(0xffAAC7C4),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      children: [
                                        Text("Nenhum registro encontrado",
                                            style: const TextStyle(
                                              fontFamily: 'Times New Roman',
                                              color: Colors.black,
                                              fontSize: 20,
                                            )),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Color(0xFF098799),
                                          ),
                                          child: TextButton(
                                              onPressed: () {
                                                _exibirDialogoData();
                                              },
                                              child: Text("NOVA INSEMINAÇÂO",
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'Times New Roman',
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ))),
                                        ),
                                      ],
                                    ))
                                : dataMostar != "null" && situacaoAtual == "0"
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xffAAC7C4),
                                        ),
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        padding: EdgeInsets.all(12),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Text(" A vaca está inseminada",
                                                style: const TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                )),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("Dia:  ${dataMostar}",
                                                style: const TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                )),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("Enxerta em:  ${calcData()}",
                                                style: const TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                )),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _dateTime = null;
                                                      _exibirDialogoDataPrenha();
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF098799),
                                                      fixedSize:
                                                          const Size(80, 30),
                                                      primary: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24))),
                                                  child: const Text(
                                                    'ENXERTOU',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _dateTime = null;
                                                    });
                                                    _exibirDialogoDataEdita();
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF098799),
                                                      fixedSize:
                                                          const Size(80, 30),
                                                      primary: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24))),
                                                  child: const Text(
                                                    'REPETIU',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _dateTime = null;
                                                    _exibirDialogoCio();
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF098799),
                                                      fixedSize:
                                                          const Size(80, 30),
                                                      primary: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24))),
                                                  child: const Text(
                                                    'CANCELAR',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : situacaoAtual == "1"
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: Color(0xffAAC7C4),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Column(
                                              children: [
                                                Text(" A vaca está prenha",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    )),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                    "Inseminada:  ${dataMostar}",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    )),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                    "Enxertou em: ${dataEnxertou} ",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    )),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                    "Secar em:  ${calcDataSec()}",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    )),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Previsão de parto:  ${prevParto()}",
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'Times New Roman',
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        _dateTime = null;
                                                        valor = null;

                                                        _exibirDialogoParto();
                                                      },
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Color(0xFF098799),
                                                          fixedSize: const Size(
                                                              80, 30),
                                                          primary: Colors.black,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15))),
                                                      child: const Text(
                                                        'PARIU',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        _exibirDialogoCan();
                                                      },
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Color(0xFF098799),
                                                          fixedSize: const Size(
                                                              80, 30),
                                                          primary: Colors.black,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15))),
                                                      child: const Text(
                                                        'CANCELAR',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ))
                                        : Container(),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  void _exibirDialogoData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Inseminação"),
          content: Container(
            height: 50,
            width: 380,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(width: 2, color: Color(0xB30A3638)),
              ),
              icon: Icon(Icons.calendar_month, size: 30, color: Colors.black),
              label: Text(
                _dateTime == null
                    ? 'Data da Inseminação'
                    : DateFormat('dd/MM/yy').format(_dateTime!),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              onPressed: () {
                showDatePicker(
                  helpText: "Selecione a Data de Inseminação",
                  cancelText: "Calcelar",
                  confirmText: "Confirmar",
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now(),
                ).then((date) {
                  setState(() {
                    _dateTime = date;
                    Navigator.pop(context);
                    _exibirDialogoData();
                  });
                });
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                if (_dateTime == null) {
                  Fluttertoast.showToast(
                      msg: "Selecione a data de inseminação",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 15);
                } else {
                  nomeV = v.nome;
                  salvarCio();
                  mostraCio();

                  print(dataMostar);
                  Navigator.pop(context);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoDataEdita() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Nova Inseminação"),
          content: Container(
            height: 50,
            width: 380,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(width: 2, color: Color(0xB30A3638)),
              ),
              icon: Icon(Icons.calendar_month, size: 30, color: Colors.black),
              label: Text(
                _dateTime == null
                    ? 'Nova Inseminação'
                    : DateFormat('dd/MM/yy').format(_dateTime!),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              onPressed: () {
                showDatePicker(
                  helpText: "Selecione a Data de Inseminação",
                  cancelText: "Calcelar",
                  confirmText: "Confirmar",
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now(),
                ).then((date) {
                  setState(() {
                    _dateTime = date;
                    Navigator.pop(context);
                    _exibirDialogoDataEdita();
                  });
                });
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                if (_dateTime == null) {
                  Fluttertoast.showToast(
                      msg: "Selecione a data de inseminação",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 15);
                } else {
                  nomeV = v.nome;
                  editaCio();
                  mostraCio();

                  print(dataMostar);
                  Navigator.pop(context);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoDataPrenha() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Confirmar inseminação"),
          content: Container(
            height: 50,
            width: 380,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(width: 2, color: Color(0xB30A3638)),
              ),
              icon: Icon(Icons.calendar_month, size: 30, color: Colors.black),
              label: Text(
                _dateTime == null
                    ? 'Confirmação da prenhez'
                    : DateFormat('dd/MM/yy').format(_dateTime!),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              onPressed: () {
                showDatePicker(
                  helpText: "Selecione a Data de prenhez",
                  cancelText: "Calcelar",
                  confirmText: "Confirmar",
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now(),
                ).then((date) {
                  setState(() {
                    _dateTime = date;
                    Navigator.pop(context);
                    _exibirDialogoDataPrenha();
                  });
                });
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () async {
                if (_dateTime == null) {
                  Fluttertoast.showToast(
                      msg: "Selecione a data de confimação",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 15);
                } else {
                  AjudaVaca rec = AjudaVaca();
                  List vacasRec = await rec.listarInseminacoes();
                  List<Inseminacao> vTempVac = <Inseminacao>[];

                  for (var x in vacasRec) {
                    Inseminacao vac = Inseminacao.deMapParaModel(x);

                    vTempVac.add(vac);
                  }

                  setState(() {
                    listaEnxertou = vTempVac;
                  });
                  for (var x in listaEnxertou) {
                    if (x.nomeVac == v.nome) {
                      x.dataEnxertou =
                          DateFormat('dd/MM/yy').format(_dateTime!).toString();
                      dataEnxertou =
                          DateFormat('dd/MM/yy').format(_dateTime!).toString();
                      _db.alterarInseminacao(x, v.nome);
                    }
                  }

                  mostraCio();

                  print(dataMostar);
                  Navigator.pop(context);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  calcData() {
    List<String> v = dataMostar.split("/");
    int dia = int.parse(v[0]);
    int mes = int.parse(v[1]);
    int ano = int.parse(v[2]);
    dia += 21;
    if (dia > 30) {
      mes += 1;
      dia = dia - 30;
    }
    if (mes > 12) {
      mes = mes - 12;
      ano += 1;
    }

    print(dia);
    print(mes);
    print(ano);
    dataConf = dia.toString() + "/";
    dataConf += mes.toString() + "/";
    dataConf += ano.toString();

    return dataConf;
  }

  calcDataSec() {
    List<String> v = dataEnxertou.split("/");
    int dia = int.parse(v[0]);
    int mes = int.parse(v[1]);
    int ano = int.parse(v[2]);
    int mesSecar = mes;
    mesSecar += 7;
    int anoSecar = ano;
    mes += 9;
    if (mes > 12) {
      mes = mes - 12;
      ano += 1;
    }
    if (mesSecar > 12) {
      mesSecar = mesSecar - 12;
      anoSecar += 1;
    }

    secar = dia.toString() + "/";
    secar += mesSecar.toString() + "/";
    secar += anoSecar.toString();
    return secar;
  }

  calcDiaEnxertou() {
    print(dataEnxertou);
    return dataEnxertou;
  }

  prevParto() {
    List<String> v = dataEnxertou.split("/");
    int dia = int.parse(v[0]);
    int mes = int.parse(v[1]);
    int ano = int.parse(v[2]);
    int mesSecar = mes;
    mesSecar += 7;
    int anoSecar = ano;
    mes += 9;
    if (mes > 12) {
      mes = mes - 12;
      ano += 1;
    }
    if (mesSecar > 12) {
      mesSecar = mesSecar - 12;
      anoSecar += 1;
    }

    dataParto = dia.toString() + "/";
    dataParto += mes.toString() + "/";
    dataParto += ano.toString();
    secar = dia.toString() + "/";
    secar += mesSecar.toString() + "/";
    secar += anoSecar.toString();
    return dataParto;
  }

  void _exibirDialogoCan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Cancelar gestação"),
          content: Container(
              height: 50,
              width: 380,
              child: Text("Tem certeza que deseja cancelar a gestação?")),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Não"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                removerIns(v.nome);
                setState(() {
                  Navigator.pop(context);
                  situacaoAtual = "0";
                  dataMostar = "null";
                  mostraCio();
                });
              },
              child: Text("Sim"),
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoCio() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Cancelar inseminação"),
          content: Container(
              height: 50,
              width: 380,
              child: Text("Tem certeza que deseja cancelar a inseminação?")),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Não"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xFF000000),
              ),
              onPressed: () {
                removerIns(v.nome);
                setState(() {
                  situacaoAtual = "0";
                  dataMostar = "null";
                  mostraCio();
                });

                Navigator.pop(context);
              },
              child: Text("Sim"),
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoParto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            alignment: Alignment.center,
            backgroundColor: Color(0xFFFFFFFF),
            title: Text("Dados do nascimento"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Informe os dados referentes ao parto da vaca"),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: quantia,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      errorText: erroQtd,
                      border: OutlineInputBorder(),
                      labelText: 'Quantidade que nasceu',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                      hintText: "Ex: 1",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xB30A3638)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xFF0C5756)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  width: 380,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(width: 2, color: Color(0xB30A3638)),
                    ),
                    icon: Icon(Icons.calendar_month,
                        size: 30, color: Colors.black),
                    label: Text(
                      _dateTime == null
                          ? 'Data do Parto'
                          : DateFormat('dd/MM/yy').format(_dateTime!),
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () {
                      showDatePicker(
                        helpText: "Selecione a Data do parto",
                        cancelText: "Calcelar",
                        confirmText: "Confirmar",
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime.now(),
                      ).then((date) {
                        setState(() {
                          _dateTime = date;
                          Navigator.pop(context);
                          _exibirDialogoParto();
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Color(0xFF000000),
                ),
                onPressed: () {
                  setState(() {
                    _dateTime == null;
                  });

                  Navigator.pop(context);
                },
                child: Text("Não"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Color(0xFF000000),
                ),
                onPressed: () {
                  if (quantia.text.isEmpty) {
                    setState(() {
                      Navigator.pop(context);
                      erroQtd = "Informe a quantidade";
                      _exibirDialogoParto();
                    });
                    return;
                  } else {
                    erroQtd = null;
                  }
                  if (_dateTime == null) {
                    Fluttertoast.showToast(
                        msg: "Selecione a data do parto",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 15);
                  } else {
                    setState(() {
                      Navigator.pop(context);
                      Cria c = Cria(v.nome, quantia.text, dataMostar,
                          DateFormat('dd/MM/yy').format(_dateTime!).toString());
                      _db.inserirCria(c);
                      Dados.vacaVac.clear();
                      Dados.vacaVac.add(v.nome);
                      Dados.vacaVac.add(v.numero);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Partos()));
                      quantia.clear();
                      _dateTime = null;
                      removerIns(v.nome);
                      situacaoAtual = "0";
                      dataMostar = "null";
                      mostraCio();
                      mostraParto();
                    });
                  }
                },
                child: const Text("Sim"),
              ),
            ]);
      },
    );
  }
}
