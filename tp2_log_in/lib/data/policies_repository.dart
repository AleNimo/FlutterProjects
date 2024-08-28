import 'package:tp2_log_in/domain/policy.dart';

final policyList = [
  Policy(
    id: '1',
    name: 'Accel Policy',
    description: 'Penalized for Acceleration',
    date: '30/08/2024',
    trainedEpisodes: 5500,
  ),
  Policy(
      id: '2',
      name: 'Energy Policy',
      description: 'Energy efficient',
      date: '30/08/2024',
      trainedEpisodes: 4600,
      imageURL:
          'https://lamphq.com/wp-content/uploads/brightest-light-bulbs-on-the-market-948x632.jpg'),
  Policy(
    id: '3',
    name: 'Accel Policy V2',
    description: 'Acceleration Reward',
    date: '30/08/2024',
    trainedEpisodes: 2200,
  ),
  Policy(
    id: '4',
    name: 'Energy Policy V2',
    description: 'Acceleration Reward',
    date: '30/08/2024',
    trainedEpisodes: 1500,
  ),
];
