import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splity/features/groups/domain/entities/group.dart';
import 'package:splity/features/groups/domain/usecases/create_group.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late CreateGroup createGroup;
  late MockGroupRepository mockRepository;

  // Register fallback values ONCE before all tests
  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockGroupRepository();
    createGroup = CreateGroup(mockRepository);

    when(() => mockRepository.createGroup(any())).thenAnswer((
      invocation,
    ) async {
      return invocation.positionalArguments[0] as Group;
    });
  });

  // ================================================================
  // VALID GROUP CREATION
  // ================================================================
  group('Valid Group Creation', () {
    test('should create group with valid name and members', () async {
      final group = createTestGroup();

      final result = await createGroup(group);

      expect(result.name, 'Test Group');
      expect(result.members.length, 3);
      verify(() => mockRepository.createGroup(any())).called(1);
    });

    test('should trim whitespace from group name', () async {
      final group = createTestGroup(name: '  Goa Trip  ');

      final result = await createGroup(group);

      expect(result.name, 'Goa Trip');
    });

    test('should trim whitespace from member names', () async {
      final group = createTestGroup(
        members: ['  Alice  ', '  Bob  ', '  Carol  '],
      );

      final result = await createGroup(group);

      expect(result.members, ['Alice', 'Bob', 'Carol']);
    });

    test('should trim whitespace from description', () async {
      final group = createTestGroup(description: '  Weekend trip  ');

      final result = await createGroup(group);

      expect(result.description, 'Weekend trip');
    });

    test('should create group with exactly 2 members', () async {
      final group = createTestGroup(members: ['Alice', 'Bob']);

      final result = await createGroup(group);

      expect(result.members.length, 2);
    });

    test('should create group with many members', () async {
      final group = createTestGroup(
        members: ['Alice', 'Bob', 'Carol', 'Dave', 'Eve'],
      );

      final result = await createGroup(group);

      expect(result.members.length, 5);
    });
  });

  // ================================================================
  // VALIDATION — GROUP NAME
  // ================================================================
  group('Validation — Group Name', () {
    test('should throw ArgumentError when name is empty', () async {
      final group = createTestGroup(name: '');

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });

    test('should throw ArgumentError when name is only whitespace', () async {
      final group = createTestGroup(name: '   ');

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });
  });

  // ================================================================
  // VALIDATION — MEMBERS
  // ================================================================
  group('Validation — Members', () {
    test('should throw ArgumentError when only 1 member', () async {
      final group = createTestGroup(members: ['Alice']);

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });

    test('should throw ArgumentError when no members', () async {
      final group = createTestGroup(members: []);

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });

    test('should throw ArgumentError when member name is empty', () async {
      final group = createTestGroup(members: ['Alice', '']);

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });

    test('should throw ArgumentError when member name is whitespace', () async {
      final group = createTestGroup(members: ['Alice', '   ']);

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });

    test('should throw ArgumentError when duplicate member names', () async {
      final group = createTestGroup(members: ['Alice', 'Bob', 'alice']);

      expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.createGroup(any()));
    });

    test(
      'should throw ArgumentError for case-insensitive duplicates',
      () async {
        final group = createTestGroup(members: ['Alice', 'ALICE']);

        expect(() => createGroup(group), throwsA(isA<ArgumentError>()));
        verifyNever(() => mockRepository.createGroup(any()));
      },
    );
  });

  // ================================================================
  // REPOSITORY INTERACTION
  // ================================================================
  group('Repository Interaction', () {
    test('should call repository exactly once on success', () async {
      final group = createTestGroup();

      await createGroup(group);

      verify(() => mockRepository.createGroup(any())).called(1);
    });

    test('should not call repository when validation fails', () async {
      final group = createTestGroup(name: '');

      try {
        await createGroup(group);
      } catch (_) {}

      verifyNever(() => mockRepository.createGroup(any()));
    });

    test('should propagate repository exceptions', () async {
      when(
        () => mockRepository.createGroup(any()),
      ).thenThrow(Exception('Storage error'));

      final group = createTestGroup();

      expect(() => createGroup(group), throwsA(isA<Exception>()));
    });
  });
}
