import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:flutter/widgets.dart';

class ProblemStats extends StatefulWidget {
  final List<Map<String, dynamic>> problemData;

  ProblemStats({required this.problemData});

  @override
  State<ProblemStats> createState() => _ProblemStatsState();
}

class _ProblemStatsState extends State<ProblemStats> {
  double averageRatingWeek = 0;
  double averageRatingMonth = 0;
  int numProblemsSolvedWeek = 0;
  int numProblemsSolvedMonth = 0;
  int uniqueProblemsSolvedWeek = 0;
  int uniqueProblemsSolvedMonth = 0;
  Set<String> activeDaysWeek = HashSet();
  Set<String> activeDaysMonth = HashSet();

  @override
  void initState() {
    super.initState();
    calculateStats();
  }

  void calculateStats() {
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    final oneWeekAgo = currentTime - 7 * 24 * 60 * 60;
    final oneMonthAgo = currentTime - 30 * 24 * 60 * 60;

    final problemsFromPastWeek = widget.problemData.where(
      (problem) => problem['creationTimeSeconds'] >= oneWeekAgo,
    ).toList();

    final problemsFromPastMonth = widget.problemData.where(
      (problem) => problem['creationTimeSeconds'] >= oneMonthAgo,
    ).toList();

    final uniqueProblemsWeek = HashSet<String>();
    final uniqueRatingsWeek = <int>[];
    final uniqueProblemsMonth = HashSet<String>();
    final uniqueRatingsMonth = <int>[];

    for (var problem in problemsFromPastWeek) {
      final date = DateTime.fromMillisecondsSinceEpoch(problem['creationTimeSeconds'] * 1000);
      final problemKey = '${problem['problem']['contestId']}-${problem['problem']['index']}';
      if (!uniqueProblemsWeek.contains(problemKey)) {
        uniqueProblemsWeek.add(problemKey);
        final rating = problem['problem']['rating'];
        if (rating != null && rating is int) {
          uniqueRatingsWeek.add(rating);
        }
      }
      activeDaysWeek.add(date.toIso8601String().substring(0, 10));
    }

    final totalRatingWeek = uniqueRatingsWeek.fold(0, (sum, rating) => sum + rating);
    averageRatingWeek = uniqueRatingsWeek.isNotEmpty ? (totalRatingWeek / uniqueRatingsWeek.length) : 0;
    uniqueProblemsSolvedWeek = uniqueProblemsWeek.length;

    for (var problem in problemsFromPastMonth) {
      final date = DateTime.fromMillisecondsSinceEpoch(problem['creationTimeSeconds'] * 1000);
      final problemKey = '${problem['problem']['contestId']}-${problem['problem']['index']}';
      if (!uniqueProblemsMonth.contains(problemKey)) {
        uniqueProblemsMonth.add(problemKey);
        final rating = problem['problem']['rating'];
        if (rating != null && rating is int) {
          uniqueRatingsMonth.add(rating);
        }
      }
      activeDaysMonth.add(date.toIso8601String().substring(0, 10));
    }

    final totalRatingMonth = uniqueRatingsMonth.fold(0, (sum, rating) => sum + rating);
    averageRatingMonth = uniqueRatingsMonth.isNotEmpty ? (totalRatingMonth / uniqueRatingsMonth.length) : 0;
    uniqueProblemsSolvedMonth = uniqueProblemsMonth.length;
    numProblemsSolvedWeek = problemsFromPastWeek.length;
    numProblemsSolvedMonth = problemsFromPastMonth.length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'Problems Stats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                children: [
                  buildStatsCard('Past Week', averageRatingWeek, numProblemsSolvedWeek, uniqueProblemsSolvedWeek, activeDaysWeek.length),
                  buildStatsCard('Past Month', averageRatingMonth, numProblemsSolvedMonth, uniqueProblemsSolvedMonth, activeDaysMonth.length),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatsCard(String title, double averageRating, int numProblemsSolved, int uniqueProblemsSolved, int activeDays) {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildStatsText('Average Rating', averageRating.toStringAsFixed(2)),
            buildStatsText('Number of Submissions', numProblemsSolved.toString()),
            buildStatsText('Problems Tried', uniqueProblemsSolved.toString()),
            buildStatsText('Active Days', activeDays.toString()),
          ],
        ),
      ),
    );
  }

  Widget buildStatsText(String label, String value) {
    return Text(
      '$label: $value',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}
