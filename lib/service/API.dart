import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/dept.dart';
import 'package:flutter/material.dart';

class API {

  static  Future<List<Department>> getDepts ()  async{
  QuerySnapshot data = await FirebaseFirestore.instance
        .collection('depts')
        
        .get();

        List<Department>  depts =[];
        if (data.docs.length>0) {
          depts =   data.docs.map((e) => Department.fromJson(e.data())).toList();
 debugPrint('/////////////////');
        }

        return  depts;
  }
}