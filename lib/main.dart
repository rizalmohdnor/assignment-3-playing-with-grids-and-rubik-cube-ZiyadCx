import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2x2 Rubik\'s Cube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CubeScreen(),
    );
  }
}

class CubeState {
  List<List<Color>> faces = [
    [Colors.red, Colors.red, Colors.red, Colors.red], // Front
    [Colors.blue, Colors.blue, Colors.blue, Colors.blue], // Left
    [Colors.green, Colors.green, Colors.green, Colors.green], // Right
    [Colors.yellow, Colors.yellow, Colors.yellow, Colors.yellow], // Back
    [Colors.orange, Colors.orange, Colors.orange, Colors.orange], // Top
    [Colors.white, Colors.white, Colors.white, Colors.white], // Bottom
  ];

  void rotateFace(List<Color> face) {
    final temp = List.from(face);
    face[0] = temp[2];
    face[1] = temp[0];
    face[2] = temp[3];
    face[3] = temp[1];
  }

  void rotateTop() {
    rotateFace(faces[4]);
    List<Color> temp = faces[0].sublist(0, 2);
    faces[0].setRange(0, 2, faces[1].sublist(0, 2));
    faces[1].setRange(0, 2, faces[3].sublist(0, 2));
    faces[3].setRange(0, 2, faces[2].sublist(0, 2));
    faces[2].setRange(0, 2, temp);
  }

  void rotateBottom() {
    rotateFace(faces[5]);
    List<Color> temp = faces[0].sublist(2);
    faces[0].setRange(2, 4, faces[2].sublist(2));
    faces[2].setRange(2, 4, faces[3].sublist(2));
    faces[3].setRange(2, 4, faces[1].sublist(2));
    faces[1].setRange(2, 4, temp);
  }

  void rotateLeft() {
    rotateFace(faces[1]);
    List<Color> temp = [faces[0][0], faces[0][2]];
    faces[0][0] = faces[4][0];
    faces[0][2] = faces[4][2];
    faces[4][0] = faces[3][3];
    faces[4][2] = faces[3][1];
    faces[3][3] = faces[5][0];
    faces[3][1] = faces[5][2];
    faces[5][0] = temp[0];
    faces[5][2] = temp[1];
  }

  void rotateRight() {
    rotateFace(faces[2]);
    List<Color> temp = [faces[0][1], faces[0][3]];
    faces[0][1] = faces[5][1];
    faces[0][3] = faces[5][3];
    faces[5][1] = faces[3][2];
    faces[5][3] = faces[3][0];
    faces[3][2] = faces[4][1];
    faces[3][0] = faces[4][3];
    faces[4][1] = temp[0];
    faces[4][3] = temp[1];
  }

  void rotateFront() {
    rotateFace(faces[0]);
    List<Color> temp = [faces[4][2], faces[4][3]];
    faces[4][2] = faces[1][3];
    faces[4][3] = faces[1][1];
    faces[1][3] = faces[5][1];
    faces[1][1] = faces[5][0];
    faces[5][1] = faces[2][0];
    faces[5][0] = faces[2][2];
    faces[2][0] = temp[0];
    faces[2][2] = temp[1];
  }

  void rotateBack() {
    rotateFace(faces[3]);
    List<Color> temp = [faces[4][0], faces[4][1]];
    faces[4][0] = faces[2][3];
    faces[4][1] = faces[2][1];
    faces[2][3] = faces[5][3];
    faces[2][1] = faces[5][2];
    faces[5][3] = faces[1][0];
    faces[5][2] = faces[1][2];
    faces[1][0] = temp[0];
    faces[1][2] = temp[1];
  }
}

class CubeScreen extends StatefulWidget {
  const CubeScreen({Key? key}) : super(key: key);

  @override
  _CubeScreenState createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  CubeState cube = CubeState();

  Widget buildFace(List<Color> faceColors, double size) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        width: size,
        height: size,
        color: faceColors[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double faceSize = screenWidth / 4; // Adjust face size based on screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text('2x2 Rubik\'s Cube'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: faceSize, width: faceSize, child: buildFace(cube.faces[4], faceSize / 2)), // Top Face
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: faceSize, width: faceSize, child: buildFace(cube.faces[1], faceSize / 2)), // Left Face
                SizedBox(height: faceSize, width: faceSize, child: buildFace(cube.faces[0], faceSize / 2)), // Front Face
                SizedBox(height: faceSize, width: faceSize, child: buildFace(cube.faces[2], faceSize / 2)), // Right Face
              ],
            ),
            SizedBox(height: faceSize, width: faceSize, child: buildFace(cube.faces[3], faceSize / 2)), // Back Face
            SizedBox(height: faceSize, width: faceSize, child: buildFace(cube.faces[5], faceSize / 2)), // Bottom Face
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () => setState(cube.rotateTop), child: const Text('Rotate Top')),
                ElevatedButton(onPressed: () => setState(cube.rotateBottom), child: const Text('Rotate Bottom')),
                ElevatedButton(onPressed: () => setState(cube.rotateLeft), child: const Text('Rotate Left')),
                ElevatedButton(onPressed: () => setState(cube.rotateRight), child: const Text('Rotate Right')),
                ElevatedButton(onPressed: () => setState(cube.rotateFront), child: const Text('Rotate Front')),
                ElevatedButton(onPressed: () => setState(cube.rotateBack), child: const Text('Rotate Back')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
