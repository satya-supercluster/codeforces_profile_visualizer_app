import 'dart:async';

import 'package:codeforces_profile_visualizer_app/pages/info_screen.dart';
import 'package:codeforces_profile_visualizer_app/pages/recent_contests.dart';
import 'package:codeforces_profile_visualizer_app/pages/recent_problems_screen.dart';
import 'package:codeforces_profile_visualizer_app/services/common_functions.dart';
import 'package:flutter/material.dart';
import 'animated_svg_image.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _usernameController = TextEditingController();
  Map<String, dynamic>? _userInfo;
  List<Map<String, dynamic>>? _userRating;
  List<Map<String, dynamic>>? _userProblem;
  String? _errorMessage;
  Timer? _errorTimer;
  Timer? _successTimer;
  bool isLoading = false;

  String verdict = "Search";
  Color verdictColor = Colors.blue[700]!; // Non-nullable assignment

  @override
  void initState() {
    verdict = "Search";
    super.initState();
    isLoading = false;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _cancelErrorTimer();
    _cancelSuccessTimer();
    super.dispose();
  }

  void _startErrorTimer() {
    _cancelErrorTimer(); // Cancel any existing timer
    _errorTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _errorMessage = null; // Clear the error message after 2 seconds
        verdict = "Search";
        verdictColor = Colors.blue[700]!;
      });
    });
  }

  void _cancelErrorTimer() {
    if (_errorTimer != null) {
      _errorTimer!.cancel(); // Cancel the timer
      _errorTimer = null;
    }
  }

  void _startSuccessTimer() {
    _cancelSuccessTimer(); // Cancel any existing timer
    _successTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        verdict = "Search";
        verdictColor = Colors.blue[700]!;
      });
    });
  }

  void _cancelSuccessTimer() {
    if (_successTimer != null) {
      _successTimer!.cancel(); // Cancel the timer
      _successTimer = null;
    }
  }

  Future<void> _fetchUserInfo() async {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      verdict = "Searching...";
      verdictColor = Colors.blue[700]!;
    });
    try {
      final userInfo = await fetchUserInfo(_usernameController.text);
      final userRating = await fetchUserRating(_usernameController.text);
      final userProblem = await fetchUserProblem(_usernameController.text);
      setState(() {
        _userInfo = userInfo;
        _userRating=userRating;
        _userProblem=userProblem;
        _errorMessage = null;
        verdict = "Success!";
        verdictColor = Colors.green[700]!;
        _cancelErrorTimer();
        _startSuccessTimer();
      });
    } catch (e) {
      setState(() {
        _userInfo = null;
        _userRating=null;
        _errorMessage = e.toString();
        verdict = "Error!!!";
        verdictColor = Colors.red[700]!;
        _startErrorTimer();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 156, 163, 175),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap:() => {
                    Navigator.pop(context)
                  },
                  child:Row(
                    children: [
                      Icon(Icons.arrow_back_ios,size:17,color:Colors.red[700]),
                      const SizedBox(width:5),
                      const Text("Back",style: TextStyle(fontSize: 18,color:Colors.black87,fontWeight: FontWeight.w500),)
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
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  onEditingComplete: _fetchUserInfo,
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color:Colors.blue[800]),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),   
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.search,color: Colors.yellow[700],),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                  ),
                ),
                const SizedBox(height:20),
                GestureDetector(
                  onTap:_fetchUserInfo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    decoration: BoxDecoration(
                      color:verdictColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                          BoxShadow(
                            color: verdictColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                    ),
                    child: Text(
                      verdict,
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                (isLoading==true)?
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  child: Column(
                    children: [
                      const AnimatedSvgImage(imagePath: 'assets/code.svg'),
                      Text("Loading...",style:TextStyle(fontSize: 25,color:Colors.deepOrange[800],fontWeight: FontWeight.w800)),
                    ],
                  )
                ):
                (_errorMessage!=null)?
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  decoration: BoxDecoration(
                    color:Colors.white,
                    border:Border.all(width:2,color: Colors.black,),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: Text(_errorMessage.toString(),style:TextStyle(fontSize: 18,color:Colors.red[700],fontWeight: FontWeight.w700))
                ):
                (_userInfo!=null)?
                Column(
                  children: [
                    const SizedBox(height:10),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color:Colors.black,
                            thickness: 2,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height:10),
                    const Text("Profile Data",style: TextStyle(fontSize: 25,color:Colors.deepPurple,fontWeight: FontWeight.w900),),
                    const SizedBox(height:20),
                    GestureDetector(
                      onTap:()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>InfoScreen(info: _userInfo??{})))
                      },
                      child: Container(
                        width:double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:Colors.green[800],
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                        ),
                        child: const Center(child: Text("User Information",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),)),
                      ),
                    ),
                    const SizedBox(height:20),
                    GestureDetector(
                      onTap:()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProblemStats(problemData: _userProblem??[])))
                      },
                      child: Container(
                        width:double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:Colors.green[800],
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                        ),
                        child: const Center(child: Text("Problem Stats",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),)),
                      ),
                    ),
                    const SizedBox(height:20),
                    GestureDetector(
                      onTap:()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RecentContestsScreen(contestData: _userRating??[])))
                      },
                      child: Container(
                        width:double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:Colors.green[800],
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                        ),
                        child: const Center(child: Text("Recent Contests",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),)),
                      ),
                    ),
                    const SizedBox(height:10),
                  ],
                ):
                const Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}