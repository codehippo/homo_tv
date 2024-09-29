import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homo_tv/tabs.dart';
import 'package:homo_tv/texttheme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    // Must add this line.
    await windowManager.ensureInitialized();

    // Use it only after calling `hiddenWindowAtLaunch`
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.center();
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
      await windowManager.setSize(Size(960.0, 540.0));
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
           seedColor: const Color(0xffe50914),
           brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: customTextTheme,
      ),
      home: const MyHomePage(title: 'Homo TV'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceDim,
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: KeyboardNavigableTab(
                  tabLabels: [
                    (icon: Icons.search_rounded, text: 'Search'),
                    (icon: Icons.home_rounded, text: 'Home'),
                    (icon: Icons.local_movies_rounded, text: 'Library'),
                    (icon: Icons.download_rounded, text: 'Downloads')
                  ],
                  onTabChanged: (index) {
                    print('Tab changed to index $index');
                    // Handle tab change here
                  },
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}
