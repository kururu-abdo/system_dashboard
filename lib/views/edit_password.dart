import 'package:dashboard/main.dart';
import 'package:dashboard/service/main_provider.dart';
import 'package:dashboard/utility/toastNotification.dart';
import 'package:dashboard/views/add_teacher.dart';
import 'package:dashboard/views/search_student.dart';
import 'package:dashboard/views/supervisors.dart';
import 'package:dashboard/views/teachers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({ Key key }) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {

TextEditingController passwordController =  new TextEditingController();
   var _scaffoldKey = new GlobalKey<ScaffoldState>();
   var   _formKey  =  GlobalKey<FormState>();

   final SearchStudent _delegate = SearchStudent();
  @override
  Widget build(BuildContext context) {
 var mainProvider = Provider.of<MainProvider>(context);


    var data =   ModalRoute.of(context).settings.arguments as Map;

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
          'لوحة التحكم',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
body: Center(
  child: Form(
    key: _formKey,
    child: Column(
      children: [
        Padding(  
                        padding: EdgeInsets.all(50),  
                        child: TextFormField( 
                          controller: passwordController, 
                          decoration: InputDecoration(  
                            border: OutlineInputBorder(),  
                            labelText: 'كلمة السر',  
                            hintText: 'كلمة السر الجديدة',  
  
                          
                          ),
  
                          validator: (str){
                            if (str.length <=0 || str==null) {
                              return "هذا الحقل مطلوب"  ;
                            }
  
                            return null;
                          },  
                        ),  
                      ),
  
  
  
                        InkWell(
                onTap: ()   async{
  
  
  if (data['type']=="teacher") {

     if(_formKey.currentState.validate()){
    var id =  data['id'];
          var future = await showLoadingDialog(tapDismiss: false);

  await mainProvider.updateTeacher(id, passwordController.text);
  
  ToastNotification.showSuccessToast("تم تحديث كلمة السر بنجاح", context);
  future.dismiss();
  
     }  
  
  }  else if (data['type']=="supervisor"){
    if(_formKey.currentState.validate()){
      var future = await showLoadingDialog(tapDismiss: false);
  var id = data['id'];
                      await mainProvider.updateSupervisor(
                          id, passwordController.text);

                      ToastNotification.showSuccessToast(
                          "تم تحديث كلمة السر بنجاح", context);

                          future.dismiss();
    }

  
  
  }
  else{
  var id = data['id'];  
      var future = await showLoadingDialog(tapDismiss: false);

 await mainProvider.updateStudent(
                        id, passwordController.text);

                    ToastNotification.showSuccessToast(
                        "تم تحديث كلمة السر بنجاح", context);

                    future.dismiss();

  }  
  
  
                },
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "تحديث كلمة السر",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
      ],
    ),
  ),
),
    );
  }
}



// settings: RouteSettings(
//                     arguments: tasks[index],
//                   ),