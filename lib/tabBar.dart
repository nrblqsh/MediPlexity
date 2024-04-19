import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: TabBarSeparate(),
  ));
}

class TabBarSeparate extends StatefulWidget {
  const TabBarSeparate({Key? key}) : super(key: key);

  @override
  _TabBarSeparateState createState() => _TabBarSeparateState();
}

class _TabBarSeparateState extends State<TabBarSeparate> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Separate TabBar Example"),
      ),
      body: Column(
        children: [
          // TabBar with text labels
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.phone, color: Colors.blue),
                child: Text(
                  "Phone",
                  style: TextStyle(color: Colors.blue), // Text color
                ),
              ),
              Tab(
                icon: Icon(Icons.alternate_email, color: Colors.blueGrey),
                child: Text(
                  "Email",
                  style: TextStyle(color: Colors.blueGrey), // Text color
                ),
              ),
            ],
          ),

          // Expanded TabBarView to display content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // First Tab content
                Container(
                  color: Colors.orangeAccent,
                  child: Center(child: Icon(Icons.phone, size: 64, color: Colors.blue)),
                ),
                // Second Tab content
                Container(
                  color: Colors.orangeAccent,
                  child: Center(child: Icon(Icons.alternate_email, size: 64, color: Colors.blueGrey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
