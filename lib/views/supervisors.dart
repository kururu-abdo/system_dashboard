import 'package:dashboard/main.dart';
import 'package:dashboard/models/supervisor.dart';
import 'package:dashboard/service/main_provider.dart';
import 'package:dashboard/views/add_teacher.dart';
import 'package:dashboard/views/edit_password.dart';
import 'package:dashboard/views/search_student.dart';
import 'package:dashboard/views/teachers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';

class Supervisors extends StatefulWidget {
  const Supervisors({Key key}) : super(key: key);

  @override
  _SupervisorsState createState() => _SupervisorsState();
}

class _SupervisorsState extends State<Supervisors> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
final SearchStudent _delegate = SearchStudent();
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("المشرفين"),  centerTitle: true,),
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
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<List<Supervisor>>(
          stream: mainProvider.getSupervisors(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Supervisor>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: ListTile(
                      title: Text(snapshot.data[index].name),
                      trailing: Container(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
    

    // Create button
                                  Widget okButton = FlatButton(
                                    child: Text("OK"),
                                    onPressed: () async {

                                  var future = await showLoadingDialog(
                                          tapDismiss: false);

                                      await mainProvider.deleteSupervisor(
                                          snapshot.data[index].id);

                                      future.dismiss();
                                       Navigator.of(context).pop();
                                      setState(() {
                                        
                                      });


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
                                onPressed: ()  async{

Navigator.of(context).push(

  MaterialPageRoute(builder: (_){
    return EditPassword();
  } ,   
  settings: RouteSettings(arguments: {"type":"supervisor" ,  "id": snapshot.data[index].id
                                        })
  
  ) );





                                }
                                
                                
                                
                                , icon: Icon(Icons.edit)),
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

   
  }
}
