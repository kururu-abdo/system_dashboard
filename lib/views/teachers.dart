import 'package:dashboard/main.dart';
import 'package:dashboard/models/supervisor.dart';
import 'package:dashboard/models/teacher.dart';
import 'package:dashboard/service/main_provider.dart';
import 'package:dashboard/views/add_teacher.dart';
import 'package:dashboard/views/edit_password.dart';
import 'package:dashboard/views/search_student.dart';
import 'package:dashboard/views/supervisors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';

class Teachers extends StatefulWidget {
  const Teachers({Key key}) : super(key: key);

  @override
  _SupervisorsState createState() => _SupervisorsState();
}

class _SupervisorsState extends State<Teachers> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
final SearchStudent _delegate = SearchStudent();
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
       
      key: _scaffoldKey,
       endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            DrawerHeader(
              child: Container(
                  height: 142,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/karari.png",
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddSupervisor());

                //    Navigator.of(context).pop();
              },
              child: Text(
                'إضافة مشرف',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddTeacher());

                //    Navigator.of(context).pop();
              },
              child: Text(
                'إضافة استاذ',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () {
                Get.to(() => Supervisors());

                //    Navigator.of(context).pop();
              },
              child: Text(
                'المشرفين',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () {
                Get.to(() => Teachers());
              },
              child: Text(
                'الاساتذة',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () async {
//SearchStudent

                await showSearch(
                  context: context,
                  delegate: _delegate,
                );
              },
              child: Text(
                'بحث عن طالب',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 65,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Center(
                  child: Text(
                    'v1.0.1',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 20,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
      appBar: new GFAppBar(
//          leading  :  new  IconButton(onPressed: (){

// _scaffoldKey.currentState.openEndDrawer();
//          }, icon: Icon(Icons.menu)) ,

        elevation: 0.0,
        title: Text(
          'الأساتذة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<List<Teacher>>(
          stream: mainProvider.getTeachers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Teacher>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8.0,
                    child: ListTile(
                      title: Text(snapshot.data[index].name),
                      trailing: Container(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: ()async {

    

    // Create button
                                  Widget okButton = FlatButton(
                                    child: Text("OK"),
                                    onPressed: () async {



                                      var future = await showLoadingDialog();

                                      await mainProvider.deleteTeacher(
                                          snapshot.data[index].id);

                                      future.dismiss();

 Navigator.of(context).pop();

                                        setState(() {});


                                    },
                                  );
                                  Widget cancelButton = FlatButton(
                                    child: Text("cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  // Create AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Delete"),
                                    content: Text("تأكيد عملية الحذف"),
                                    actions: [okButton, cancelButton],
                                  );

                                  // show the dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                }, icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () async{

Navigator.of(context).push(

  MaterialPageRoute(builder: (_){
    return EditPassword();
  } ,   
  settings: RouteSettings(arguments: {"type":"teacher" ,  "id": snapshot.data[index].id
                                        })
  
  ) ,

);


                                }, icon: Icon(Icons.edit)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }


    showAlertDialog(BuildContext context) {

        var mainProvider = Provider.of<MainProvider>(context);

    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: ()   async{
      
      },
    );
 Widget cancelButton = FlatButton(
      child: Text("cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("تأكيد عملية الحذف"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
