import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Quotes {
  final int id;
  final String quote;
  final String author;

  Quotes({
    required this.id,
    required this.quote,
    required this.author,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
    );
  }
}

class QuotesModel extends StatelessWidget {
  final Quotes quote;
  const QuotesModel({ super.key, required this.quote });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Card(
        elevation: 4.0,
        child: Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            quote.quote,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      )
      )
        
      )
      
    );
  }
}

class QuotesApi {
  final String apiUrl = 'https://fcapi-1y70.onrender.com/quotes';

  Future<List<Quotes>> getQuotes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Quotes.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuotesApi quotesApi = QuotesApi();
  Quotes? currentQuote;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialQuote();
  }

  void fetchInitialQuote() async {
    try {
      List<Quotes> quotes = await quotesApi.getQuotes();
      setState(() {
        currentQuote = quotes.first;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch quotes: $error');
    }
  }

  void fetchNewQuote() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Quotes> quotes = await quotesApi.getQuotes();
      setState(() {
        currentQuote = (quotes..shuffle()).first;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch quotes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              padding: const EdgeInsets.all(20),
              child: 
              Card(
                color: Colors.white,
                elevation: 4.0,
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: InkWell(
                onTap: () {
                  if (!isLoading && currentQuote != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Individual(quotes: currentQuote!),
                      ),
                    );
                  }
                },
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.lightBlue,
                        )
                      : Text(
                          currentQuote!.quote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                  ),
                )
                
              ),

            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: fetchNewQuote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: EdgeInsets.fromLTRB(70, 10, 70, 10)),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShowAll()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: EdgeInsets.fromLTRB(70, 10, 70, 10)),
                  child: const Text(
                    'Show All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Individual extends StatelessWidget {
  final Quotes quotes;
  const Individual({ super.key, required this.quotes });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              padding: const EdgeInsets.all(20),
              
              child: Card(
                color: Colors.white,
                elevation: 4.0,
                child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Quiz ID: 0${quotes.id.toString()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding:EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: Text(
                      
                      textAlign: TextAlign.center,
                      quotes.quote,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    )
                    
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20,0,40,0),
                    alignment: Alignment.centerRight,
                    child:Text(
                    textAlign: TextAlign.left,
                    quotes.author,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  )
                  
                ],
              ),
              ) 
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: EdgeInsets.fromLTRB(100, 10, 100, 10)),
              child: const Text("Back", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowAll extends StatefulWidget {
  const ShowAll({ super.key });

  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
  late Future<List<Quotes>> futureQuotes;
  List<Quotes> allQuotes = [];

  @override
  void initState() {
    super.initState();
    futureQuotes = QuotesApi().getQuotes();
    futureQuotes.then((value) {
      setState(() {
        allQuotes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder<List<Quotes>>(
              future: futureQuotes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Failed to load Quotes, Please try again"));
                } else {
                  return ListView.builder(
                    itemCount: allQuotes.length,
                    itemBuilder: (context, index) {
                      return QuotesModel(quote: allQuotes[index]);
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: 
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                child: Text("Back", style: TextStyle(color: Colors.white)),
                ) 
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam',
      home: HomePage(),
    );
  }
}
