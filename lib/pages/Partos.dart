import 'package:flutter/material.dart';
import 'package:grex_bov/utils/AjudaVaca.dart';

import '../modelo/Cria.dart';
import 'Dados.dart';

class Partos extends StatefulWidget {
  const Partos({Key? key}) : super(key: key);

  @override
  State<Partos> createState() => _PartosState();
}

class _PartosState extends State<Partos> {
  AjudaVaca v = AjudaVaca();
  List<Cria> crias = <Cria>[];
int contPartos = 0;
  mostraPartos() async {
    List vacasRec = await v.listarCria();

    print(vacasRec);
    List<Cria> vTemp = <Cria>[];

    for (var x in vacasRec) {
      Cria vac = Cria.deMapParaModel(x);

      vTemp.add(vac);
    }
    crias.clear();
    for(var x in vTemp){
      if (x.nomeV == Dados.vacaVac[0]){
        setState(() {
          crias.add(x);

        });
      }
    }

  }

  @override
  void initState() {
    super.initState();

    mostraPartos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xB30A3638),
          automaticallyImplyLeading: true,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'PARTOS',
              style: TextStyle(fontSize: 33),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                  child: Column(

                      children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xffAAC7C4),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(12),

                  child: Column(children: [
                    Text(
                      "Vaca: ${Dados.vacaVac[0]}",
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Nº: ${Dados.vacaVac[1]}",
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ]),
                )
              ])),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Color(0xffAAC7C4),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(12),
                width: double.infinity,
                child: Column(children: [
                  Text(
                    "Relatorio de partos",
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ])),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: crias.length,
                  itemBuilder: (context, index) {
                    final Cria c = crias[index];
                    return Container(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffAAC7C4),
                            ),
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(12),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  "${index+1}° parto",
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Quantidade que nasceu: ${c.quantiaNasceu}",
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Inseminada: ${c.dataInse}",
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Parto: ${c.dataParto}",
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.black,
                                  width: double.infinity,
                                  height: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.edit_note_sharp,
                                          size: 30, color: Color(0xFF000000)),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        exibirTelaConf(c);
                                      },
                                      icon: Icon(Icons.delete,
                                          size: 25, color: Color(0xFFE34D43)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ])));
                  }),
            ),
          ],
        ));
  }
  void exibirTelaConf(Cria c) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir vaca"),
            content: Text("Tem certeza que deseja excluir essa vaca?"),
            backgroundColor: Colors.white,
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () {
                   

                    Navigator.pop(context);
                  },
                  child: Text("Sim"))
            ],
          );
        });
  }
  AjudaVaca _db = AjudaVaca();

}
