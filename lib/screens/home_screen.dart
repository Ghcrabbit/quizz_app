import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/question_model.dart';  // our question
import '../widgets/question_widget.dart'; // question widget
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> _questions = [ 
    Question(
      id: '10', 
      title: 'quanto é 2+2', 
      options: {'5': false, '30': false, '4': true, '3': false}
    ), 
    Question(
      id: '10', 
      title: 'quanto é 20+20', 
      options: {'5': false, '30': false, '40': true, '3': false}
    ), 
  ];




  
  int index = 0;

  int score = 0;

  // a bloeana que faz verificação das questões
  bool isPressed = false;



  void nextQuestion() {
    if(index == _questions.length -1) {
      return;
    } else {
      if (isPressed){
        setState(() {
        index++; // mudando o index pra 1
        isPressed = false;
      });
     }   else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('selecione uma questão'), 
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
     }
    }
  }

// função pra mudar a cor quando clicar na opção
void changeColor() {
  setState(() {
    isPressed = true;
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // changing background
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(padding: const EdgeInsets.all(18.0), child: Text('Score: $score'),),
        ],
      ),
      body: Container( 
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            // adicionar o QuestionWidget aqui
            QuestionWidget(
              indexAction: index,
              questions: _questions[index].title, // primeira questão da lista
              totalQuestions: _questions.length, // tamanho da lista
            ),
            const Divider(color: neutral),
            //adicionar espaços
            const SizedBox(height: 25.0,),
            for (int i =0; i < _questions[index].options.length; i++)
              OptionCard(option: _questions[index].options.keys.toList()[i],
              color: isPressed 
                 ? _questions[index].options.values.toList()[i] == true 
                   ? correct
                    : incorrect 
                  : neutral,
              onTap: changeColor,
              
              ),
        

          ],
        ),
      ), 
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion,
        ),
      ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
