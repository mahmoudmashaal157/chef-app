class DishModel{
  String? image;
  String? dishName;
  String? description;
  String? category;
  String? dishId;
  String? date;


  DishModel(this.image,this.category,this.description,this.dishName,this.date);

  DishModel.fromJson(Map<String,dynamic>json){
    image = json['image'];
    dishName=json['dishName'];
    description=json['Description'];
    category=json['category'];
    date = json['date'];
    dishId = json['id'];

  }

  Map<String,dynamic>toMap(){
    return {
      'image':image,
      'dishName':dishName,
      'Description':description,
      'category':category,
      'date':date,
      'id':dishId
    };
  }
}