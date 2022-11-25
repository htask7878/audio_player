import 'package:audio_player/second.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  OnAudioQuery audioQuery = OnAudioQuery();

  permission() async {
    var status = await Permission.storage.status;
    print(status);
    if (status.isDenied) {
      await Permission.storage.request().isGranted;
      setState(() {});
    } else {
      print("permission already granted");
    }
  }
//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
  @override
  void initState() {
    super.initState();
    permission();
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

  Future<List<SongModel>> getSong() async {
    List<SongModel> allSongList = await audioQuery.querySongs();
    return allSongList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio_List"),
      ),
      body: FutureBuilder(
        future: getSong(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> list = snapshot.data as List<SongModel>;
            print(list);
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                // SongModel sm = list[index];
                print(list[index].title);
                return ListTile(
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return second(list, index);
                        },
                      ));
                  },
                  title: Text("${list[index].title}"),
                  subtitle: Text(printDuration(Duration(
                      milliseconds: list[index].duration!.toInt()))), //
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
