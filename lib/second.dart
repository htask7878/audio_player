import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';

class second extends StatefulWidget {
  List<SongModel> list;
  int index;

  second(this.list, this.index);

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  PageController pagecontroller = PageController();
  bool isPlaying = false;
  Duration duration1 = Duration.zero;
  double position = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  String path = "";

  @override
  void initState() {
    super.initState();
    pagecontroller = PageController(initialPage: widget.index);
    test();
    // audioPlayer.onPlayerStateChanged.listen((state) {
    //   setState(() {
    //     isPlaying = state == PlayerState.playing;
    //   });
    // });
    // audioPlayer.onDurationChanged.listen((newDuration) {
    //   setState(() {
    //     duration1 = newDuration;
    //   });
    // });
  }

  test() {
    audioPlayer.onPositionChanged.listen((Duration p) {
      print("P=$p");
      setState(() {
        position = p.inMilliseconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                await audioPlayer.pause();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 25, right: 25),
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() async {
                    widget.index = value;
                    await audioPlayer.pause();
                    position = 0;
                  });
                },
                controller: pagecontroller,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: Text("${widget.list[widget.index].title}"));
                },
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text("${widget.list[widget.index].displayName}"),
          SizedBox(
            height: 15,
          ),
          Slider(
            onChanged: (value) async {
              await audioPlayer.seek(Duration(milliseconds: value.toInt()));
              await audioPlayer.resume();
            },
            min: 0,
            max: widget.list[widget.index].duration!.toDouble(),
            value: position.toDouble(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "+ ${printDuration(Duration(milliseconds: position.toInt()))}"),
                Text(
                    "- ${printDuration(Duration(milliseconds: widget.list[widget.index].duration!.toInt()) - Duration(milliseconds: position.toInt()))}"),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          BottomAppBar(
            color: Colors.pink,
            elevation: 10,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: IconButton(
                        onPressed: () async {

                          await audioPlayer.pause();
                          if (widget.index > 0) {
                            widget.index--;
                            position = 0;
                            path = "${widget.list[widget.index].data}";
                            await audioPlayer.play(DeviceFileSource(path));
                          } else {
                            widget.list.length - 1;
                            position = 0;
                            path = "${widget.list[widget.index].data}";
                            await audioPlayer.play(DeviceFileSource(path));
                          }
                          pagecontroller.previousPage(
                              duration: Duration(microseconds: 200),
                              curve: Curves.easeInCubic);
                          setState(() {});
                          pagecontroller.animateToPage(widget.index,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInCubic);
                        },
                        icon: Icon(size: 30, Icons.skip_previous)),
                  ),
                  CircleAvatar(
                    radius: 24,
                    child: IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            print("pause");
                          } else {
                            path = "${widget.list[widget.index].data}";
                            await audioPlayer.play(DeviceFileSource(path));
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                  ),
                  CircleAvatar(
                    radius: 24,
                    child: IconButton(
                        onPressed: () async {
                          await audioPlayer.pause();
                          if (widget.index < widget.list.length - 1) {
                            widget.index++;
                            position = 0;
                            path = "${widget.list[widget.index].data}";
                            await audioPlayer.play(DeviceFileSource(path));
                          } else {
                            widget.index = 0;
                            position = 0;
                            path = "${widget.list[widget.index].data}";
                            await audioPlayer.play(DeviceFileSource(path));
                          }
                          pagecontroller.nextPage(
                              duration: Duration(microseconds: 200),
                              curve: Curves.easeInCubic);
                          setState(() {});
                          pagecontroller.animateToPage(widget.index,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInCubic);
                        },
                        icon: Icon(size: 30, Icons.skip_next)),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }











}
