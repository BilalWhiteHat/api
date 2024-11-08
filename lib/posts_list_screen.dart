import 'package:flutter/material.dart';
import 'api_service.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  _PostsListScreenState createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    filterPosts();
  }

  void fetchData() async {
    final apiService = ApiService();
    final fetchedPosts = await apiService.fetchPosts();
    setState(() {
      posts = fetchedPosts;
      filteredPosts = posts;
    });
  }

  void filterPosts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredPosts = posts.where((post) {
        final title = post['title'].toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['body']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
