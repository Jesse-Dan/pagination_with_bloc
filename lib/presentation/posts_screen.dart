import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_bloc/bloc/my_bloc_bloc.dart';
import 'package:pagination_with_bloc/data/models/filter_model.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  final scrollController = ScrollController();
  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent * 0.9) {
        BlocProvider.of<MyBlocBloc>(context).add(LoadMoreEvent());
      }
    });
  }

  @override
  void initState() {
    setupScrollController(context);
    BlocProvider.of<MyBlocBloc>(context).add(const MyBlocEvent());
    super.initState();
  }

  final TextEditingController page = TextEditingController();
  final TextEditingController limit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: RefreshIndicator(
          onRefresh: (() async {
            // BlocProvider.of<MyBlocBloc>(context).add(RefreshEvent());
          }),
          child: _list()),

      /// Filter
      floatingActionButton: Column(
        children: [
          FloatingActionButton(onPressed: () {
            BlocProvider.of<MyBlocBloc>(context).add(RefreshEvent());
          }),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        content: Column(
                          children: [
                            TextField(
                              controller: limit,
                              decoration:
                                  const InputDecoration(hintText: 'set limit'),
                            ),
                            // TextField(
                            //     controller: page,
                            //     decoration:
                            //         const InputDecoration(hintText: 'set Page'))
                          ],
                        ),
                        actions: [
                           TextButton(
                              onPressed: () async {
                                BlocProvider.of<MyBlocBloc>(context)
                                    .filterModel
                                    .copyWith(
                                        limit: int.parse(limit.text),
                                        loader: Loader.firstCall,
                                        page: 1);
                              },
                              child: const Text('Set data')),
                        
                          TextButton(
                              onPressed: () async {
                                BlocProvider.of<MyBlocBloc>(context)
                                    .add(const MyBlocEvent());
                                Navigator.of(context).pop();
                              },
                              child: const Text('Filter'))
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return BlocBuilder<MyBlocBloc, MyBlocState>(
      builder: (context, state) {
        if (state is MyBlocInitial) {
          return const Center(child: Text('Please  wait \n Loading...'));
        } else if (state is MyBlocLoaded) {
          return ListView.builder(
            controller: scrollController,
            itemCount: state.post.length + 1,
            itemBuilder: (context, index) {
              if (index < state.post.length) {
                return ListTile(
                  leading: Text(state.post[index].id.toString()),
                  subtitle: Text(state.post[index].body),
                  title: Text(state.post[index].title),
                );
              } else if (index == state.post.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else {
          return const Center(
            child: Text(''),
          );
        }
      },
    );
  }
}
