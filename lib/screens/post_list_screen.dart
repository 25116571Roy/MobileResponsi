import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<dynamic> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/posts');
      debugPrint('GET request to endpoint: ${uri.path}');

      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (AppConfig.apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${AppConfig.apiKey}';
      }

      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('GET request successful, received ${data.length} items');
        setState(() {
          _posts = data;
          _isLoading = false;
        });
      } else {
        debugPrint('GET request failed with status: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Gagal memuat data (HTTP ${response.statusCode})';
          _isLoading = false;
        });
      }
    } on SocketException catch (e) {
      debugPrint('Network error occurred: $e');
      setState(() {
        _errorMessage = 'Tidak ada koneksi internet';
        _isLoading = false;
      });
    } on TimeoutException catch (e) {
      debugPrint('Request timed out: $e');
      setState(() {
        _errorMessage = 'Koneksi waktu habis (Timeout)';
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Unexpected error occurred: $e');
      setState(() {
        _errorMessage = 'Terjadi kesalahan sistem';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Publik (HTTP GET)'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchPosts,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${post['id']}'),
              ),
              title: Text(
                post['title'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                post['body'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
