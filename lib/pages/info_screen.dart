import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class InfoScreen extends StatefulWidget {
  final Map<String, dynamic> info;
  const InfoScreen({super.key, required this.info});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}
 
class _InfoScreenState extends State<InfoScreen> {
  final DateFormat _dateFormat = DateFormat('d MMM yyyy, hh:mm:ss a'); 

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  children: [
                    Container(
                      width:(1/3)*width,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border.all(width:1,color:Colors.black),
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      child: Image(
                        image: NetworkImage(
                        '${widget.info['titlePhoto']}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Name: ${widget.info['firstName'] ?? ''} ${widget.info['lastName'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(
                            'Rank: ${widget.info['rank']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'User Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InfoTile(
                  label: 'Country',
                  value: '${widget.info['country']}',
                ),
                InfoTile(
                  label: 'City',
                  value: '${widget.info['city']}',
                ),
                InfoTile(
                  label: 'Organization',
                  value: '${widget.info['organization']}',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Codeforces Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InfoTile(
                  label: 'Rating',
                  value: '${widget.info['rating']}',
                ),
                InfoTile(
                  label: 'Max Rating',
                  value: '${widget.info['maxRating']}',
                ),
                InfoTile(
                  label: 'Max Rank',
                  value: '${widget.info['maxRank']}',
                ),
                InfoTile(
                  label: 'Contribution',
                  value: '${widget.info['contribution']}',
                ),
                InfoTile(
                  label: 'FriendsOfCount',
                  value: '${widget.info['friendOfCount']}',
                ),
                InfoTile(
                  label: 'Last Online',
                  value: _formatDate(widget.info['lastOnlineTimeSeconds']),
                ),
                InfoTile(
                  label: 'Registration Date',
                  value: _formatDate(widget.info['registrationTimeSeconds']),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(int secondsSinceEpoch) {
    return _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000));
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${label}: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}