class User{
  String? name;
  String? password;
  bool? isRemember;
  bool? isAdmin;

  User(this.name, this.password,this.isRemember,[this.isAdmin=false]);
}