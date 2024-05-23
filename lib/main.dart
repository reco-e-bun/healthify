import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = "start";

  final prefs = await SharedPreferences.getInstance();
  final storedData = prefs.getBool("SignedUp");
  if (!(storedData == null || storedData == false)) {
    initialRoute = "home";
  }

  await dotenv.load();

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
        routes: {
          "start": (context) => StartPage(),
          "form": (context) => const FormPage(title: 'Healthify'),
          "home": (context) => const HomePage(title: 'Healthify'),
        }

        //home: const MyHomePage(title: 'Healthify'),
        );
  }
}

class StartPage extends StatefulWidget{
  StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool showButton = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Welcome to Healthify!", 
                  textStyle: const TextStyle(color: Colors.white, fontSize: 27), 
                  speed: const Duration(milliseconds: 50),
                ),
                TypewriterAnimatedText(
                  "To start,\nplease tell us about yourself",
                  textStyle: const TextStyle(color: Colors.white, fontSize: 22),
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 2000),
              onFinished: (){setState(() {
                showButton = true;
              });},
            ),
            if(showButton)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, right: 20),
                  child: TextButton(
                    onPressed: nextButtonHandler,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), 
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),),
                    child: Text("Next", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  ),
                ),
              )
          ],
        )
      )
    );
  }

  void nextButtonHandler(){
    Navigator.pushReplacementNamed(context, 'form');
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

  void nextButtonHandler() async {
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

    //prefs.setBool("SignedUp", false);
    prefs.clear();
  }

  updateLocalData(List<TextEditingController> formFields, int muscleMass,
      int muscleMassGoal) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> muscleMassList = <String>[
      "Very weak",
      "Weak",
      "Close to average",
      "Average",
      "Above average",
      "Strong",
      "Very strong"
    ];

    // ba tega asta e useless gen nu o sa o folosim deloc in aplicatie
    // o las aici doar in caz ca sunt prost si nu realizez unde o folosim 💵
    // List<String> formFieldNames = [
    //   "age",
    //   "weight",
    //   "height",
    //   "breakfast",
    //   "lunch",
    //   "dinner",
    //   "snacks",
    //   "allergens",
    //   "weightGoal",
    // ];

    // for (int i = 0; i <= 8; i++) {
    //   if (i == 0 || i == 2) {
    //     //age si height
    //     await prefs.setInt(formFieldNames[i], int.parse(formFields[i].text));
    //   } else if (i == 1 || i == 8) {
    //     //weight si weightGoal
    //     await prefs.setDouble(
    //         formFieldNames[i], double.parse(formFields[i].text));
    //   } else {
    //     await prefs.setString(formFieldNames[i], formFields[i].text);
    //   }
    // }

    // //muscleMass si muscleMassGoal
    // await prefs.setInt("muscleMass", muscleMass);
    // await prefs.setInt("muscleMassGoal", muscleMassGoal);

    //query ul de la chatGPT
    String query =
        "You are a nutritionist and personal trainer and you have to provide me a repeating 5-day program of physical exercises and diet trough json form by the scheme: diet: [day1: [breakfast: [], lunch: [], dinner: [], snacks:[]], day2:[...], ... (and so on for the other days)], exercises: [day1: [], day2: [], ... (and so on for the other days)]. you have to take in consideration the following facts about me: i am ${formFields[0].text} years old, i have ${formFields[1].text} kg and ${formFields[2].text} cm, my diet in a normal day is the following: at breakfast i eat ${formFields[3].text}, at lunch ${formFields[4].text}, at dinner ${formFields[5].text}";

    //snacks
    if (formFields[6].text == "") {
      query = query + ".";
    } else {
      query =
          query + " and between meals sometimes i eat ${formFields[6].text}.";
    }

    //allergens
    if (formFields[7].text != "") {
      query = query + " I am also allergic to ${formFields[7].text}.";
    }

    //muscleMass si celelalte bazate pe asta
    query = query +
        " My muscle mass is ${muscleMassList[muscleMass]}. I want to get to ${formFields[8].text} kg and be ${muscleMassList[muscleMassGoal]}. please give me only the json i asked for and nothing else in your response.";

    // print(query);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${dotenv.env['token']}',
      },
      body: jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": query,
            },
          ],
          "max_tokens": 4000,
          "temperature": 1,
          "top_p": 1,
        },
      ),
    );

    final decodedResponse = jsonDecode(response.body);
    final message = decodedResponse['choices'][0]['message']['content'];

    final decodedJsonResponse = jsonDecode(message);

    for (int i = 1; i <= 5; i++) {
      String s = "day$i";
      String key = "day${i}Meals";
      String value = jsonEncode(decodedJsonResponse['diet'][s]);

      // print(decodedJsonResponse['diet'][s]);
      // print(jsonEncode(decodedJsonResponse['diet'][s]));
      await prefs.setString(key, value);
    }

    for (int i = 1; i <= 5; i++) {
      String s = "day$i";
      String key = "day${i}Exercises";
      String value = jsonEncode(decodedJsonResponse['exercises'][s]);

      // print(decodedJsonResponse['exercises'][s]);
      await prefs.setString(key, value);
    }

    await prefs.setBool("SignedUp", true);
  }
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final prefs = SharedPreferences.getInstance();
  int currentDay = 1;

  //da eroare ca nu e initialized dar daca il initializez nu mai merge :)
  //si e gen eroare d aia care merge aplicatia cu tot cu ea adc o las asa 😘
  late String breakfast = "", lunch = "", dinner = "", exercises = "";

  //sunt in avion si nush daca exista list.resize asa ca fac asta pt ca nu am acces la google 🎶
  List<String> colorList = <String>["red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red",];

  @override
  void initState() {
    super.initState();

    updateStateByDay();
  }

  updateStateByDay() async {
    final prefs = await SharedPreferences.getInstance();

    int? day = 1;
    if (prefs.getInt("currentDay") != null){
      day = prefs.getInt("currentDay");
    }
    if (day == null){
      return;
    }


    setState(() {
      currentDay = day!;
    });

    int curDay = day % 5;

    if(curDay == 0) {
      curDay = 5;
    }

    final meals = prefs.getString("day${curDay}Meals");

    if (meals == null) {
      //asta e pusa aici doar pt ca imi dadea eroare ca era "String?" si nu stiam altcv ce sa i fac :)
      return;
    }

    final decodedMeals = jsonDecode(meals);

    final joinedBreakfast = decodedMeals['breakfast'].join(', ');
    setState(() {
      breakfast = joinedBreakfast;
    });

    final joinedLunch = decodedMeals['lunch'].join(', ');
    setState(() {
      lunch = joinedLunch;
    });

    final joinedDinner = decodedMeals['dinner'].join(', ');
    setState(() {
      dinner = joinedDinner;
    });

    final exercise = prefs.getString("day${curDay}Exercises");

    if (exercise == null) {
      //asta e pusa aici doar pt ca imi dadea eroare ca era "String?" si nu stiam altcv ce sa i fac :)
      return;
    }

    final decodedExercise = jsonDecode(exercise);

    final joinedExercises = decodedExercise.join(', ');
    setState(() {
      exercises = joinedExercises;
    });

    //nu trb for doar imi era lene sa fac doar pt una asa ca ramane asa e 30^2 nu face nimeni urat
    for(int i = 1; i<currentDay; i++){
      final String key = "colorDay${i}";

      final color = prefs.getString(key);

      if(color != null){
        setState(() {
          colorList[i] = color;
        });
      }
    }

    // for(int i = 1; i<currentDay; i++){
    //   print(colorList[i]);
    // }
    // print("");

    setState(() {
      widgetOptions = create_widgetOptions();
    });
  }

  void updateDayCounter() async {
    setState(() {
      currentDay++;
    });

    await updateStateByDay();

    setState(() {
      widgetOptions = create_widgetOptions();
    });

    // print(currentDay);
  }

  create_widgetOptions() {

    late List<Widget> widgetOptions = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Today's program",
                style: TextStyle(fontSize: 26),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                "Day $currentDay",
                style: const TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
              )),
          //diet
          Padding(
            padding: EdgeInsets.only(top: 70),
            child: ExpansionTile(
                title: Text("Diet", style: TextStyle(fontSize: 20)),
                children: <Widget>[
                  ExpansionTile(
                      title: Text("Breakfast", style: TextStyle(fontSize: 17)),
                      children: <Widget>[
                        ListTile(
                            title: Text(breakfast),
                            contentPadding: EdgeInsets.only(left: 30)),
                      ]),
                  ExpansionTile(
                    title: Text("Lunch", style: TextStyle(fontSize: 17)),
                    children: <Widget>[
                      ListTile(
                          title: Text(lunch),
                          contentPadding: EdgeInsets.only(left: 30)),
                    ],
                  ),
                  ExpansionTile(
                      title: Text("Dinner", style: TextStyle(fontSize: 17)),
                      children: <Widget>[
                        ListTile(
                            title: Text(dinner),
                            contentPadding: EdgeInsets.only(left: 30)),
                      ]),
                ]),
          ),
          //exercises
          ExpansionTile(
              title: Text("Exercises", style: TextStyle(fontSize: 20)),
              children: <Widget>[
                ListTile(
                    title: Text(exercises),
                    contentPadding: EdgeInsets.only(left: 30)),
              ]),
          //view entire program
          Padding(
              padding: const EdgeInsets.only(top: 80, left: 70, right: 70),
              child: TextButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size?>(const Size(10, 10)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: viewEntireProgramButtonHandler,
                child: const Text("View entire program",
                    style: TextStyle(fontSize: 16)),
              ))
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 50),
              child: Text(
                "Track progress",
                style: TextStyle(fontSize: 26),
                textAlign: TextAlign.center,
              )),
          for(int i=1;i<=5;i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for(int j=(i-1)*6+1;j<=(i-1)*6+6 && j<currentDay;j++)
                  Padding(
                    padding: EdgeInsets.only(left: (j==(i-1)*6+1) ? 0 : 5),
                    child: SizedBox(
                      width: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size?>(const Size.fromWidth(10)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            (colorList[j] == "red" ? Colors.red : (colorList[j] == "yellow" ? Color.fromARGB(255, 218, 198, 14) : Theme.of(context).colorScheme.primary))   //asta am pus-o doar de forma ca trebuie mai intai facut shared preferances
                          ),
                        ),
                        child: Text("$j"),
                        onPressed: () { dayButtonHandler(j); },
                      ),
                    )
                  ),
                for(int j=max((i-1)*6+1, currentDay);j<=(i-1)*6+6;j++)
                  Padding(
                    padding: EdgeInsets.only(left: (j==(i-1)*6+1) ? 0 : 5),
                    child: SizedBox(
                      width: 50,
                      child: TextButton(
                        child: Text("$j"),
                        onPressed: (){},
                      ),
                    )
                  )
              ]
            ),
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
                  onPressed: completeDayButtonHandler,
                  child: const Text("Complete day"),
                ),
              ),
            ),
        ]
      )
    ];

    return widgetOptions;
  }

  late List<Widget> widgetOptions = create_widgetOptions();

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
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(top: 50))),
              onPressed: resetSignedUpData,
              child: const Text("reset"),
            ),
            TextButton(onPressed: updateDayCounter, child: Text("next day")),
          ],
        ),
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

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  void viewEntireProgramButtonHandler(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>entireProgramPage()));
  }

  void completeDayButtonHandler(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>completeDayPage(currentDay: currentDay, updateDayCounter: updateDayCounter)));
  }

  dayButtonHandler(int day){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>specificDayPage(currentDay: day,)));
  }


  resetSignedUpData() async {
    //functia asta e doar pentru debugging
    //nu ar trebui sa ajunga in codul final :)

    final prefs = await SharedPreferences.getInstance();

    //prefs.setBool("SignedUp", false);
    await prefs.clear();
  }
}

class entireProgramPage extends StatefulWidget {
  const entireProgramPage({super.key});

  @override
  State<entireProgramPage> createState() => entireProgramPageState();
}

class entireProgramPageState extends State<entireProgramPage> {
  late List<String> breakfast = List<String>.filled(6, ""), lunch = List<String>.filled(6, ""), dinner = List<String>.filled(6, ""), exercise = List<String>.filled(6, "");

  @override
  void initState(){
    super.initState();

    getState();
  }

  getState() async{
    final prefs = await SharedPreferences.getInstance();

    List<String> breakfast_decoded = List<String>.filled(6, ""), lunch_decoded = List<String>.filled(6, ""), dinner_decoded = List<String>.filled(6, ""), exercise_decoded = List<String>.filled(6, "");
    
    for(int i=1;i<=5;i++){
      final meals = prefs.getString("day${i}Meals");
      final exercises = prefs.getString("day${i}Exercises");

      if (meals == null || exercises == null) {
        return;
      }

      final decodedMeals = jsonDecode(meals);
      final decodedExercises = jsonDecode(exercises);

      breakfast_decoded[i] = decodedMeals["breakfast"].join(', ');
      lunch_decoded[i] = decodedMeals["lunch"].join(', ');
      dinner_decoded[i] = decodedMeals["dinner"].join(', ');
      exercise_decoded[i] = decodedExercises.join(', ');
    }

    setState(() {
      breakfast = breakfast_decoded;
      lunch = lunch_decoded;
      dinner = dinner_decoded;
      exercise = exercise_decoded;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(color: Colors.white,),
        title: Text("Program", style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 40),
              child: Text(
                "Your program consists in the following 5-day repeating program:",
                style: TextStyle(fontSize: 23),
                textAlign: TextAlign.center,
              ),
            ),
            for(int i=1;i<=5;i++)
              ExpansionTile(
                title: Text("Day $i", style: TextStyle(fontSize: 23)),
                children: <Widget>[
                  ExpansionTile(
                    title: Text("Diet", style: TextStyle(fontSize: 20)),
                    children: <Widget>[
                      ExpansionTile(
                          title: Text("Breakfast", style: TextStyle(fontSize: 17)),
                          children: <Widget>[
                            ListTile(
                                title: Text(breakfast[i]),
                                contentPadding: EdgeInsets.only(left: 30)),
                          ]),
                      ExpansionTile(
                        title: Text("Lunch", style: TextStyle(fontSize: 17)),
                        children: <Widget>[
                          ListTile(
                              title: Text(lunch[i]),
                              contentPadding: EdgeInsets.only(left: 30)),
                        ],
                      ),
                      ExpansionTile(
                          title: Text("Dinner", style: TextStyle(fontSize: 17)),
                          children: <Widget>[
                            ListTile(
                                title: Text(dinner[i]),
                                contentPadding: EdgeInsets.only(left: 30)),
                          ]),
                    ]),
                    ExpansionTile(
                      title: Text("Exercises", style: TextStyle(fontSize: 20)),
                      children: <Widget>[
                        ListTile(
                            title: Text(exercise[i]),
                            contentPadding: EdgeInsets.only(left: 30)),
                      ]),
                ]
              )
          ]
        ),
      )
    );
  }
}

class specificDayPage extends StatefulWidget {
  const specificDayPage({super.key, required this.currentDay});

  final int currentDay;

  @override
  State<specificDayPage> createState() => _specificDayPageState();
}

class _specificDayPageState extends State<specificDayPage> {
  bool breakfastCheck = false;
  bool lunchCheck = false;
  bool dinnerCheck = false;
  bool exerciseCheck = false;

  @override
  void initState() {
    super.initState();

    getState();
  }

  getState() async {
    final prefs = await SharedPreferences.getInstance();

    final String breakfastKey = "breakfastDay${widget.currentDay}";
    final breakfastResult = prefs.getBool(breakfastKey);
    if(breakfastResult != null){
      setState(() {
        breakfastCheck = breakfastResult;
      });
    }

    final String lunchKey = "lunchDay${widget.currentDay}";
    final lunchResult = prefs.getBool(lunchKey);
    if(lunchResult != null){
      setState(() {
        lunchCheck = lunchResult;
      });
    }

    final String dinnerKey = "dinnerDay${widget.currentDay}";
    final dinnerResult = prefs.getBool(dinnerKey);
    if(dinnerResult != null){
      setState(() {
        dinnerCheck = dinnerResult;
      });
    }

    final String exerciseKey = "exerciseDay${widget.currentDay}";
    final exerciseResult = prefs.getBool(exerciseKey);
    if(exerciseResult != null){
      setState(() {
        exerciseCheck = exerciseResult;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(color: Colors.white,),
        title: Text("Day ${widget.currentDay} Results", style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              CheckboxListTile(
                value: breakfastCheck, 
                title: Text("Breakfast"), 
                onChanged: (bool? value){},
              ),
              CheckboxListTile(
                value: lunchCheck, 
                title: Text("Lunch"), 
                onChanged: (bool? value){},
              ),
              CheckboxListTile(
                value: dinnerCheck, 
                title: Text("Dinner"), 
                onChanged: (bool? value){},
              ),
              CheckboxListTile(
                value: exerciseCheck, 
                title: Text("Exercises"), 
                onChanged: (bool? value){},
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class completeDayPage extends StatefulWidget{
  const completeDayPage({super.key, required this.currentDay, required this.updateDayCounter});

  final int currentDay;
  final updateDayCounter;

  @override
  State<completeDayPage> createState() => _completeDayPageState();
}

class _completeDayPageState extends State<completeDayPage> {
  bool breakfastCheck = false;
  bool lunchCheck = false;
  bool dinnerCheck = false;
  bool exerciseCheck = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(color: Colors.white,),
        title: Text("Day ${widget.currentDay}", style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15, bottom: 20),
                child: Text(
                  "Please check the objectives of your program that you completed today",
                  style: TextStyle(fontSize: 21)
                ),
              ),
              CheckboxListTile(
                value: breakfastCheck, 
                title: Text("Breakfast"), 
                onChanged: (bool? value){setState(() {breakfastCheck = value!;},);},
              ),
              CheckboxListTile(
                value: lunchCheck, 
                title: Text("Lunch"), 
                onChanged: (bool? value){setState(() {lunchCheck = value!;},);},
              ),
              CheckboxListTile(
                value: dinnerCheck, 
                title: Text("Dinner"), 
                onChanged: (bool? value){setState(() {dinnerCheck = value!;},);},
              ),
              CheckboxListTile(
                value: exerciseCheck, 
                title: Text("Exercises"), 
                onChanged: (bool? value){setState(() {exerciseCheck = value!;},);},
              ),
            ],
          ),
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
                  onPressed: nextDayButtonHandler,
                  child: const Text("Finish day"),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void nextDayButtonHandler() async {
    if (widget.currentDay == 30) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FinalPage()));
    }


    int numberCompleted = 0;

    if(breakfastCheck == true){
      numberCompleted++;
    }
    if(lunchCheck == true){
      numberCompleted++;
    }
    if(dinnerCheck == true){
      numberCompleted++;
    }
    if(exerciseCheck == true){
      numberCompleted++;
    }

    await setCompletedDayData(numberCompleted);

    await widget.updateDayCounter();

    Navigator.pop(context);
  }

  setCompletedDayData(int number) async {
    final prefs = await SharedPreferences.getInstance();

    late String color;

    if(number == 0 || number == 1){
      // print("rosu");
      color = "red";
    }
    else if(number == 2 || number == 3){
      // print("galben");
      color = "yellow";
    }
    else if(number == 4){
      // print("verde");
      color = "green";
    }

    final String key = "colorDay${widget.currentDay}";
    await prefs.setString(key, color);

    final String breakfastKey = "breakfastDay${widget.currentDay}";
    await prefs.setBool(breakfastKey, breakfastCheck);

    final String lunchKey = "lunchDay${widget.currentDay}";
    await prefs.setBool(lunchKey, lunchCheck);

    final String dinnerKey = "dinnerDay${widget.currentDay}";
    await prefs.setBool(dinnerKey, dinnerCheck);

    final String exerciseKey = "exerciseDay${widget.currentDay}";
    await prefs.setBool(exerciseKey, exerciseCheck);

    await prefs.setInt("currentDay", widget.currentDay+1);
  }
}


class FinalPage extends StatefulWidget{
  FinalPage({super.key});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  bool showButton = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "You have finished the 30-day program!", 
                  textStyle: const TextStyle(color: Colors.white, fontSize: 27), 
                  speed: const Duration(milliseconds: 50),
                ),
                TypewriterAnimatedText(
                  "Congratulations for all the progress you have made so far!",
                  textStyle: const TextStyle(color: Colors.white, fontSize: 22),
                  speed: const Duration(milliseconds: 50),
                ),
                TypewriterAnimatedText(
                  "You can start to ",
                  textStyle: const TextStyle(color: Colors.white, fontSize: 22),
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 2000),
            ),
          ],
        )
      )
    );
  }
}