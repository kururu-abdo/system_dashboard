import 'dart:convert';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/dept.dart';
import 'package:dashboard/models/level.dart';
import 'package:dashboard/models/semester.dart';
import 'package:dashboard/models/student.dart';
import 'package:dashboard/models/subject.dart';
import 'package:dashboard/models/supervisor.dart';
import 'package:dashboard/models/teacher.dart';
import 'package:dashboard/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';


class MainProvider  extends ChangeNotifier {
  Stream<List<Teacher>> getTeachers() async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('teacher')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();
    List<Teacher> teachers =
        data.docs.map((e) => Teacher.fromJson(e.data())).toList();

    teachers.forEach((element) {
      print(element.name);
    });

    yield teachers;
  }

  Future<List<QueryDocumentSnapshot>> getTimeTableOfDay(
      Map day, Department department, Level level, Semester semester) async {
    debugPrint('hit the spot');
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('table')
        .where('dept', isEqualTo: department.toJson())
        .where('level', isEqualTo: level.toJson())
        .where('semester', isEqualTo: semester.toJson())
        .where('day', isEqualTo: day)
        .get();
    return data.docs;
  }

  Future<void> deletTimeOfDay(Map sub) async {
    debugPrint('hit the spot');
    CollectionReference data =
        await FirebaseFirestore.instance.collection('table');

    var selectedSubject = await data.where('id', isEqualTo: sub['id']).get();
    var doc_id = selectedSubject.docs.first.id;
    await data.doc(doc_id).delete();
  }

  Future<List<ClassSubject>> getAllSubject(
      Department department, Semester semester, Level level) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('subject')
        .where('dept', isEqualTo: department.toJson())
        .where('level', isEqualTo: level.toJson())
        .where('semester', isEqualTo: semester.toJson())
        .get();
    debugPrint(department.toJson().toString());
    List<ClassSubject> subjects =
        data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();
    subjects.forEach((element) {
      debugPrint(element?.name);
    });

    return subjects;
  }

  Stream<List<ClassSubject>> getSubjects() async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('subject')
        // .where('level' , isEqualTo: level.toJson())
        // .where('dept', isEqualTo: department.toJson())
        // .where('semester', isEqualTo: department.toJson())

        .get();
    List<ClassSubject> subjects =
        data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();

    subjects.forEach((element) {
      print(element.name);
    });

    yield subjects;
  }
   Future<Admin> logUser(
     BuildContext context ,
     
     String phone ,  String password) async{
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .where('password', isEqualTo: password)
        .get();  
Admin   admin;

  if(data.docs.length>0){
   admin =  Admin.fromJson(data.docs.first.data());

 await  GetStorage().write('user', json.encode(data.docs.first.data()));
  await   GetStorage().write('logged', true);

Navigator.of(context).pushReplacementNamed('/home');
   return admin;
  }else{

Get.defaultDialog(title: "فشل"  ,  content: Text("يرجى التأكد من رقم  الهاتف و كلمة السر"));


  }


   }

  Stream<List<Department>> getDepartments() async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('depts')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();
    List<Department> depts =
        data.docs.map((e) => Department.fromJson(e.data())).toList();

    depts.forEach((element) {
      print(element.name);
    });

    yield depts;
  }

  
  Stream<List<Supervisor>> getSupervisors() async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('supervisor')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();
    List<Supervisor> depts =
        data.docs.map((e) => Supervisor.fromJson(e.data())).toList();

    depts.forEach((element) {
      print(element.name);
    });

    yield depts;
  }

  Stream<List<Level>> getLevels() async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('level')
        // .where('dept', isEqualTo: department.toJson())
        .orderBy('id', descending: false)
        .get();
    List<Level> lvls = data.docs.map((e) => Level.fromJson(e.data())).toList();

    lvls.forEach((element) {
      print(element.name);
    });

    yield lvls;
  }
Future<void>  addSupervisor(Supervisor supervisor)  async{

    CollectionReference ref =
        await FirebaseFirestore.instance.collection('supervisor');
    var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
  var available =   await checkifSuperVisorAvilable(supervisor.phone);
   
    if(available){
 await ref.add({
        'id': uuid.v1(),
        'name': supervisor.name,
        'password': supervisor.password,
        'phone': supervisor.phone,
        'dept': supervisor.dept.toJson(),
        'address': supervisor.address,
      }).then((value) {
        Get.defaultDialog(title: 'تم', content: Text('تمت إضافة المشرف بنجاح'));
      }).catchError((onError) =>
          Get.defaultDialog(title: 'ERROR', content: Text(onError.toString())));
    }else{
       Get.defaultDialog(title: 'ERROR', content: Text("رقم الهاتف مستخدم من قبل مشرف اخر"));
    }
   


}

Future<bool> checkifSuperVisorAvilable(String phone) async {
    final result = await FirebaseFirestore.instance
        .collection('supervisor')
        .where('phone', isEqualTo: phone)
        .get();
    return result.docs.isEmpty;
  }


Future<bool> checkiTeacherAvilable(String phone) async {
    final result = await FirebaseFirestore.instance
        .collection('teacher')
        .where('phone', isEqualTo: phone)
        .get();
    return result.docs.isEmpty;
  }


Future<  Map<String, int>>   getStats() async{
  QuerySnapshot studetns = await FirebaseFirestore.instance
          .collection('student')
          .get();
QuerySnapshot teachers =
        await FirebaseFirestore.instance.collection('teacher').get();
        QuerySnapshot supervisors =
        await FirebaseFirestore.instance.collection('supervisor').get();
         QuerySnapshot depts =
        await FirebaseFirestore.instance.collection('depts').get();

        Map<String, int>  data =  new Map<String, int>();

        data["الطلاب"] =  studetns.docs.length;


        data["المشرفين"]   =   supervisors.docs.length;
        data['الاقسام']   =  depts.docs.length;
        data['الاساتذة'] =   teachers.docs.length;



        return data;


}
Future<  Map<String, double>>  getStatsForStudents (List<Department> depts) async{

Map<String, double> stats = Map<String, double>();
  for (var dept in depts)  {
    QuerySnapshot data = await FirebaseFirestore.instance
          .collection('student')
          .where('dept', isEqualTo: dept.toJson())
          .get();
      if (data.docs.length > 0) {
        stats[dept.name] = data.docs.length.toDouble();
      } else {
        stats[dept.name] = 0.toDouble();
      }
  }




return stats;
}
double reciprocal(double d) => 1 / d;

Future<Student>  getStudentById(int id ,  Department  dept) async {
  try {
    QuerySnapshot data = await FirebaseFirestore.instance
          .collection('student')
          .where('id_number', isEqualTo: id.toString())
          .where('dept'  , isEqualTo: dept.toJson())
          .get();

if (data.docs.length>0) {
  Student student =  Student.fromJson(data.docs.first.data());
  return  student;
}

  return  null;


  } on SocketException{
    return null;
  }
}
  Stream<List<Student>> getStudens(Department  department) async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('student')
        .where('dept', isEqualTo: department.toJson())
        .get();
    List<Student> stds =
        data.docs.map((e) => Student.fromJson(e.data())).toList();

    stds.forEach((element) {
      print(element.name);
    });

    yield stds;
  }

  Future<void> addTeacher(Map<dynamic, dynamic> data) async {
    
    CollectionReference ref =
        await FirebaseFirestore.instance.collection('teacher');
    var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
var available =await  checkiTeacherAvilable( data['phone']);
if (available) {
   await ref.add({
        'id': uuid.v1(),
        'name': data['name'],
        'password': data['password'],
        'phone': data['phone'],
        'degree': data['degree'],
        'semester': data['semester'],
        'address': data['address'],
        'role': 'أستاذ'
      }).then((value) {
        Get.defaultDialog(
            title: 'تم', content: Text('تمت إضافة الاستاذ بنجاح'));

      }).catchError((onError) =>
          Get.defaultDialog(title: 'ERROR', content: Text(onError.toString())));
}else{
   Get.defaultDialog(title: 'ERROR', content: Text("رقم الهاتف مستخدم من قبل استاذ اخر"));
}

   

   
  }

  Future<void> updateTeacher(Teacher teacher) async {
    var future = await showLoadingDialog();

    CollectionReference data =
        await FirebaseFirestore.instance.collection('teacher');

    var selectedEvent = await data.where('id', isEqualTo: teacher.id).get();
    var doc_id = selectedEvent.docs.first.id;
    await data.doc(doc_id).update({
      'name': teacher.name,
      'phone': teacher.phone,
      'degree': teacher.degree,
      'semester': teacher.semester.toJson(),
      'address': teacher.address,
      'role': 'أستاذ'
    });

    future.dismiss();
  }












//   Future<APIresponse<Supervisor>> getSuperVisorData(
//       String number, String password) async {
//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('supervisor')
//           .where('phone', isEqualTo: number)
//           .where('password', isEqualTo: password)
//           .get();

//       if (data.docs.length > 0) {
//         debugPrint(json.encode(data.docs.first.data()));

//         getStorage.write('admin', json.encode(data.docs.first.data()));

//         Supervisor supervisor = Supervisor.fromJson(data.docs.first.data());
//         getStorage.write('isLogged', true);

//         return APIresponse<Supervisor>(data: supervisor);
//       }
//     } on SocketException {
//       return APIresponse<Supervisor>(
//           error: true,
//           errorMessage: 'مشكلة في الاتصال بالانترنت نرجو المحاولة لاحقا');
//     }
//   }

//   Future<bool> login(String number, String password) async {
//     var future = await showLoadingDialog();
//     var data = await FirebaseFirestore.instance
//         .collection('supervisor')
//         .where('phone', isEqualTo: number)
//         .where('password', isEqualTo: password)
//         .get();

//     if (data.docs.length > 0) {
//       debugPrint(json.encode(data.docs.first.data()));

//       getStorage.write('admin', json.encode(data.docs.first.data()));

//       getStorage.write('isLogged', true);

//       Get.to(HomePage());
//       future.dismiss();
//       return true;
//     } else {
//       future.dismiss();
//       Get.defaultDialog(
//           title: 'خطأ في التسجيل',
//           content: Text(
//               'تأكد من كلمة السر أو رقم الهاتف   و في حالة عدم تذكر شي يرجى الاتصال بالمطورين '),
//           actions: [
//             RaisedButton(
//                 color: AppColors.primaryVariantColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.horizontal(
//                         left: Radius.circular(20), right: Radius.circular(20))),
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: Text('ok')),
//           ]);
//     }
//     return false;
//   }

//   Future<APIresponse<List<ClassSubject>>> getDeptSubjects(Dept dept) async {
//     try {
//       QuerySnapshot data = await FirebaseFirestore.instance
//           .collection('subject')
//           .where('dept', isEqualTo: dept.toJson())
          
        
//           .get();
          
//           if (data.docs.length>0) {
          


//           try {
//                List<ClassSubject> subjects =
//               data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();
         
//           return APIresponse<List<ClassSubject>>(data: subjects);
//           } catch (e) {
//             debugPrint('/////////////');
//             debugPrint(e.toString());
//           }
//           }
//              return APIresponse<List<ClassSubject>>(data: []);

//     } on SocketException {
//       return APIresponse<List<ClassSubject>>(error: true  ,  errorMessage: "مشكلة في الاتصال الرجاء المحاولة لاحقا");
//     }
//   }

//   Future<APIresponse<List<Level>>> getAllevels() async {
//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('level')
//           .orderBy('id', descending: false)
//           .get();

//       if (data.docs.length > 0) {
//         List<Level> levels =
//             data.docs.map((level) => Level.fromJson(level.data())).toList();

//         return APIresponse<List<Level>>(data: levels);
//       }

//       return APIresponse<List<Level>>(data: []);
//     } on SocketException {
//       return APIresponse<List<Level>>(
//           error: true,
//           errorMessage: 'مشكلة في الاتصال بالانترنت نرجو المحاولة لاحقا');
//     }
//   }

//   List<Map> getDays() {
//     return DAYS;
//   }

//   Future<APIresponse<List<Semester>>> getSemesters() async {
//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('semester')
//           .orderBy('id', descending: false)
//           .get();

//       if (data.docs.length > 0) {
//         List<Semester> semesters =
//             data.docs.map((sem) => Semester.fromJson(sem.data())).toList();

//         return APIresponse<List<Semester>>(data: semesters);
//       } else {
//         return APIresponse<List<Semester>>(data: []);
//       }
//     } on SocketException {
//       return APIresponse<List<Semester>>(
//           error: true,
//           errorMessage: 'مشكلة في الاتصال بالانترنت نرجو المحاولة لاحقا');
//     }
//   }






// Future<APIresponse<List<Student>>> getLevelStudents(Level level ,  Dept dept )async{
//  QuerySnapshot data = await FirebaseFirestore.instance
//         .collection('student')
//         .where('dept', isEqualTo: dept.toJson())
//         .where('level', isEqualTo: level.toJson())
//         .get();


//          try {
     

//       if (data.docs.length > 0) {
//         List<Student> students = data.docs.map((e) => Student.fromJson(e.data())).toList();
//         return APIresponse<List<Student>>(data: students);
//       }

//       return APIresponse<List<Student>>(data: []);
//     } on SocketException {
//       return APIresponse<List<Student>>(
//           error: true,
//           errorMessage: 'مشكلة في الاتصال  , الرجاء المحاولة لاحق');
//     }
// }
// Future<APIresponse<List<Student>>> getDeptStudents(Dept dept) async {

//  QuerySnapshot data = await FirebaseFirestore.instance
//         .collection('student')
//         .where('dept', isEqualTo: dept.toJson())
//         .get();
//    try {
//       if (data.docs.length > 0) {
//         List<Student> students =
//             data.docs.map((e) => Student.fromJson(e.data())).toList();
//         return APIresponse<List<Student>>(data: students);
//       }

//       return APIresponse<List<Student>>(data: [null]);
//     } on SocketException {
//       return APIresponse<List<Student>>(
//           error: true,
//           errorMessage: 'مشكلة في الاتصال  , الرجاء المحاولة لاحق');
//     }
// }
  Admin getAdmin() {
    Admin admin = Admin.fromJson(json.decode(GetStorage().read('user')));

    return admin;
  }
}
