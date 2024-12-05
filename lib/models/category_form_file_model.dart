class CategoryFormFileModel {
  int? id;
  String? photoPath;
  String? uploadedDate;
  String? categoryName;

  CategoryFormFileModel(
      {this.id, this.photoPath, this.uploadedDate, this.categoryName});

  CategoryFormFileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoPath = json['photoPath'];
    uploadedDate = json['uploadedDate'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photoPath'] = this.photoPath;
    data['uploadedDate'] = this.uploadedDate;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
