class UserModel {
  String? uId;
  String? name;
  String? phone;
  String? email;
  String? image;

  UserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.image
});

  UserModel.fromJson(Map<String,dynamic>map){
    uId=map['uId'];
    name=map['name'];
    phone=map['phone'];
    email=map['email'];
    image=map['image'];
  }
  Map<String,dynamic>toMap(){
    return{
      'uId':uId,
      'name':name,
      'phone':phone,
      'email':email,
      'image':image
    };
  }
}