import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
    const NavigationMenu({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            bottomNavigationBar: NavigationBar(
                height: 80,
                elevation:0,
                selectedIndex:1,
                
                destinations: [
                    NavigationDestination(
                        icon: Icon(Icons.home),
                label: 'Home',
                    ),
                     NavigationDestination(
                         icon: Icon(Icons.map),
                         label: 'Map'
                    ),  
                     NavigationDestination(
                         icon: Icon(Icons.note_add_sharp),
                         label: 'Booking'
                    ),  
                     NavigationDestination(
                         icon: Icon(Icons.person),
                         label: 'Person'
                    ),   
             ],
            ),
            body: Container(),
        );
    }
}