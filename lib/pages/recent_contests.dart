import 'package:flutter/material.dart';

class RecentContestsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> contestData;

  const RecentContestsScreen({super.key, required this.contestData});

  @override
  State<RecentContestsScreen> createState() => _RecentContestsScreenState();
}

class _RecentContestsScreenState extends State<RecentContestsScreen> {
  late List<Map<String, dynamic>> reversedContestData;

  @override
  void initState() {
    super.initState();
    reversedContestData = widget.contestData.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 163, 175),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap:() => {
                  Navigator.pop(context)
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios,size:17,color:Colors.red[700]),
                    const SizedBox(width:5),
                    const Text("Back",style: TextStyle(fontSize: 16,color:Colors.black87,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              const SizedBox(height:10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white12.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Codeforces",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 175, 83, 8),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Visualizer",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.red[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Card(
                  color: const Color.fromARGB(255, 203, 213, 225),
                  clipBehavior: Clip.hardEdge,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'All Contest Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total Contests: ${reversedContestData.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height:5),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: reversedContestData.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final contest = reversedContestData[index];
                              return Card(
                                shadowColor: Colors.blue,
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contest['contestName'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Rank: ${contest['rank']}'),
                                      Text.rich(
                                        TextSpan(
                                          text: 'Rating: ',
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${contest['oldRating']} → ${contest['newRating']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: contest['newRating'] >
                                                        contest['oldRating']
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}