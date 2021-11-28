import 'dart:ui';

import "package:flutter/material.dart";

void main(){
  runApp(ShufflePage());
}

class GenericPageLayout extends MaterialApp{
  GenericPageLayout(
      {Key? key,
        String title = "Unnamed",
        required var body,
        required Widget buttons
      }
      ): super(key: key,
    title: title,
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: body,
      floatingActionButton: buttons,
      backgroundColor: Colors.blueAccent,
    ),
  );
}

class ShufflePage extends StatelessWidget{
  String sentence = "";

  ShufflePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: TextField(
          maxLength: 120,
          decoration: const InputDecoration(
            counterStyle: TextStyle(
              color: Colors.white,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.yellow,
                width: 5.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width: 5.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 5.0,
              ),
            ),
            hintText: "Write Here...",
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (text) => sentence = text,
        ),
      ),
    );
    final buttons = Positioned(
      child: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_rounded),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        tooltip: "Proceed to rearrange.",
        onPressed: () => runApp(RearrangePage(sentence)),
      ),
    );
    return GenericPageLayout(
      title: "Shuffle",
      body: body,
      buttons: buttons,
    );
  }
}


class RearrangePage extends StatelessWidget{
  var sentence;

  RearrangePage(this.sentence, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = RearrangeActivity(sentence);
    final buttons = Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 30,
          bottom: 0,
          child: FloatingActionButton(
            child: const Icon(Icons.arrow_back_rounded),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            tooltip: "Back to shuffle.",
            onPressed: () => runApp(ShufflePage()),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            child: const Icon(Icons.help),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            tooltip: "Check.",
            onPressed: (){
              String answer = sentence.replaceAll(" ","");
              bool equal = _DraggableMod.getAnswer() == answer;
              runApp(ResultPage(equal));
            },
          ),
        ),
      ],
    );
    return GenericPageLayout(
        title: "REARRANGE",
        body: body,
        buttons: buttons,
    );
  }
}

class RearrangeActivity extends StatefulWidget{
  var sentence;
  RearrangeActivity(this.sentence, {Key? key}) : super(key: key);
  @override
  State<RearrangeActivity> createState() {
    return _RearrangeState(sentence);
  }

}

class _RearrangeState extends State<RearrangeActivity>{
  var sentence;

  _RearrangeState(this.sentence);

  List<DraggableMod> getBubbles(String sentence){
    List<String> words = sentence.split(" ");
    words.shuffle();
    List<DraggableMod> bubbles = List.empty(
      growable: true,
    );
    for(var i = 0; i < words.length; i++){
      bubbles.add(DraggableMod(words[i]));
    }
    return bubbles;
  }

  List<DragTargetMod> getTargets(){
    List<String> words = sentence.split(" ");
    List<DragTargetMod> targets = List.empty(
      growable: true,
    );
    for(var i = 0; i < words.length; i++){
      targets.add(DragTargetMod());
    }
    return targets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: getTargets(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: getBubbles(sentence),
            ),
          ),
        ),
      ],
    );
  }
}

class DraggableMod extends StatefulWidget{
  var data;
  DraggableMod(this.data);
  @override
  State<DraggableMod> createState() {
    return _DraggableMod(data);
  }
}

class _DraggableMod extends State<DraggableMod>{
  var data;
  bool status = false;
  static String answer = "";
  _DraggableMod(this.data);
  static String getAnswer(){
    return answer;
  }
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: data,
      child: Container(
        color: status? Colors.grey: Colors.white,
        width: 100,
        height: 50,
        child: Center(
          child: Text(
            data,
          ),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        width: 100,
        height: 50,
        child: Center(
          child: Text(
            data,
          ),
        ),
      ),
      feedback: Container(
        color: Colors.black,
        width: 100,
        height: 50,
        child: Center(
          child: Text(
            data,
            style: TextStyle(
              inherit: false,
              color: Colors.white,
            ),
          ),
        ),
      ),
      maxSimultaneousDrags: status? 0:1,
      onDragCompleted: (){
        answer += data;
        setState(() {
          status = !status;
        });
      },
    );
  }
}

class DragTargetMod extends StatefulWidget{
  @override
  State<DragTargetMod> createState() {
    return _DragTargetMod();
  }
}

class _DragTargetMod extends State<DragTargetMod>{
  bool status = false;
  String data = "";
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, List<String?> candidateData, rejectedData) => Container(
        color: status? Colors.white: Colors.grey,
        width: 100,
        height: 50,
        child: Center(
          child: Text(
            data,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      onWillAccept: (data) => !status,
      onAccept: (data) => setState(() {
        status = !status;
        this.data = data;
      }),
    );
  }
}

class ResultPage extends StatelessWidget{
  var correct;
  ResultPage(this.correct);
  @override
  Widget build(BuildContext context) {
    return GenericPageLayout(
      title: "Result",
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            correct? "CORRECT!": "INCORRECT!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      buttons: Positioned(
        child: FloatingActionButton(
          child: const Icon(Icons.home),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          tooltip: "Proceed to rearrange.",
          onPressed: () => runApp(ShufflePage()),
        ),
      )
    );
  }
}