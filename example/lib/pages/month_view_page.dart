import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/month_view_widget.dart';
import '../widgets/responsive_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class MonthViewPageDemo extends StatefulWidget {
  const MonthViewPageDemo({
    super.key,
  });

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const MonthViewWidget(),
    const Center(child: Text('Notes')),
    const Center(child: Text('Settings')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      webWidget: WebHomePage(
        selectedView: CalendarView.month,
      ),
      mobileWidget: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: _selectedIndex == 0 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.note,
                        color: _selectedIndex == 1 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(1),
                    ),
                  ],
                ),
              ),
              
              // Space for FAB
              const SizedBox(width: 48),
              
              // Right side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: _selectedIndex == 2 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(2),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: _selectedIndex == 3 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}