import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:grex_bov/modelo/idCria.dart';
import 'package:grex_bov/modelo/inseminacao.dart';
import 'package:grex_bov/pages/rebanho.dart';

import '../modelo/Cria.dart';
import '../modelo/Id.dart';

import '../modelo/Vaca.dart';
import '../modelo/Vacina.dart';
import '../utils/AjudaVaca.dart';
import 'Dados.dart';

class EditarVaca extends StatefulWidget {
  const EditarVaca({Key? key}) : super(key: key);

  @override
  State<EditarVaca> createState() => _EditarVacaState();
}

class _EditarVacaState extends State<EditarVaca> {
  AjudaVaca _db = AjudaVaca();
  Vaca v = Dados.vacasEdit[0];
  String auxRaca = "";
  String? valor;
  DateTime? _dateTime;
  String? erroNome;
  String? erroNumero;
  String auxTime = "";
  String auxImg = "";
  ImagePicker imagePicker = ImagePicker();
  TextEditingController nome = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController data = TextEditingController();
  String auxAltNome = "";

  File? imagem;
  AjudaVaca rec = AjudaVaca();

  List<String> racas = [
    "Holandesa",
    "Jersey",
    "Pardo Suiço",
    "Gir",
    "Girolanda",
    "Guzerá",
    "Sindi"
  ];

  List<Id> ids = <Id>[];
  List<Id> vaciN = <Id>[];
  List<Vacina> vacinas = <Vacina>[];
  List<Inseminacao> inseminacaos = <Inseminacao>[];
  List<Cria> criasAlt = <Cria>[];
  List<Vaca> vacas = <Vaca>[];

  @override
  void initState() {
    super.initState();
    mostraVaca();
  }

  mostraVaca() async {
    List vacasRec = await _db.listarVacas();

    print(vacasRec);
    List<Vaca> vTemp = <Vaca>[];

    for (var x in vacasRec) {
      Vaca vac = Vaca.deMapParaModel(x);

      vTemp.insert(0, vac);
    }
    setState(() {
      vacas = vTemp;

      print(vTemp);
    });
  }

  @override
  Widget build(BuildContext context) {
    auxAltNome = v.nome;
    nome.text = v.nome;
    numero.text = v.numero;
    auxTime = v.dateTime;
    auxRaca = v.raca;
    auxImg = v.imagem;
    return Scaffold(
      backgroundColor: Color(0xFFB0D6D9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        // here the desired height
        child: AppBar(
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
            child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Rebanho()));
                },
                icon: Icon(Icons.arrow_back)),
          ),
          backgroundColor: Color(0xB30A3638),
          automaticallyImplyLeading: true,
          title: Text(
            'EDITAR',
            style: TextStyle(fontSize: 33),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    radius: 71,
                                    backgroundColor: Color(0xB30A3638),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFF94AB9A),
                                      radius: 65,
                                      backgroundImage: imagem == null
                                          ? FileImage(File(v.imagem))
                                          : FileImage(imagem!),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 92,
                                  left: 74,
                                  child: RawMaterialButton(
                                    fillColor: Color(0xFF92CFD3),
                                    child: Icon(Icons.add_a_photo),
                                    padding: EdgeInsets.all(10),
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      _pegarImagem();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: nome,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          errorText: erroNome,
                          labelText: "Nome da vaca",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          hintText: "Ex: Mimosa",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Color(0xB30A3638)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Color(0xFF0C5756)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: numero,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          label: (Text("Número de vaca")),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          hintText: "Ex: 16",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Color(0xB30A3638)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Color(0xFF0C5756)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Color(0xFF0C5756), width: 2),
                        ),
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                            "Selecione o periodo",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                          value: valor,
                          dropdownColor: Color(0xFFFFFFFF),
                          icon: const Icon(Icons.keyboard_arrow_down_sharp),
                          elevation: 16,
                          style: const TextStyle(
                              color: Color(0xFF000000), fontSize: 17),
                          items: racas
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              valor = newValue!;
                            });
                          },
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      width: 380,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(width: 3, color: Color(0xB30A3638)),
                        ),
                        icon: Icon(Icons.calendar_month,
                            size: 30, color: Colors.black),
                        label: Text(
                          _dateTime == null
                              ? '${v.dateTime}'
                              : DateFormat('dd/MM/yy').format(_dateTime!),
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        onPressed: () {
                          showDatePicker(
                            helpText:
                                "Selecione a Nova Data de Nascimento da Vaca",
                            cancelText: "Calcelar",
                            confirmText: "Confirmar",
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3022),
                          ).then((date) {
                            setState(() {
                              _dateTime = date;
                              auxTime = DateFormat('dd/MM/yy')
                                  .format(_dateTime!)
                                  .toString();
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rebanho()));
                        },
                        child: Text(
                          "VOLTAR",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF098799),
                            fixedSize: const Size(100, 50),
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)))),
                    TextButton(
                        onPressed: () {
                          for (var x in vacas) {
                            if (x.nome == nome.text) {
                              setState(() {
                                erroNome = "Esse nome já existe";
                              });
                              return;
                            }
                          }
                          if (nome.text.isEmpty) {
                            setState(() {
                              erroNome = "Informe o nome da vaca";
                            });
                          }

                          if (numero.text.isEmpty) {
                            setState(() {
                              erroNumero = "Informe o número da vaca";
                            });
                          } else {
                            if (valor != null) {
                              auxRaca = valor!;
                            }
                            if (imagem != null) {
                              auxImg = imagem.toString();
                            }
                            Vaca ver = Vaca(
                                nome.text,
                                numero.text,
                                auxRaca,
                                auxTime,
                                auxImg
                                    .replaceAll("File: '", "")
                                    .replaceAll("'", ""));

                            editarVaca(ver);
                          }

                          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Rebanho()),(Route<dynamic> route) => false);
                        },
                        child: Text(
                          "SALVAR",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF098799),
                            fixedSize: const Size(100, 50),
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)))),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  pegarCamera() async {
    var imagemTemporaria =
        await imagePicker.getImage(source: ImageSource.camera);

    if (imagemTemporaria != null) {
      setState(() {
        imagem = File(imagemTemporaria.path);
      });
    }
  }

  editarVaca(Vaca ver) async {
    List vacasRec = await rec.listarVacas();

    List idVac = await rec.listarVacinas();

    vacinas.clear();
    vaciN.clear();
    List<Id> vTemp = <Id>[];
    List<Id> vTempVac = <Id>[];

    for (var x in vacasRec) {
      Id vac = Id.deMapParaModel(x);

      vTemp.add(vac);
    }
    for (var d in idVac) {
      Id vaci = Id.deMapParaModel(d);
      vTempVac.add(vaci);
    }
    setState(() {
      vaciN = vTempVac;
      ids = vTemp;
      print(ids[0].nomeVacaId);
    });
    for (var x in ids) {
      if (x.nomeVacaId == v.nome) {
        List inseminacao = await rec.listarInseminacoes();
        List vacina = await rec.listarVacinas();
        List criasRec = await rec.listarCria();
        if (!inseminacao.isEmpty) {
          for (var y in inseminacao) {
            Inseminacao i = Inseminacao.deMapParaModel(y);
            if (i.nomeVac == v.nome) {
              i.nomeVac = ver.nome;
              inseminacaos.add(i);
              _db.alterarInseminacao(inseminacaos[0], x.nomeVacaId);
              inseminacaos.clear();
            }
          }
        }
        if (!vacina.isEmpty) {
          for (var y in vacina) {
            Vacina va = Vacina.deMapParaModel(y);
            if (va.nomeVaca == v.nome) {
              for (var f in vaciN) {
                if (f.nomeVacaId == v.nome) {
                  va.nomeVaca = ver.nome;
                  vacinas.add(va);
                  _db.alterarVacinaNome(vacinas[0], f.id_vaca);
                  vacinas.clear();
                  vaciN.remove(f);
                  break;
                }
              }
            }
          }
        }
        //------------------------
        if (!criasRec.isEmpty) {
          for (var y in criasRec) {
            Cria c = Cria.deMapParaModel(y);
            IdCria ic = IdCria.deMapParaModel(y);
            if (c.nomeV == v.nome) {
              c.nomeV = ver.nome;
              criasAlt.add(c);
              _db.alterarCria(criasAlt[0], ic.id_vaca);
              criasAlt.clear();


            }
          }
        }
        // Cria c = Cria(ver.nome, "1");
        // _db.alterarCria(c, nome.text);

        _db.alterarVaca(ver, x.id_vaca);

        Dados.vacas.clear();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Rebanho()));
      }
    }
  }

  void _pegarImagem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Pegar imagem"),
          content: Container(
              height: 50,
              width: 380,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF098799),
                          fixedSize: const Size(80, 30),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        pegarCamera();
                        Navigator.pop(context);
                      },
                      child: Text("FOTO")),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF098799),
                          fixedSize: const Size(80, 30),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        pegarGaleria();
                        Navigator.pop(context);
                      },
                      child: Text("GALERIA")),
                ],
              )),
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
          ],
        );
      },
    );
  }

  pegarGaleria() async {
    final PickedFile? imagemTemporaria =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (imagemTemporaria != null) {
      setState(() {
        imagem = File(imagemTemporaria.path);
      });
    }
  }
}
