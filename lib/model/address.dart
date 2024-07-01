class Address {
  List<String> states = [
    'Selangor',
    'Johor',
    'Negeri Sembilan',
    'Melaka',
    'Pahang',
    'Terengganu',
    'Kedah',
    'Kelantan',
    'Perak',
    'Sabah',
    'Sarawak',
    'Pulau Pinang',
    'Perlis',
  ];
  Map<String, List<String>> cityMap = {
    'Selangor': ['Gombak', 'Hulu Langat', 'Hulu Selangor', 'Kuala Langat'],
    'Johor': ['Kluang', 'Johor Bahru', 'Batu Pahat'],
    'Negeri Sembilan': ['Seremban'],
    'Melaka': ['Bandar Melaka'],
    'Pahang': ['Kuantan'],
    'Terengganu': ['Kuala Terengganu'],
    'Kedah': ['Alor Setar'],
    'Kelantan': ['Kota Bharu'],
    'Perak': ['Ipoh'],
    'Sabah': ['Kota Kinabalu'],
    'Sarawak': ['Kuching'],
    'Pulau Pinang': ['George Town'],
    'Perlis': ['Kangar'],
    // Add more states and cities as needed
  };
}
