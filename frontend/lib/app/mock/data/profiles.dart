import 'package:theology_bot/app/features/profile/domain/profile.dart';

final Profile userProfile = Profile(
  id: 'user',
  name: 'You',
  profileImageUrl: '',
  profileThumbnail: '',
  status: 'None',
);

final Profile defaultProfile = Profile(
  boxId: 0,
  id: 'default',
  name: 'General',
  profileImageUrl: 'https://www.walkthru.org/wp-content/uploads/Bible-reading-4-1024x683.jpg',
  profileThumbnail: 'https://www.walkthru.org/wp-content/uploads/Bible-reading-4-1024x683.jpg',
  status: 'Here to help',
);

final Profile profile1 = Profile(
  id: 'aquinas',
  name: 'St. Thomas Aquinas',
  profileImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0a/St-thomas-aquinasFXD.jpg',
  profileThumbnail: 'https://upload.wikimedia.org/wikipedia/commons/0/0a/St-thomas-aquinasFXD.jpg',
  status: '',
);
final Profile profile2 = Profile(
  id: 'smith',
  name: 'Jane Smith',
  profileImageUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
  profileThumbnail: 'https://randomuser.me/api/portraits/thumb/women/2.jpg',
  status: 'Carpe Diem!',
);
final Profile profile3 = Profile(
  id: 'johnson',
  name: 'Alice Johnson',
  profileImageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
  profileThumbnail: 'https://randomuser.me/api/portraits/thumb/women/3.jpg',
  status: 'Exploring the world!',
);
final Profile profile4 = Profile(
  id: 'brown',
  name: 'Bob Brown',
  profileImageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
  profileThumbnail: 'https://randomuser.me/api/portraits/thumb/men/4.jpg',
  status: 'Coding is life!',
);

final List<Profile> mockProfiles = [
  defaultProfile,
  profile1,
  profile2,
  profile3,
  profile4,
];
