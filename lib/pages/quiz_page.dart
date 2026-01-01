import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  int correctCount = 0;
  bool showExplanation = false;
  int? selectedIndex;
  int timeLeft = 15;
  Timer? timer;
  bool isLoading = true;
  bool isError = false;
  bool showSummary = false;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    fetchQuestions();
  }

  void startTimer() {
    timeLeft = 15;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        timeLeft--;
        if (timeLeft == 0) {
          t.cancel();
          setState(() => showExplanation = true);
        }
      });
    });
  }

  Future<void> fetchQuestions() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });

      final snapshot =
          await FirebaseFirestore.instance.collection('quiz_questions').get();

      questions = snapshot.docs.map((doc) => doc.data()).toList();

      if (questions.isEmpty) {
        throw Exception('No quiz questions found.');
      }

      setState(() {
        currentIndex = 0;
        isLoading = false;
        startTimer();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  void handleAnswer(int index) {
    if (selectedIndex != null) return;
    selectedIndex = index;
    bool correct = index == questions[currentIndex]['correctAnswerIndex'];
    if (correct) correctCount++;
    setState(() => showExplanation = true);
    timer?.cancel();
  }

  void nextQuestion() {
    if (currentIndex + 1 < questions.length) {
      setState(() {
        currentIndex++;
        showExplanation = false;
        selectedIndex = null;
        startTimer();
      });
    } else {
      saveResults();
      _confettiController.play();
      setState(() => showSummary = true);
    }
  }

  void saveResults() {
    FirebaseFirestore.instance.collection('quiz_results').add({
      'correct': correctCount,
      'total': questions.length,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz'), backgroundColor: Colors.deepPurple),
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 92, 29, 123),
      );
    }

    if (isError || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz'), backgroundColor: Colors.deepPurple),
        backgroundColor: const Color.fromARGB(255, 88, 28, 104),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.white),
              const SizedBox(height: 10),
              const Text("Failed to load quiz questions.",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: fetchQuestions,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text("Retry"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: const Color.fromARGB(255, 107, 36, 133),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 9, 43),
      body: showSummary ? buildSummaryScreen() : buildQuizUI(),
    );
  }

  Widget buildQuizUI() {
    final q = questions[currentIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: 15, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Time left: $timeLeft s',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                // Center the question
                Text(
                  q['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Show image only if user answered
                if (showExplanation &&
                    q['imageUrl'] != null &&
                    q['imageUrl'].toString().isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(q['imageUrl'], height: 180, fit: BoxFit.cover),
                  ),

                const SizedBox(height: 20),
                ...List.generate(q['options'].length, (i) {
                  final isCorrect = i == q['correctAnswerIndex'];
                  final isSelected = selectedIndex == i;
                  Color? tileColor;
                  if (showExplanation) {
                    tileColor = isCorrect
                        ? Colors.green[700]
                        : isSelected
                            ? Colors.red[700]
                            : Colors.white.withOpacity(0.1);
                  } else {
                    tileColor = Colors.white.withOpacity(0.1);
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      tileColor: tileColor,
                      title: Text(
                        q['options'][i],
                        style: const TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? Colors.amber : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      onTap: () => handleAnswer(i),
                    ),
                  );
                }),
                if (showExplanation) ...[
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Explanation:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    q['explanation'] ?? "No explanation",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Next", style: TextStyle(color: Colors.black)),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSummaryScreen() {
    int total = questions.length;
    double percentage = correctCount / total;
    int stars = (percentage * 5).round();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🎉 Quiz Complete!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 20),
              Text("You got $correctCount out of $total correct",
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(Icons.star,
                      color: index < stars ? Colors.amber : Colors.white24, size: 32),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple[900],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text("Back to Quizes"),
              )
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: pi / 2,
          emissionFrequency: 0.05,
          numberOfParticles: 25,
          shouldLoop: false,
          gravity: 0.1,
        )
      ],
    );
  }
}
