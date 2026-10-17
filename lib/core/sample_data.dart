import '../data/models/destination.dart';

const String imgPath = 'assets/images';

const List<String> destinationCategories = [
  'All',
  'Beach',
  'Mountains',
  'Culture',
  'City',
  'Nature',
];

const List<Destination> sampleDestinations = [
  Destination(
    id: 'kyoto',
    name: 'Kyoto',
    country: 'Japan',
    region: 'Kansai',
    category: 'Culture',
    tagline: 'Temples, tea houses and thousand-year-old lanes.',
    description:
        'Once the imperial capital, Kyoto is a living museum of Japan. '
        'Wander between vermilion shrines, moss gardens and wooden machiya '
        'townhouses, then slow down for a bowl of matcha in a quiet tea room. '
        'Autumn turns the hills crimson; spring fills them with blossom.',
    image: '$imgPath/kyoto.jpg',
    rating: 4.9,
    bestSeason: 'Mar–May · Oct–Nov',
    highlights: [
      'Fushimi Inari torii gates',
      'Arashiyama bamboo grove',
      'Gion geisha district at dusk',
      'Golden Pavilion (Kinkaku-ji)',
    ],
  ),
  Destination(
    id: 'santorini-oia',
    name: 'Oía',
    country: 'Greece',
    region: 'Cyclades',
    category: 'Beach',
    tagline: 'Whitewashed cliffside sunsets over the Aegean.',
    description:
        'Carved into the caldera rim, Oía is a maze of blue domes and cave '
        'houses tumbling toward the sea. Days drift between swimming coves '
        'and bougainvillea courtyards; evenings gather on the castle ruins '
        'for one of the most celebrated sunsets in the world.',
    image: '$imgPath/santorini-oia.jpg',
    rating: 4.8,
    bestSeason: 'May–Jun · Sep–Oct',
    highlights: [
      'Caldera sunset from the castle',
      'Ammoudi Bay seafood tavernas',
      'Sailing the volcanic islets',
      'Blue-domed churches of Oía',
    ],
  ),
  Destination(
    id: 'machu-picchu',
    name: 'Machu Picchu',
    country: 'Peru',
    region: 'Cusco',
    category: 'Mountains',
    tagline: 'A lost Inca citadel wrapped in cloud forest.',
    description:
        'Perched at 2,430 m between jagged peaks, Machu Picchu is the Andes '
        'at their most theatrical. Arrive at dawn as mist lifts from the '
        'stone terraces, then follow the ridge to the Sun Gate for the '
        'classic view down over the ruins.',
    image: '$imgPath/machu-picchu.jpg',
    rating: 4.9,
    bestSeason: 'May–Sep',
    highlights: [
      'Sunrise from the Sun Gate',
      'Huayna Picchu summit trail',
      'Temple of the Sun',
      'Scenic train from Cusco',
    ],
  ),
  Destination(
    id: 'marrakech',
    name: 'Marrakech',
    country: 'Morocco',
    region: 'Marrakech-Safi',
    category: 'Culture',
    tagline: 'Spice souks, riad courtyards and desert light.',
    description:
        'Marrakech is a feast for the senses — labyrinthine souks, the '
        'call to prayer drifting over terracotta rooftops, and mint tea '
        'poured from a height in a shaded riad. Beyond the medina, the '
        'Atlas Mountains and the Agafay desert wait.',
    image: '$imgPath/marrakech.jpg',
    rating: 4.7,
    bestSeason: 'Mar–May · Oct–Nov',
    highlights: [
      'Jemaa el-Fnaa at night',
      'Bahia Palace tilework',
      'Rooftop dinner in a riad',
      'Day trip to the Agafay desert',
    ],
  ),
  Destination(
    id: 'banff',
    name: 'Lake Louise',
    country: 'Canada',
    region: 'Alberta',
    category: 'Mountains',
    tagline: 'Glacier-fed turquoise water beneath the Rockies.',
    description:
        'Set in Banff National Park, Lake Louise glows an impossible '
        'turquoise against the Victoria Glacier. Hike the shoreline trail, '
        'canoe across still water at first light, or ride the gondola for '
        'a bird\'s-eye view of the valley.',
    image: '$imgPath/banff.jpg',
    rating: 4.9,
    bestSeason: 'Jun–Sep · Jan–Mar',
    highlights: [
      'Canoeing on Lake Louise',
      'Lake Agnes tea house hike',
      'Icefields Parkway drive',
      'Moraine Lake sunrise',
    ],
  ),
  Destination(
    id: 'lisbon',
    name: 'Lisbon',
    country: 'Portugal',
    region: 'Lisboa',
    category: 'City',
    tagline: 'Tiled facades, yellow trams and Atlantic light.',
    description:
        'Built across seven hills above the Tagus, Lisbon rewards slow '
        'wandering. Ride the 28 tram through Alfama, chase miradouros for '
        'sunset views, and end the night with fado and a glass of vinho '
        'verde in a tiled tavern.',
    image: '$imgPath/lisbon.jpg',
    rating: 4.8,
    bestSeason: 'Apr–Jun · Sep–Oct',
    highlights: [
      'Tram 28 through Alfama',
      'Belém tower and pastéis',
      'Miradouros at golden hour',
      'LX Factory markets',
    ],
  ),
  Destination(
    id: 'bali',
    name: 'Ubud',
    country: 'Indonesia',
    region: 'Bali',
    category: 'Nature',
    tagline: 'Emerald rice terraces and misty jungle temples.',
    description:
        'The cultural heart of Bali, Ubud spills down through rice '
        'terraces and river gorges. Mornings are for the market and yoga; '
        'afternoons for waterfalls and temples hidden in the jungle. '
        'Everything moves a little slower here.',
    image: '$imgPath/bali.jpg',
    rating: 4.7,
    bestSeason: 'Apr–Oct',
    highlights: [
      'Tegalalang rice terraces',
      'Sacred Monkey Forest',
      'Tirta Empul water temple',
      'Campuhan Ridge walk',
    ],
  ),
  Destination(
    id: 'reykjavik',
    name: 'Seljalandsfoss',
    country: 'Iceland',
    region: 'South Coast',
    category: 'Nature',
    tagline: 'Waterfalls, black sand and northern lights.',
    description:
        'Iceland\'s south coast feels like another planet — thundering '
        'waterfalls you can walk behind, black-sand beaches and glaciers '
        'spilling toward the sea. In winter, the aurora often performs '
        'right above your head.',
    image: '$imgPath/reykjavik.jpg',
    rating: 4.8,
    bestSeason: 'Jun–Aug · Nov–Mar',
    highlights: [
      'Walk behind Seljalandsfoss',
      'Reynisfjara black-sand beach',
      'Golden Circle geysers',
      'Northern lights hunting',
    ],
  ),
  Destination(
    id: 'petra',
    name: 'Petra',
    country: 'Jordan',
    region: 'Ma\'an',
    category: 'Culture',
    tagline: 'A rose-red city carved into desert cliffs.',
    description:
        'Reached through a narrow sandstone gorge, Petra reveals itself '
        'all at once: the Treasury glowing pink at the end of the siq. '
        'Beyond lie tombs, a Roman theatre and a monastery of 800 steps, '
        'all hewn from living rock.',
    image: '$imgPath/petra.jpg',
    rating: 4.8,
    bestSeason: 'Mar–May · Sep–Nov',
    highlights: [
      'The Treasury at the siq\'s end',
      'Monastery climb (800 steps)',
      'Petra by candlelight',
      'Bedouin tea on the trails',
    ],
  ),
  Destination(
    id: 'chefchaouen',
    name: 'Chefchaouen',
    country: 'Morocco',
    region: 'Rif Mountains',
    category: 'City',
    tagline: 'A hillside medina painted every shade of blue.',
    description:
        'Tucked into the Rif Mountains, Chefchaouen\'s medina is washed '
        'in cobalt and azure. It is small enough to explore without a map '
        '— follow the blue lanes uphill for views, downhill for markets, '
        'and stop often for mint tea.',
    image: '$imgPath/chefchaouen.jpg',
    rating: 4.7,
    bestSeason: 'Apr–Jun · Sep–Nov',
    highlights: [
      'Blue-washed medina lanes',
      'Spanish Mosque viewpoint',
      'Kasbah museum gardens',
      'Rif mountain day hikes',
    ],
  ),
];

Destination destinationById(String id) {
  return sampleDestinations.firstWhere(
    (d) => d.id == id,
    orElse: () => sampleDestinations.first,
  );
}
