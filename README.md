# Splity — Smart Bill Splitter

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.29.3-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.7.2-blue?logo=dart" />
  <img src="https://img.shields.io/badge/Riverpod-2.x-purple" />
  <img src="https://img.shields.io/badge/Architecture-Clean-green" />
  <img src="https://img.shields.io/badge/Storage-Hive-orange" />
  <img src="https://img.shields.io/badge/License-MIT-yellow" />
</p>

<p align="center">
  A production-grade Flutter app to split bills smartly among friends and groups.
  Built with Clean Architecture, Riverpod, and Hive — works 100% offline.
</p>

---

## Screenshots

> Coming soon — will be added after UI is complete.

---

## Features

- **Group Management** — Create groups, add members
- **Expense Tracking** — Add expenses with categories
- **Smart Split** — Equal and unequal split options
- **Settlement Algorithm** — Minimizes number of transactions to settle debts
- **Balance Summary** — See who owes whom at a glance
- **Charts** — Visual balance breakdown with FL Chart
- **Transaction History** — Full history of all expenses
- **Share Summary** — Share settlement via WhatsApp/SMS
- **Dark & Light Theme** — Fully themed UI
- **100% Offline** — No backend, no internet required

---

## Architecture

This project follows **Clean Architecture** with three layers:

    lib/
    ├── core/
    │   ├── constants/
    │   ├── errors/
    │   ├── extensions/
    │   ├── theme/
    │   ├── utils/
    │   └── widgets/
    ├── features/
    │   ├── groups/
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   ├── models/
    │   │   │   └── repositories/
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   ├── repositories/
    │   │   │   └── usecases/
    │   │   └── presentation/
    │   │       ├── providers/
    │   │       ├── screens/
    │   │       └── widgets/
    │   ├── expenses/
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   ├── models/
    │   │   │   └── repositories/
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   ├── repositories/
    │   │   │   └── usecases/
    │   │   └── presentation/
    │   │       ├── providers/
    │   │       ├── screens/
    │   │       └── widgets/
    │   └── settlement/
    │       ├── data/
    │       │   ├── datasources/
    │       │   ├── models/
    │       │   └── repositories/
    │       ├── domain/
    │       │   ├── entities/
    │       │   ├── repositories/
    │       │   └── usecases/
    │       └── presentation/
    │           ├── providers/
    │           ├── screens/
    │           └── widgets/
    └── main.dart

    test/
    ├── features/
    │   ├── groups/
    │   ├── expenses/
    │   └── settlement/
    └── helpers/

---

## Settlement Algorithm

The core of Splity is a **debt minimization algorithm** that reduces the
number of transactions needed to settle all debts within a group.

**Example:**

    Alice owes Bob $10
    Bob owes Charlie $10
    → Instead of 2 transactions, algorithm finds:
    → Alice pays Charlie $10 (1 transaction only)

The algorithm uses a **greedy approach with net balance calculation**:

1. Calculate net balance for each person
2. Separate into creditors (positive) and debtors (negative)
3. Greedily match largest debtor with largest creditor
4. Repeat until all balances are zero

---

## Tech Stack

| Technology     | Purpose                |
|----------------|------------------------|
| Flutter 3.29.3 | UI Framework           |
| Dart 3.7.2     | Programming Language   |
| Riverpod 2.x   | State Management       |
| GoRouter       | Navigation             |
| Hive           | Local Database         |
| Freezed        | Immutable Models       |
| FL Chart       | Charts & Visualization |
| share_plus     | Share Summary          |
| intl           | Currency Formatting    |

---

## Getting Started

### Prerequisites

- Flutter 3.29.3+
- Dart 3.7.2+
- Android Studio / VS Code

### Installation

Clone the repository:

    git clone https://github.com/thapa52/splity.git

Navigate to project:

    cd splity

Install dependencies:

    flutter pub get

Run code generation:

    dart run build_runner build --delete-conflicting-outputs

Run the app:

    flutter run

---

## Git Workflow

Branch strategy:

    main          ← production ready
      └── develop ← integration branch
            └── feature/xxx  ← one branch per feature

**Commit Convention:**

| Prefix       | When to Use                          |
|--------------|--------------------------------------|
| `feat:`      | New feature added                    |
| `fix:`       | Bug fix                              |
| `chore:`     | Setup, config, tooling               |
| `docs:`      | Documentation changes                |
| `test:`      | Adding or updating tests             |
| `refactor:`  | Code restructure, no behavior change |
| `style:`     | Formatting, linting                  |

---

## Testing

Run all tests:

    flutter test

Run with coverage:

    flutter test --coverage

**Key test areas:**

- Settlement algorithm (edge cases)
- Split calculation logic
- Balance summary calculation
- Repository layer with fake implementations

---

## Project Structure

    lib/
    ├── core/
    │   ├── constants/        # App-wide constants
    │   ├── errors/           # Failure classes, error handling
    │   ├── theme/            # Light & dark theme
    │   ├── utils/            # Helper functions, extensions
    │   └── widgets/          # Reusable shared widgets
    ├── features/
    │   ├── groups/           # Group management feature
    │   ├── expenses/         # Expense tracking feature
    │   └── settlement/       # Settlement algorithm & summary
    └── main.dart

---

## Milestones

- [x] Project setup & Git workflow
- [x] README & documentation
- [x] Folder structure & dependencies
- [x] Core theme & navigation
- [x] Group management feature
- [x] Expense tracking feature
- [x] Settlement algorithm
- [ ] Balance summary & charts
- [ ] Share summary feature
- [ ] Unit tests
- [ ] UI polish & animations

---

## Contributing

This is a portfolio project. Feel free to fork it and build on top of it.
If you find a bug or have a suggestion, open an issue.

---

## Author

**Pradeep Thapa**

- GitHub: [@thapa52](https://github.com/thapa52)

---

## License

This project is licensed under the MIT License.
See the [LICENSE](LICENSE) file for details.