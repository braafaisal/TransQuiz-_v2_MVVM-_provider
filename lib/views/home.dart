import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/game_view_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameViewModel = Provider.of<GameViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.blue,
                  size: 40,
                ),
                onPressed: gameViewModel.resetLevelState,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.png'),
                  radius: 100.0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: gameViewModel.levels.length,
                    itemBuilder: (context, index) {
                      final level = gameViewModel.levels[index];
                      return Card(
                        color: level.color,
                        child: ListTile(
                          title: Text(level.name),
                          trailing: gameViewModel.levelUnlocked[index]
                              ? Icon(Icons.lock_open, color: Colors.white)
                              : Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                  size: 25,
                                ),
                          onTap: () => gameViewModel.goToGame(context, level),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
