import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RandomRaffleApp(),
    );
  }
}

class RandomRaffleApp extends StatefulWidget {
  const RandomRaffleApp({super.key});

  @override
  _RandomRaffleAppState createState() => _RandomRaffleAppState();
}

class _RandomRaffleAppState extends State<RandomRaffleApp> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  int? _randomNumber;
  bool _isSpinning = false;
  final List<int> _results = [];
  void _spinWheel() async {
    final int? min = int.tryParse(_minController.text);
    final int? max = int.tryParse(_maxController.text);

    if (min == null || max == null || min > max) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Lỗi'),
              content: Text('Hãy nhập khoảng hợp lệ (min <= max).'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    setState(() {
      _isSpinning = true;
    });

    final int totalDuration = 8000; // 10 seconds
    final int interval = 100; // Update every 100ms
    final int iterations = totalDuration ~/ interval;

    for (int i = 0; i < iterations; i++) {
      await Future.delayed(Duration(milliseconds: interval), () {
        setState(() {
          _randomNumber = min + Random().nextInt(max - min + 1);
        });
      });
    }

    setState(() {
      _isSpinning = false;
      // Lưu kết quả vào danh sách _results sau khi quay xong
      _results.add(_randomNumber!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          200.0,
        ), // Điều chỉnh chiều cao của AppBar (ở đây là 200)
        child: AppBar(
          // title: Text('Ứng dụng Vòng Quay'),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/banhxe.png', // Đảm bảo bạn đã thêm hình ảnh vào thư mục assets
            fit: BoxFit.cover, // Làm cho hình ảnh phủ đầy không gian
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'THIẾT LẬP PHẠM VI QUAY  :',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 2, 156, 228),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'min ',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ), // Không có viền khi chưa focus
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 253, 101, 0),
                        ), // Màu viền khi focus
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 2, 156, 228),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'max',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ), // Không có viền khi chưa focus
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 253, 101, 0),
                        ), // Màu viền khi focus
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_randomNumber != null)
              Text(
                _isSpinning
                    ? 'Đang quay: $_randomNumber'
                    : 'Kết quả: $_randomNumber',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isSpinning ? null : _spinWheel,
              child: Text('Quay'),
            ),
            SizedBox(height: 16), // Hiển thị các kết quả đã quay
            if (_results.isNotEmpty)
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // Căn các phần tử trong Column sang bên trái
                children:
                    _results.map((result) {
                      int index = _results.indexOf(result) + 1;
                      Color randomColor = _getRandomColor();
                      return Padding(
                        padding: const EdgeInsets.only(left: 50.0, top: 8.0),
                        child: Align(
                          alignment:
                              Alignment
                                  .centerLeft, // Căn phần tử này về bên trái
                          child: Text(
                            'Lần Quay $index: $result',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: randomColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Random red value (0-255)
      random.nextInt(256), // Random green value (0-255)
      random.nextInt(256), // Random blue value (0-255)
      1, // Alpha value (opacity)
    );
  }
}
