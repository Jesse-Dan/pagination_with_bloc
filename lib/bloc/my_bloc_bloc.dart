import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pagination_with_bloc/data/models/filter_model.dart';
import 'package:pagination_with_bloc/data/models/post.dart';
import 'package:pagination_with_bloc/data/repositories/posts_respository.dart';

part 'my_bloc_event.dart';
part 'my_bloc_state.dart';

class MyBlocBloc extends Bloc<MyBlocEvent, MyBlocState> {
  final PostsRepository postsRepository;
      // var page = 1;
    List<Post> list = [];
    FilterModel filterModel = FilterModel(page: 1, limit: 10);
    bool initialLoadComplete = false;
    bool initialLoadComplete2 = false;
    bool initialLoadComplete3 = false;

  MyBlocBloc(this.postsRepository) : super(MyBlocInitial()) {

    /// on initial
    on<MyBlocEvent>((event, emit) async {
      if (!initialLoadComplete) {
        emit(MyBlocLoading());
        var newData = await postsRepository.fetchPosts(
            page: filterModel.page, limit: filterModel.limit);
        list.addAll(newData);
        emit(MyBlocLoaded(list));
        filterModel.page = filterModel.page + 1;
        log('normal call ${list.length}');
        initialLoadComplete = true;
      }
    });
    on<RefreshEvent>((event, emit) async {
      if (!initialLoadComplete2) {
        emit(MyBlocLoading());
        list.clear();
        var newData =
            await postsRepository.fetchPosts(page: 1, limit: filterModel.limit);
        emit(MyBlocLoaded(newData));
        log('refresh call ${list.length}');
        initialLoadComplete2 = true;
      }
    });

    on<LoadMoreEvent>((event, emit) async {
      if (!initialLoadComplete3) {
        emit(MyBlocLoading());
        var newPaginatedData = await postsRepository.fetchPosts(
            page: filterModel.page, limit: filterModel.limit);
        list.addAll(newPaginatedData);
        emit(MyBlocLoaded(list));
        log('loadmore call ${list.length}');
        initialLoadComplete3 = true;
      }
    });
  }
}
