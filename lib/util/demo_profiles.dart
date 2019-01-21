final List<Profile> demoProfiles = [
  Profile(
    photos: [
      'asset/taylor1.jpg',
      'asset/taylor2.jpg',
      'asset/taylor3.jpg',
    ],
    firstName: 'Taylor',
    lastName: 'Swift',
    bio: 'American singer-songwriter',
    age: 29,
    gender: false,
    hot: true,
    favorite: true,
  ),
  Profile(
    photos: [
      'asset/david3.jpg',
      'asset/david1.jpg',
      'asset/david2.jpg',
    ],
    firstName: 'David',
    lastName: 'Beckham',
    bio: 'English footballer',
    age: 43,
    gender: true,
    favorite: true,
    hot: false,
  ),
];

class Profile {
  final List<String> photos;
  final String firstName;
  final String lastName;
  final String bio;
  final int age;
  final bool gender;
  final bool hot;
  final bool favorite;
  String name = "";

  Profile({
    this.photos,
    this.firstName,
    this.lastName,
    this.bio,
    this.age,
    this.gender,
    this.favorite,
    this.hot,
  }) {
    this.name = this.firstName + " " + this.lastName;
  }
}
