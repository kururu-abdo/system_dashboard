class Admin {

  String id;

  String name;
  String password;
  String phone;

Admin.fromJson(Map<dynamic, dynamic> json){

   id = json != null ? json['id'] : null;
    name = json != null ? json['name'] : null;
     phone = json != null ?  json['phone'] : null;

     password = json != null ?  json['password'] : null;
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? null;
    data['name'] = this.name ?? null;
        data['phone'] = this.phone ?? null; 
         data['password'] = this.password ?? null;
    return data;
  }
}