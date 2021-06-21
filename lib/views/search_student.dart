import 'dart:ui';

import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/student.dart';
import 'package:dashboard/service/main_provider.dart';
import 'package:dashboard/views/edit_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchStudent extends SearchDelegate<Student> {
  SearchStudent() : super(keyboardType: TextInputType.number);

  Student student;
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);
    var id = int.parse(query);

    return Center(
      child: FutureBuilder<APIresponse<Student>>(
        future: provider.getStudentById(id),
        builder: (BuildContext context,
            AsyncSnapshot<APIresponse<Student>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _ResultCard(student: snapshot.data.data);
            }
            return Text('لم يتم العثور على هذا الطالب');
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class _ResultCard extends StatelessWidget {
  _ResultCard({this.student, this.searchDelegate});
  final Student student;
  final SearchDelegate<Student> searchDelegate;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {

        Navigator.of(context).push(

  MaterialPageRoute(builder: (_){
    return EditPassword();
  } ,   
  settings: RouteSettings(arguments: {"type":"student" ,  "id": this.student.id_number
                                        })
  
  ));


      },
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        margin: EdgeInsets.all(20.0),
        child: Card(
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          elevation: 16.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  student?.name ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  '${student?.level?.name ?? ""}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'ar';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(const CustomLocalization());

  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;

  @override
  String toString() => 'CustomLocalization.delegate(en_US)';
}

class CustomLocalization extends DefaultMaterialLocalizations {
  const CustomLocalization();

  @override
  String get searchFieldLabel => "رقم الجلوس";
}
