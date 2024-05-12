import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = "form";

  final prefs = await SharedPreferences.getInstance();
  final storedData = prefs.getBool("SignedUp");
  if(!(storedData == null || storedData == false)){
    initialRoute = "home";
  }

  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  MyApp({required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 176, 13), brightness: Brightness.light),
        colorScheme: const ColorScheme.light()
            .copyWith(primary: const Color.fromARGB(255, 40, 150, 20)),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes:{
        "form": (context) => const FormPage(title: 'Healthify'),
        "home": (context) => const HomePage(title: 'Healthify'),
      }
      
      //home: const MyHomePage(title: 'Healthify'),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key, required this.title});

  final String title;

  @override
  State<FormPage> createState() => _FormPageState();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _FormPageState extends State<FormPage> {
  List<String> list = <String>[
    "Very weak",
    "Weak",
    "Close to average",
    "Average",
    "Above average",
    "Strong",
    "Very strong"
  ];
  String dropdownValue1 = "Average";
  String dropdownValue2 = "Average";
  bool alreadySignedUp = false;

  final List<TextEditingController> controllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //age
            const Padding(
                padding: EdgeInsets.only(top: 20, left: 12),
                child: Text(
                  "Age:",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: TextField(
                  controller: controllerList[0],
                  decoration: const InputDecoration(
                    hintText: "Enter your age",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ]),
            ),

            //weight
            const Padding(
                padding: EdgeInsets.only(top: 45, left: 12),
                child: Text(
                  "Weight(kg):",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: TextField(
                  controller: controllerList[1],
                  decoration: const InputDecoration(
                    hintText: "Enter your weight",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                      ),
                    ),
                  ]),
            ),

            //height
            const Padding(
                padding: EdgeInsets.only(top: 45, left: 12),
                child: Text(
                  "Height(cm):",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: TextField(
                  controller: controllerList[2],
                  decoration: const InputDecoration(
                    hintText: "Enter your height",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
            ),

            //diet
            const Padding(
                padding: EdgeInsets.only(top: 45, left: 12),
                child: Text(
                  "Describe what you normally eat in a day:",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              //breakfast
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: TextField(
                controller: controllerList[3],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Breakfast",
                ),
              ),
            ),
            Padding(
              //lunch
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: TextField(
                controller: controllerList[4],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Lunch",
                ),
              ),
            ),
            Padding(
              //dinner
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: TextField(
                controller: controllerList[5],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Dinner",
                ),
              ),
            ),
            Padding(
              //snacks
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: TextField(
                controller: controllerList[6],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Snacks(optional)",
                ),
              ),
            ),
            Padding(
              //allergens
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: TextField(
                controller: controllerList[7],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Allergens(optional)",
                ),
              ),
            ),

            //muscle mass
            const Padding(
                padding: EdgeInsets.only(top: 45, left: 12),
                child: Text(
                  "Describe your muscle mass:",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: DropdownButton<String>(
                value: dropdownValue1,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                underline: Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue1 = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            //goals
            const Padding(
                padding: EdgeInsets.only(top: 45, left: 12),
                child: Text(
                  "Describe your weight and muscle mass goals after a 30-day program:",
                  style: TextStyle(fontSize: 20),
                )),
            //weight goal
            const Padding(
                padding: EdgeInsets.only(top: 12, left: 12),
                child: Text(
                  "Weight goal(kg):",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: TextField(
                  controller: controllerList[8],
                  decoration: const InputDecoration(
                    hintText: "Enter your desired weight",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                      ),
                    ),
                  ]),
            ),
            //muscle mass goal
            const Padding(
                padding: EdgeInsets.only(top: 30, left: 12),
                child: Text(
                  "Muscle mass goal:",
                  style: TextStyle(fontSize: 19),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: DropdownButton<String>(
                value: dropdownValue2,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                underline: Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue2 = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            //next button
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, right: 15, bottom: 10),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: nextButtonHandler,
                  child: const Text("Next"),
                ),
              ),
            ),
            // Text("${alreadySignedUp}"),
          ],
        ),
      ),
    );
  }

  void nextButtonHandler() {
    for (int i = 0; i <= 8; i++) {
      if (controllerList[i].text == "" && i != 6 && i != 7) {
        //6 si 7 sunt field-urile alea optionale
        //print(i);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please complete all mandatory fields"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
    }
    if (double.parse(controllerList[8].text) <
            double.parse(controllerList[1].text) - 5 ||
        double.parse(controllerList[8].text) >
            double.parse(controllerList[1].text) + 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your weight goal isn't realistic"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (list.indexOf(dropdownValue2) - list.indexOf(dropdownValue1) > 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your muscle mass goal isn't realistic"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (list.indexOf(dropdownValue2) - list.indexOf(dropdownValue1) < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("Your muscle mass goal can't be less than your current one"),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    updateLocalData(controllerList, list.indexOf(dropdownValue1),
        list.indexOf(dropdownValue2));

    Navigator.pushReplacementNamed(context, 'home');
  }


  resetSignedUpData() async {
    //functia asta e doar pentru debugging
    //nu ar trebui sa ajunga in codul final :)

    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("SignedUp", false);
  }

  updateLocalData(List<TextEditingController> formFields, int muscleMass,
      int muscleMassGoal) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> formFieldNames = [
      "age",
      "weight",
      "height",
      "breakfast",
      "lunch",
      "dinner",
      "snacks",
      "allergens",
      "weightGoal",
    ];

    for (int i = 0; i <= 8; i++) {
      if (i == 0 || i == 2) {
        //age si height
        await prefs.setInt(formFieldNames[i], int.parse(formFields[i].text));
      } else if (i == 1 || i == 8) {
        //weight si weightGoal
        await prefs.setDouble(
            formFieldNames[i], double.parse(formFields[i].text));
      } else {
        await prefs.setString(formFieldNames[i], formFields[i].text);
      }
    }

    //muscleMass si muscleMassGoal
    await prefs.setInt("muscleMass", muscleMass);
    await prefs.setInt("muscleMassGoal", muscleMassGoal);

    await prefs.setBool("SignedUp", true);
  }
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    Text(
      "Today's Program"
    ),
    Text(
      "Track progress"
    )
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widgetOptions[selectedIndex],
            TextButton(
              onPressed: resetSignedUpData,
              child: const Text("reset"),
            ),
          ]
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Program",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Track progress",
          )
        ],
        currentIndex: selectedIndex,
        onTap: onItemTap,
      ),
    );
  }

  void onItemTap(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  resetSignedUpData() async {
    //functia asta e doar pentru debugging
    //nu ar trebui sa ajunga in codul final :)

    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("SignedUp", false);
  }
}