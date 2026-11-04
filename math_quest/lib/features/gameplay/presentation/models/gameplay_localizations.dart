import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/l10n/app_localizations.dart';

String localizedOperationName(AppLocalizations l10n, MathOperation operation) =>
    switch (operation) {
      MathOperation.addition => l10n.operationAddition,
      MathOperation.subtraction => l10n.operationSubtraction,
      MathOperation.multiplication => l10n.operationMultiplication,
      MathOperation.division => l10n.operationDivision,
    };

String localizedAdventureWorld(AppLocalizations l10n, String name) {
  for (final suffix in _worldSuffixes) {
    if (name.endsWith(' $suffix')) {
      final prefix = name.substring(0, name.length - suffix.length - 1);
      if (!_worldParts.containsKey(prefix)) return name;
      return l10n.adventureIslandName(
        l10n.adventureNamePart(_worldParts[prefix]!, prefix),
        l10n.adventureNamePart(_worldParts[suffix]!, suffix),
      );
    }
  }
  return name;
}

String localizedAdventureLandmark(AppLocalizations l10n, String name) =>
    l10n.adventureLandmark(_landmarks[name] ?? name, name);

String localizedPlayerName(AppLocalizations l10n, String name) =>
    switch (name) {
      'Player 1' => l10n.playerOne,
      'Player 2' => l10n.playerTwo,
      _ => name,
    };

const _worldParts = <String, String>{
  'Emerald': 'p0',
  'Sunny': 'p1',
  'Whispering': 'p2',
  'Verdant': 'p3',
  'Golden': 'p4',
  'Atoll': 'p5',
  'Island': 'p6',
  'Shores': 'p7',
  'Meadow': 'p8',
  'Haven': 'p9',
  'Sugarplum': 'p10',
  'Cotton Candy': 'p11',
  'Lollipop': 'p12',
  'Caramel': 'p13',
  'Sweet': 'p14',
  'Canyon': 'p15',
  'Isle': 'p16',
  'Reef': 'p17',
  'Lagoon': 'p18',
  'Kingdom': 'p19',
  'Prehistoric': 'p20',
  'Thunder': 'p21',
  'Jurassic': 'p22',
  'Amber': 'p23',
  'Ancient': 'p24',
  'Jungle': 'p25',
  'Crag': 'p26',
  'Wilds': 'p27',
  'Sanctuary': 'p28',
  'Astral': 'p29',
  'Starfall': 'p30',
  'Starlight': 'p31',
  'Galactic': 'p32',
  'Cosmic': 'p33',
  'Summit': 'p34',
  'Archipelago': 'p35',
  'Peaks': 'p36',
  'Nebula': 'p37',
  'Spire': 'p38',
  'Sunken': 'p39',
  'Azure': 'p40',
  'Tidal': 'p41',
  'Sapphire': 'p42',
  'Aquamarine': 'p43',
  'Cove': 'p44',
  'Cay': 'p45',
  'Abyss': 'p46',
  'Deep': 'p47',
};
const _worldSuffixes = <String>[
  'Atoll',
  'Island',
  'Shores',
  'Meadow',
  'Haven',
  'Canyon',
  'Isle',
  'Reef',
  'Lagoon',
  'Kingdom',
  'Jungle',
  'Crag',
  'Wilds',
  'Sanctuary',
  'Summit',
  'Archipelago',
  'Peaks',
  'Nebula',
  'Spire',
  'Cove',
  'Cay',
  'Abyss',
  'Deep',
];
const _landmarks = <String, String>{
  'Pebble Beach': 's0',
  'Bamboo Grove': 's1',
  'Clover Valley': 's2',
  'Waterfall Ridge': 's3',
  'Golem’s Fortress': 's4',
  'Gummy Shore': 's5',
  'Marshmallow Trail': 's6',
  'Chocolate River': 's7',
  'Lollipop Peak': 's8',
  'Dragon’s Candy Keep': 's9',
  'Fossil Beach': 's10',
  'Fern Canopy': 's11',
  'Raptor Ravine': 's12',
  'Volcano Foothills': 's13',
  'T-Rex Throne Room': 's14',
  'Stardust Basin': 's15',
  'Meteor Bridge': 's16',
  'Aurora Ridge': 's17',
  'Gravity Well': 's18',
  'Titan’s Observatory': 's19',
  'Clownfish Cove': 's20',
  'Shell Cavern': 's21',
  'Sunken Galleon': 's22',
  'Pearl Trench': 's23',
  'Kraken’s Sunken Lair': 's24',
  'Stone Golem': 's25',
  'Sugar Dragon': 's26',
  'T-Rex Math King': 's27',
  'Star Titan': 's28',
  'Kraken Lord': 's29',
};
