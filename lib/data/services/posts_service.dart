// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../models/post.dart';

class PostsService {
  static const FETCH_LIMIT = 15;
  final baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> fetchPosts(int? page, {int? limit}) async {
    try {
      final response = await get(
          Uri.parse("$baseUrl?_limit=${limit ?? FETCH_LIMIT}&_page=$page"));
      final List<dynamic> postsData =
          jsonDecode(response.body) as List<dynamic>;
      return postsData.map((postData) => Post.fromJson(postData)).toList();
    } catch (err) {
      print("Error fetching posts: $err");
      return [];
    }
  }
}
