// ignore_for_file: public_member_api_docs, sort_constructors_first

enum Loader {firstCall,flter,refresh}
class FilterModel {
   int page;
     int? limit;

   Loader loader;

  FilterModel({ this.page = 1,  this.limit,  this.loader = Loader.firstCall});
  

  FilterModel copyWith({
    int? page,
    int? limit,
    Loader? loader,
  }) {
    return FilterModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      loader: loader ?? this.loader,
    );
  }
}
