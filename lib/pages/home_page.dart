import 'package:final_tree_app/main.dart';
import 'package:final_tree_app/pages/account_page.dart';
import 'package:final_tree_app/pages/search_page.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_tree_app/components/story_line.dart';
import 'package:final_tree_app/components/ten_pubs.dart';
import 'package:final_tree_app/dialogs/add_publication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  List<Widget> pages = [
    const Column(
      children: [
        StoryLine(),
        Expanded(
          child: TenPubs(),
        ),
      ],
    ),
    const AccountPage(),
    const SearchPage(),
    const Center(
      child: Text('Déconnexion'),
    ),
  ];

  // LogoutFunction(),

  void itemTapped(int index) {
    if (index == 3) _signOut();
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // const routings = ['/home', '/account', '/search', '/splash'];

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Tree')),
      backgroundColor: Colors.amber,
      body: pages.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Fil',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Déconnexion',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).primaryColorDark,
        onTap: itemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPublication(),
          ),
        ),
      ),
    );
    /*
        onTap: (item) => {
          if (item == 2)
            _signOut(context)
          else
            Navigator.pushNamed(context, routings[item]),
        },
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        items: [
          BottomNavigationBarItem(
            icon:
                Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
            label: 'Fil',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Profil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Recherche'),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Déconnexion'),
        ],
        
      ),*/
    /*
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPublication(),
          ),
        ),
      ),
    ); */
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Erreur innatendue (14)'),
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  LogoutFunction() {}
}
