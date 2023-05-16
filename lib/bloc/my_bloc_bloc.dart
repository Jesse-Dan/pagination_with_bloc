// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'dart:html';
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
  static const int MAX_PAGE_SIZE = 100;
  List<Post> list = [];
  FilterModel filterModel = FilterModel(page: 1, limit: 10);
  bool initialLoadComplete = false;
  bool initialLoadComplete2 = false;
  bool initialLoadComplete3 = false;

  MyBlocBloc(this.postsRepository) : super(MyBlocInitial()) {
    /// on initial
    _loadMoreEvent();
    _refreshEvent();
    _mainEvent();
    // _loadMoreEvent2();
  }
  Future<void> _mainEvent() async {
    return on<MainEvent>((event, emit) async {
      if (!initialLoadComplete) {
        initialLoadComplete = true;
        emit(MyBlocLoading());
        log('normal call ${list.length} & page: ${filterModel.page} & limit ${filterModel.limit}');
        var newData = await postsRepository.fetchPosts(
            page: filterModel.page, limit: filterModel.limit);
        if (newData.length <= MAX_PAGE_SIZE) {
          list.addAll(newData);
          emit(MyBlocLoaded(list));
          initialLoadComplete = false;
        } else {
          emit(MyBlocEmpty(list));
          initialLoadComplete = false;
        }
      }
    });
  }

  Future<void> _loadMoreEvent() async {
    return on<LoadMoreEvent>((event, emit) async {
      filterModel.page = filterModel.page + 1;
      if (!initialLoadComplete3) {
        initialLoadComplete3 = true;
        log('loadmore call ${list.length} & page: ${filterModel.page} & limit ${filterModel.limit}');
        emit(MyBlocLoading());
        var newPaginatedData = await postsRepository.fetchPosts(
            page: filterModel.page, limit: filterModel.limit);
        if (list.length + newPaginatedData.length <= MAX_PAGE_SIZE) {
          if (list.length + newPaginatedData.length == MAX_PAGE_SIZE) {
            if (newPaginatedData != []) {
              emit(MyBlocEmpty(list));
              initialLoadComplete3 = false;
            }
          } else {
            list.addAll(newPaginatedData);
            emit(MyBlocLoaded(list));
            initialLoadComplete3 = false;
          }
        } else {
          emit(MyBlocEmpty(list));
          initialLoadComplete3 = false;
        }
      }
    });
  }

  Future<void> _refreshEvent() async {
    return on<RefreshEvent>((event, emit) async {
      if (!initialLoadComplete2) {
        initialLoadComplete2 = true;
        log('refresh call ${list.length} & page: ${filterModel.page} & limit ${filterModel.limit}');
        emit(MyBlocLoading());
        if (list.length <= MAX_PAGE_SIZE) {
          list.clear();
          var newData = await postsRepository.fetchPosts(
              page: 1, limit: filterModel.limit);
          emit(MyBlocLoaded(newData));
          initialLoadComplete2 = false;
        } else {
          emit(MyBlocEmpty(list));
          initialLoadComplete2 = false;
        }
      }
    });
  }
}
