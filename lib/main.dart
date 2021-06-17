import 'dart:async';
import 'dart:html';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/dept.dart';
import 'package:dashboard/models/stats.dart';
import 'package:dashboard/models/supervisor.dart';
import 'package:dashboard/service/API.dart';
import 'package:dashboard/service/main_provider.dart';
import 'package:dashboard/utility/libs/pichart/legend_options.dart';
import 'package:dashboard/utility/libs/pichart/options.dart';
import 'package:dashboard/utility/libs/pichart/pi_chart.dart';
import 'package:dashboard/views/add_teacher.dart';
import 'package:dashboard/views/supervisors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dashboard/views/gender.dart';
import 'package:dashboard/views/input_field.dart';
import 'package:dashboard/views/membership.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';

void main() async {
  // await Firebase.initializeApp();

  await GetStorage.init();
  runApp(LoadingProvider(
      themeData: LoadingThemeData(),
      loadingWidgetBuilder: (ctx, data) {
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: Container(
              child: CircularProgressIndicator(),
              color: Colors.blue,
            ),
          ),
        );
      },
      child: MultiProvider(
          providers: [ChangeNotifierProvider.value(value: MainProvider())],
          child: MyApp())));
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      var isLogged = await GetStorage().read('logged');
      var logged = isLogged ?? false;

      if (logged) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("waiting"),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                    elevation: 1.0,
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.green[900],
                              size: 100,
                            ),

                            _logoText(),
                            _inputField(
                                phoneController,
                                Icon(Icons.person_outline,
                                    size: 30, color: Color(0xffA6B0BD)),
                                "Phone",
                                false),
                            _inputField(
                                passwordController,
                                Icon(Icons.lock_outline,
                                    size: 30, color: Color(0xffA6B0BD)),
                                "Password",
                                true),
                            !isLoading
                                ? _loginBtn(context)
                                : CircularProgressIndicator(),
                            // _dontHaveAcnt(),
                            // _signUp(),
                            // _terms(),
                          ],
                        ))),
              ),
              Container(
                child: Center(
                  child: Image.asset(
                    'assets/images/karari.png',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _terms() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 18),
      child: FlatButton(
        onPressed: () => {print("Terms pressed.")},
        child: Text(
          "Terms & Conditions",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Color(0xffA6B0BD),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUp() {
    return FlatButton(
      onPressed: () {
        setState(() {
          isLoading = true;
        });
      },
      child: Text(
        "SIGN UP NOW",
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Color(0xFF008FFF),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _loginBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20, bottom: 50),
      decoration: BoxDecoration(
          color: Colors.green[900],
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Color(0x60008FFF),
              blurRadius: 10,
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
          ]),
      child: FlatButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              isLoading = true;
            });
            var user = Provider.of<MainProvider>(context, listen: false)
                .logUser(
                    context, phoneController.text, passwordController.text);

            setState(() {
              isLoading = false;
            });
          }
        },
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Text(
          "دخول",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoText() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Text(
        "تسجيل الدخول",
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.w800,
            color: Color(0xff000912),
            letterSpacing: 10,
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
              left: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff00bfdb),
                ),
              )),
          Positioned(
              child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff008FFF),
            ),
          )),
          Positioned(
            left: 50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff00227E),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController controller, Icon prefixIcon,
      String hintText, bool isPassword) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff000912),
          ),
        ),
        validator: (str) {
          if (str == null || str == "") {
            return "هذا الحقل مطلوب";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 25),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(
            minWidth: 75,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _dontHaveAcnt() {
    return Text(
      "Don't have an account?",
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          color: Color(0xffA6B0BD),
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        locale: Locale("ar", ""),
        localizationsDelegates: [],
        theme: ThemeData(
          primaryColor: Colors.green ,
          accentColor: Colors.greenAccent ,
         
        ),
        routes: {Home.id: (context) => Home()},
        debugShowCheckedModeBanner: false,
        
        home: Directionality(
            textDirection: TextDirection.rtl,
            child:
                WelcomeScreen()) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class Home extends StatefulWidget {
  static const String id = "/home";
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Department> depts = [];
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  @override
  void initState() {
    super.initState();
    API.getDepts().then((value) {
      setState(() {
        depts = value;
      });
    });
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              height: 250,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                ),
                items: [
                  'assets/images/slide1.webp',
                  'assets/images/slide2.webp',
                  'assets/images/slide3.webp',
                  'assets/images/slide4.webp',
                  'assets/images/slide5.jpeg'
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        // width: MediaQuery.of(context).size.width,
                        // margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(i), fit: BoxFit.cover)),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: FutureBuilder<Map<String, int>>(
                      future: Provider.of<MainProvider>(context, listen: false)
                          .getStats(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, int>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          List<Satitics> stats_list = [];
                          snapshot.data.forEach(
                              (k, v) => stats_list.add(Satitics(k, v)));
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Card(
                                elevation: 8.0,
                                child: ListView(
                                    children: stats_list
                                        .map(
                                          (e) => ListTile(
                                              title: Text(e.name),
                                              trailing:
                                                  Text(e.count.toString())),
                                        )
                                        .toList())),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: FutureBuilder<Map<String, double>>(
                        future:
                            Provider.of<MainProvider>(context, listen: false)
                                .getStatsForStudents(depts),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, double>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData || !snapshot.hasError) {
                              return Card(
                                elevation: 8.0,
                                child: Center(
                                  child: PieChart(
                                    dataMap: snapshot.data,
                                    animationDuration:
                                        Duration(milliseconds: 100),
                                    chartLegendSpacing: 32,
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 3.2,
                                    // colorList: colorList,

                                    initialAngleInDegree: 0,
                                    chartType: ChartType.ring,
                                    ringStrokeWidth: 32,
                                    centerText: "الاقسام",
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.left,
                                      showLegends: true,
                                      legendShape: BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: false,
                                      showChartValuesOutside: false,
                                      decimalPlaces: 1,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddSupervisor extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _AddSupervisorState();
  }
}

class _AddSupervisorState extends State<AddSupervisor> {
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


  //   Future<bool> usernameCheck() async {
  //   final result = await FirebaseFirestore.instance
  //       .collection('سعحثق')
  //       .where('id_number', isEqualTo: id_number)
  //       .get();
  //   return result.docs.isEmpty;
  // }

// addSuperVisor(BuildContext context){
//   CollectionReference student =
//         FirebaseFirestore.instance.collection('student');

//     if (this.semester != null && this.level != null && this.dept != null) {
//       student.doc(this.id_number).set({
//         'name': this.first_name, // John Doe
//         'dept': this.dept.toJson(), // Stokes and Sons
//         'level': this.level.toJson(),
//         'semester': this.semester.toJson(),
//         "password": this.password,
//         "id_number": this.id_number,

//         // 42
//       }).then((value) {
// }



  void initState() {
    super.initState();
    API.getDepts().then((value) {
      setState(() {
        depts = value;
      });
    });
  }

bool isLoading =  false;
var _scaffoldKey =  GlobalKey<ScaffoldState>();
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



                Get.to(AddTeacher());
              },
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
                              "إضافة مشرف",
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
child: 
 DropdownButtonFormField<Department>(
                        validator: (value) {
                          if (value == null) {
                            return "هذا الحخقل مطلوب";
                          } else
                            return null;
                        },
                        hint: Text(" القسم"),
                        value: dept,
                        onChanged: (Department Value) {
                          setState(() {
                            dept = Value;
                          });
                        },
                        items: depts.map((Department Value) {
                          return DropdownMenuItem<Department>(
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
                        height: 40.0,
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

mainProvider.addSupervisor(new Supervisor(
name: nameController.text ,
address: addressController.text ,
password: passwordController.text ,
dept:  dept ,
phone: phoneController.text


)).then((value) {


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
      ),
    );
  }
}
