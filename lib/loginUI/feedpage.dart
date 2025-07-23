import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'settings.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final int _itemsPerPage = 5;
  int _currentPage = 0;
  int _selectedIndex = 0;

  List<DocumentSnapshot> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .orderBy('timestamp', descending: false) // oldest first
        .get();

    setState(() {
      _questions = snapshot.docs;
      _isLoading = false;
    });
  }

  List<DocumentSnapshot> _getCurrentPageItems() {
    int start = _currentPage * _itemsPerPage;
    int end = start + _itemsPerPage;
    end = end > _questions.length ? _questions.length : end;
    return _questions.sublist(start, end);
  }

  void _goToPage(int pageIndex) {
    setState(() => _currentPage = pageIndex);
  }

  void _nextPage() {
    if ((_currentPage + 1) * _itemsPerPage < _questions.length) {
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  void _onNavTapped(int index) async {
    if (index == 3) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildFeed();
      case 1:
        return const Profile();
      case 2:
        return const SettingsPage();
      default:
        return _buildFeed();
    }
  }

  Widget _buildFeed() {
    final pageCount = (_questions.length / _itemsPerPage).ceil();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_questions.isEmpty) {
      return const Center(
        child: Text(
          'No questions yet.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: _getCurrentPageItems().length,
            itemBuilder: (context, index) {
              final doc = _getCurrentPageItems()[index];
              final data = doc.data() as Map<String, dynamic>;

              final question = data['question'] ?? 'No Question';
              final answer = data['answer'] ?? 'No Answer';
              final fact = data['fact'] ?? 'No explanation provided.';
              final timestamp = data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : DateTime.now();

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionDetailPage(
                        question: question,
                        answer: answer,
                        fact: fact,
                        timestamp: timestamp,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          answer,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            DateFormat.yMMMd().add_jm().format(timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Pagination UI
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _prevPage,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Previous Page',
              ),
              ...List.generate(
                pageCount,
                (index) => GestureDetector(
                  onTap: () => _goToPage(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.indigo
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextPage,
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Next Page',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A Feed', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
    );
  }
}

class QuestionDetailPage extends StatelessWidget {
  final String question;
  final String answer;
  final String fact;
  final DateTime timestamp;

  const QuestionDetailPage({
    super.key,
    required this.question,
    required this.answer,
    required this.fact,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Question:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(question, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text(
                  'Answer:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(answer, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text(
                  'Explanation (Fact):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(fact, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat.yMMMd().add_jm().format(timestamp),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
