import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/main.dart';
import 'package:dashboard/models/dept.dart';
import 'package:dashboard/models/semester.dart';
import 'package:dashboard/models/supervisor.dart';
import 'package:dashboard/service/API.dart';
import 'package:dashboard/service/main_provider.dart';
import 'package:dashboard/views/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({ Key key }) : super(key: key);

  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
 TextEditingController nameController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  List<Department> depts = [];
  String passwordValidation(String str) {
    if (str.length < 6 || str.length <= 0) {
      return "كلمة السر غير صالحة";
    }
    return null;
  }

  String addressValidation(String str) {
    if (str.length <= 0) {
      return "هذا الحقل مطلوب";
    }
    return null;
  }
List Degrees = ['محاضر', 'أستاذ مشارك', 'أستاذ مساعد', 'مساعد تدريس'];
  String Degree;
  String nameValidation(String str) {
    if (str.length <= 0) {
      return "هذا الحقل مطلوب";
    }
    return null;
  }

  String phoneValidation(String str) {
    if ((str.startsWith("09") || str.startsWith("01"))) {
      return "رقم الهاتف غير صالح";
    } else if (str.length <= 0) {
      return "هذا الحقل مطلوب";
    }
    return null;
  }

  Department dept;
List<Semester> semesters = [];
  Semester semester;


bool isLoading = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  
  void initState() {
    super.initState();
    API.getDepts().then((value) {
      setState(() {
        depts = value;
      });
    });
    fetch_semeters();
  }

  fetch_semeters() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('semester')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();

    setState(() {
      semesters = data.docs.map((e) => Semester.fromJson(e.data())).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    
    var mainProvider =   Provider.of< MainProvider>(context);
     return Scaffold(
      backgroundColor: Colors.blue[50],
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
            GestureDetector(
              onTap: () {},
              child: Text(
                'اضافة استاذ',
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
            Text(
              'المشرفين',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 45,
            ),
            Text(
              'الاساتذة',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 45,
            ),
            Text(
              'بحث عن طالب',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
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
        // padding:
        //     EdgeInsets.only(top: 60.0, bottom: 60.0, left: 120.0, right: 120.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          elevation: 5.0,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3.3,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.green[600],
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 70.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.black87,
                              backgroundImage: AssetImage(
                                'assets/images/karari.png',
                              ),
                              radius: 70.0,
                            ),
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "إضافة أستاذ",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          //   child: Text(
                          //     "It should only take a couple of minutes to pair with your watch",
                          //     style: TextStyle(
                          //       fontSize: 18.0,
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                          SizedBox(
                            height: 50.0,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.black87,
                                child: Text(
                                  ">",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 40.0, right: 70.0, left: 70.0, bottom: 40.0),
                  child: Column(
                    children: <Widget>[
                      //InputField Widget from the widgets folder
                    
                      SizedBox(height: 20.0),
                      InputField(
                        label: "الاسم",
                        content: "الأسم",
                        controller: nameController,
                        validation: nameValidation,
                      ),
                      SizedBox(height: 20.0),

                      //InputField Widget from the widgets folder
                      InputField(
                        label: "العنوان",
                        content: "العنوان",
                        controller: addressController,
                        validation: addressValidation,
                      ),

                      SizedBox(height: 20.0),

                      InputField(
                        label: "الهاتف",
                        content: "الهاتف",
                        controller: phoneController,
                        validation: phoneValidation,
                      ),
  SizedBox(height: 20.0),
Container(
                          width: MediaQuery.of(context).size.width / 3.7,
                          height: 50,
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null) {
                                return "هذا الحقل مطلوب";
                              } else
                                return null;
                            },
                            hint: Text(" الدرجة"),
                            value: Degree,
                            onChanged: (String Value) {
                              setState(() {
                                Degree = Value;
                              });
                            },
                            items: Degrees.map(( Value) {
                              return DropdownMenuItem<String>(
                                value: Value,
                                child: Text(
                                  Value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),




                      SizedBox(height: 20.0),



  Container(
 width: MediaQuery.of(context).size.width / 3.7,
 height: 50,
child: 
 DropdownButtonFormField<Semester>(
                        validator: (value) {
                          if (value == null) {
                            return "هذا الحقل مطلوب";
                          } else
                            return null;
                        },
                        hint: Text(" السمستر"),
                        value: semester,
                        onChanged: (Semester Value) {
                          setState(() {
                            semester = Value;
                          });
                        },
                        items: semesters.map((Semester Value) {
                          return DropdownMenuItem<Semester>(
                            value: Value,
                            child: Text(
                              Value.name,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),



  ) ,
                      SizedBox(height: 20.0),
                      InputField(
                        label: "كلمة السر",
                        content: "كلمة  السر",
                        controller: passwordController,
                        validation: passwordValidation,
                      ),

                      SizedBox(
                        height: 20.0,
                      ),

        !isLoading?              Row(
                        children: <Widget>[
                          SizedBox(
                            width: 170.0,
                          ),
                          FlatButton(
                            color: Colors.grey[200],
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("إلغاء"),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          FlatButton(
                            color: Colors.greenAccent,
                            onPressed: ()  async{
setState(() {
  isLoading =  true;
});
var map ={

  
        'name': nameController.text,
        'password': passwordController.text,
        'phone': phoneController.text,
        'degree': Degree,
        'semester': semester.toJson(),
        'address':addressController.text,
};
mainProvider.addTeacher(map).then((value) {


setState(() {
                                        isLoading = false;
                                      });

});





                            },
                            child: Text(
                              "إضافة",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                   
                   : CircularProgressIndicator()
                   
                   
                   
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
  }
}