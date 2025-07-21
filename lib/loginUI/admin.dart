import 'package:flutter/material.dart';
import 'view_questions_tab.dart';
import 'add_question_tab.dart';
import 'edit_question_tab.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'View'),
              Tab(text: 'Add'),
              Tab(text: 'Edit/Delete'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ViewQuestionsTab(), AddQuestionTab(), EditQuestionTab()],
        ),
      ),
    );
  }
}
