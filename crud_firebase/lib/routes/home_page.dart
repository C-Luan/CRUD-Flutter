import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home';

  @override
  Widget build(BuildContext context) {
    var snapshot = Firestore.instance
        .collection('todo')
        .where('exluido', isEqualTo: false)
        .orderBy("data")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Comunicação interna da Ordem", textAlign: TextAlign.center),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(

          /*
        Stream fica escutando os snapshots, e toda modificação que ocorrer dentro do firebase,
        ele vai atualizar os snapshots
        */
          stream: snapshot,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data.documents.length == 0) {
              return Center(child: Text('Nem uma tarefa cadastrada'));
            }

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int i) {
                var doc = snapshot.data.documents[i];
                var item = doc.data;

                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      isThreeLine: true,
                      leading: IconButton(
                          icon: Icon(
                              item['feito']
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: Colors.green),
                          onPressed: () => doc.reference
                              .updateData({'feito': !item['feito']})),
                      title: Text(
                        item['titulo'],
                      ),
                      subtitle: Text(item['descrição']),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.red[300],
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () => {
                                  Firestore.instance
                                      .collection('todo')
                                      .document(doc.documentID)
                                      .delete()
                                }),
                      ),
                    ));
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalcriate(context),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.add),
      ),
    );
  }

  modalcriate(BuildContext context) {
    GlobalKey<FormState> form = GlobalKey<FormState>();

    var titulo = TextEditingController();
    var descricao = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('To do List'),
            content: Form(
                key: form,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Título'),
                      TextFormField(
                        controller: titulo,
                        decoration: InputDecoration(
                          hintText: 'Ex. Dominar o mundo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo não pode estar vazio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 1),
                      Text('Descrição'),
                      TextFormField(
                        controller: descricao,
                        decoration: InputDecoration(
                          hintText:
                              'Ex. Começar a aprender flutter para obter dados de uso',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo não pode estar vazio';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
                color: Colors.red[300],
              ),
              FlatButton(
                  onPressed: () async {
                    if (form.currentState.validate()) {
                      await Firestore.instance.collection('todo').add({
                        'titulo': titulo.text,
                        'descrição': descricao.text,
                        'feito': false,
                        'data': Timestamp.now(),
                        'exluido': false,
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Salvar'),
                  textColor: Colors.white,
                  color: Colors.blue[400])
            ],
          );
        });
  }
}
