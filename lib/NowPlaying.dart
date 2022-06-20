import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  NowPlaying({Key? key, required this.songModel, required this.audioPlayer})
      : super(key: key);
  final AudioPlayer audioPlayer;
  final SongModel songModel;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.songModel.uri!),
        ),
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      log("Cannot parse song");
    }
    widget.audioPlayer.durationStream.listen(
      (d) {
        setState(() {
          _duration = d!;
        });
      },
    );
    widget.audioPlayer.positionStream.listen(
      (p) {
        setState(() {
          _duration = p;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: Icon(
                      Icons.music_note,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    widget.songModel.displayNameWOExt,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    widget.songModel.artistId.toString() == "<unknown>"
                        ? "Unknown Artist"
                        : widget.songModel.artistId.toString(),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(_position.toString().split(".")[0]),
                      Expanded(
                        child: Slider(
                          min: Duration(microseconds: 0).inSeconds.toDouble(),
                          value: _position.inSeconds.toDouble(),
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              changeToSeconds(value.toInt());
                              value = value;
                            });
                          },
                        ),
                      ),
                      Text(_duration.toString().split(".")[0]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.skip_previous,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_isPlaying) {
                              widget.audioPlayer.pause();
                            } else {
                              widget.audioPlayer.play();
                            }
                            _isPlaying = !_isPlaying;
                          });
                        },
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.skip_next,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
