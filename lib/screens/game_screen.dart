import 'package:advanced_tic_tac_toe/providers/settings_provider.dart';
import 'package:advanced_tic_tac_toe/services/ad_service.dart';
import 'package:advanced_tic_tac_toe/models/game_history_entry.dart';
import 'package:advanced_tic_tac_toe/services/history_service.dart';
import 'package:advanced_tic_tac_toe/services/sound_service.dart';
import 'package:advanced_tic_tac_toe/utils/ai_logic.dart';
import 'package:advanced_tic_tac_toe/utils/enums.dart';
import 'package:advanced_tic_tac_toe/utils/game_logic.dart';
import 'package:advanced_tic_tac_toe/widgets/score_board.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final AiDifficulty? aiDifficulty;
  const GameScreen({super.key, required this.gameMode, this.aiDifficulty});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // --- State Variables ---
  late int _gridSize; // This will hold the grid size for the current game.
  late List<String> _board;
  late bool _isPlayerXTurn;
  String? _winner;
  int _scoreX = 0;
  int _scoreO = 0;
  int _gamesPlayed = 0;

  // --- Ad Service & State ---
  final AdService _adService = AdService();
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    // --- CRITICAL FIX ---
    // Read the grid size from the provider ONCE when the screen is first created.
    // This ensures that when a new game is started from the home screen,
    // it uses the latest value from the settings.
    _gridSize = Provider.of<SettingsProvider>(context, listen: false).gridSize;

    // Now initialize the game with the correct size.
    _initializeGame();

    _adService.loadInterstitialAd();
    _adService.loadRewardedAd();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _bannerAd = ad as BannerAd),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  /// Initializes the game board based on the _gridSize.
  void _initializeGame() {
    setState(() {
      _board = List.filled(_gridSize * _gridSize, '');
      _isPlayerXTurn = true;
      _winner = null;
    });
  }

  /// Resets the game board for a new round.
  void _resetGame() {
    _initializeGame();
  }

  void _onTileTapped(int index) {
    if (_board[index].isNotEmpty || _winner != null) return;
    SoundService.playClickSound();
    setState(() {
      _board[index] = _isPlayerXTurn ? 'X' : 'O';
      _isPlayerXTurn = !_isPlayerXTurn;
      _checkWinner();
    });
    if (_winner == null && widget.gameMode == GameMode.vsAI && !_isPlayerXTurn) {
      _makeAIMove();
    }
  }

  /// Checks for a winner using the current _gridSize.
  void _checkWinner() {
    String? winner = GameLogic.checkWinner(_board, _gridSize);
    if (winner != null) {
      setState(() => _winner = winner);
      _saveGameAndShowDialog();
    }
  }

  /// Makes the AI move using the current _gridSize.
  void _makeAIMove() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_winner != null) return;
      int bestMove = AILogic.getMove(List.from(_board), widget.aiDifficulty!, _gridSize);
      if (bestMove != -1) {
        setState(() {
          _board[bestMove] = 'O';
          _isPlayerXTurn = true;
          _checkWinner();
        });
      }
    });
  }

  void _saveGameAndShowDialog() {
    _gamesPlayed++;
    if (_gamesPlayed % 3 == 0) {
      _adService.showInterstitialAd();
    }
    // ... (rest of the saving and dialog logic is the same)
    final entry = GameHistoryEntry(winner: _winner == 'draw' ? 'Draw' : _winner!, timestamp: DateTime.now(), gameMode: widget.gameMode, aiDifficulty: widget.aiDifficulty);
    HistoryService.addEntry(entry);
    if (_winner == 'X') _scoreX++;
    if (_winner == 'O') _scoreO++;
    if (_winner == 'draw') SoundService.playDrawSound(); else SoundService.playWinSound();
    showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(title: Center(child: Text(_winner == 'draw' ? "It's a Draw!" : "$_winner Wins!", style: TextStyle(color: _winner == 'X' ? Theme.of(context).colorScheme.primary : (_winner == 'O' ? Theme.of(context).colorScheme.secondary : null), fontWeight: FontWeight.bold, fontSize: 28))), actions: [TextButton(onPressed: () {Navigator.of(context).pop(); _resetGame();}, child: const Text('Play Again'))]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle())),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScoreBoard(scoreX: _scoreX, scoreO: _scoreO),
                      const SizedBox(height: 20),
                      _buildGameBoardWithLines(),
                      const SizedBox(height: 20),
                      _buildTurnIndicator(),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.movie),
                        label: const Text("Reset Score (Watch Ad)"),
                        onPressed: () => _adService.showRewardedAd(onReward: () => setState(() { _scoreX = 0; _scoreO = 0; })),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_bannerAd != null)
            Container(alignment: Alignment.center, width: _bannerAd!.size.width.toDouble(), height: _bannerAd!.size.height.toDouble(), child: AdWidget(ad: _bannerAd!)),
        ],
      ),
    );
  }

  /// Builds the game board UI using the current _gridSize.
  Widget _buildGameBoardWithLines() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          GridView.builder(
            itemCount: _gridSize * _gridSize,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _gridSize),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _onTileTapped(index),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(_board[index], style: TextStyle(fontSize: 320 / (_gridSize * 2), fontWeight: FontWeight.bold, color: _board[index] == 'X' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary)),
                ),
              ),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;
            final double strokeWidth = 5.0;
            final Color lineColor = Theme.of(context).colorScheme.onBackground.withOpacity(0.5);
            List<Widget> lines = [];
            for (int i = 1; i < _gridSize; i++) {
              lines.add(Positioned(left: width * i / _gridSize - strokeWidth / 2, top: 0, bottom: 0, child: Container(width: strokeWidth, color: lineColor)));
              lines.add(Positioned(top: height * i / _gridSize - strokeWidth / 2, left: 0, right: 0, child: Container(height: strokeWidth, color: lineColor)));
            }
            return Stack(children: lines);
          }),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator() {
    if (_winner != null) return Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_winner == 'draw' ? 'Game Over' : 'Winner!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(width: 10), _winner == 'draw' ? const Icon(Icons.handshake, size: 30) : Text(_winner!, style: TextStyle(fontSize: 30, color: _winner == 'X' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold))]);
    return Text('Turn: ${_isPlayerXTurn ? "X" : "O"}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }

  String _getAppBarTitle() {
    if (widget.gameMode == GameMode.vsPlayer) return 'Player vs Player ($_gridSize x $_gridSize)';
    String diffText = widget.aiDifficulty.toString().split('.').last;
    diffText = diffText[0].toUpperCase() + diffText.substring(1);
    return 'You vs AI ($diffText)';
  }
}