import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {
  runApp(
      MaterialApp(
         debugShowCheckedModeBanner: false,
         home: ToDoFirebase(),
         theme: ThemeData(
           primaryColor: Colors.red,
           accentColor: Colors.lime,
           brightness: Brightness.dark,
         ),
  ));
}

class ToDoFirebase extends StatefulWidget {

  @override
  State<ToDoFirebase> createState() => _ToDoFirebaseState();
}

class _ToDoFirebaseState extends State<ToDoFirebase> {

  List list = [];
  String input = "";
  @override
  void initState(){
    super.initState();
    list.add("nr.1");
    list.add("nr.2");
    list.add("nr.3");
  }
  createData(){
    DocumentReference documentReference =FirebaseFirestore.instance.collection("ToDos").doc(input);
    Map<String,String> data =
    {
      "todo" : input ,
    };
    documentReference.set(data).whenComplete(() {
      print("$input created");
    }
      );
    }

  deleteData(item){
    DocumentReference documentReference =FirebaseFirestore.instance.collection("ToDos").doc(item);
    documentReference.delete().whenComplete(() {
      print("$item deleted");
    }
    );
  }
  // bool checkInput = false ;
  // int gender = 1 ;
  // printData(String input){
  //   print(input);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDos", textDirection: TextDirection.ltr,),
        // actions: [
        //   IconButton(
        //       onPressed: (){
        //         print("icon");
        //         },
        //       icon: Icon(Icons.beenhere),
        //   ),
        //   IconButton(
        //       onPressed: (){
        //         print("icon");
        //         },
        //       icon: Icon(Icons.map),
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
                context: context,
                builder: (context){
                    return AlertDialog(
                      title: Text("Add Todo"),
                      content: TextFormField(
                        onChanged: (String value){
                          input =value ;
                        },
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: (){
                              createData();
                              Navigator.pop(context);
                        },
                            child: Text("Add"))
                      ],
                    );
                }
            );
          },
          child: Icon(Icons.add),
      ),
      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       Stack(
      //         children: [
      //           Image(image: AssetImage("")),
      //           Padding(
      //               padding: EdgeInsets.only(top: 30 ,left: 16),
      //               child: CircleAvatar(
      //                 radius: 40,
      //                 backgroundImage: AssetImage(""),
      //               ),
      //           ),
      //
      //         ],
      //       )
      //     ],
      //   ),
      // ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("ToDos").snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                shrinkWrap: true,
                itemCount:snapshot.data?.docs.length,
                itemBuilder: (BuildContext context,index){
                  DocumentSnapshot ds =snapshot.data.docs[index];
                  return Dismissible(
                    key: Key(index.toString()),
                    child: ListTile(
                      title: Text(ds["todo"]),
                    ),
                    onDismissed: (direction){
                      deleteData(ds["todo"]);
                    },
                  );
                },
              );
            }else
              {
                return Align(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator(),
                );
              }
          }
      ),
    );
  }
}
