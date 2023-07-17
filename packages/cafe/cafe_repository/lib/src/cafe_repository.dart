import 'package:cafe_api/cafe_api.dart';

import 'cafe_owner_repository.dart';
import 'cafe_user_repository.dart';

class CafeRepository {
  CafeRepository({
    required CafeUserApi cafeUserApi,
    required CafeOwnerApi cafeOwnerApi,
  })  : _cafeUserRepository = CafeUserRepository(cafeApi: cafeUserApi),
        _cafeOwnerRepository = CafeOwnerRepository(cafeApi: cafeOwnerApi);

  final CafeUserRepository _cafeUserRepository;

  final CafeOwnerRepository _cafeOwnerRepository;

  CafeUserRepository get user => _cafeUserRepository;

  CafeOwnerRepository get owner => _cafeOwnerRepository;
}
