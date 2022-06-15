import 'package:flutter/material.dart';

GestureDetector musiclist(song,/*  {String? title, bool? played, String? duration} */) {
  return GestureDetector(
      onTap: () {},
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              song['title']!,
              style: TextStyle(
                color: song['played'] ? Colors.blue : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Text(
                  song['duration'],
                  style: TextStyle(
                    color: song['played'] ? Colors.blue : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.more_vert,
                  color: song['played'] ? Colors.blue : Colors.grey,
                )
              ],
            )
          ],
        ),
      ));
}
