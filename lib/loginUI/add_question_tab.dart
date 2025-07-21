import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionTab extends StatefulWidget {
  const AddQuestionTab({super.key});

  @override
  State<AddQuestionTab> createState() => _AddQuestionTabState();
}

class _AddQuestionTabState extends State<AddQuestionTab> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _factController = TextEditingController();

  void _addQuestion() async {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();
    final fact = _factController.text.trim();

    if (question.isNotEmpty && answer.isNotEmpty && fact.isNotEmpty) {
      await FirebaseFirestore.instance.collection('questions').add({
        'question': question,
        'answer': answer,
        'fact': fact,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _questionController.clear();
      _answerController.clear();
      _factController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Question added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _questionController,
            decoration: const InputDecoration(labelText: 'Question'),
          ),
          TextField(
            controller: _answerController,
            decoration: const InputDecoration(labelText: 'Answer'),
          ),
          TextField(
            controller: _factController,
            decoration: const InputDecoration(labelText: 'Explanation / Fact'),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addQuestion,
            child: const Text('Add Question'),
          ),
        ],
      ),
    );
  }
}
