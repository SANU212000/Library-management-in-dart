
class Member {
  String name;
  String memberId;
  List<String> borrowedBooks;

  Member({
    required this.name,
    required this.memberId,
    this.borrowedBooks = const [],
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      memberId: json['memberId'],
      borrowedBooks: List<String>.from(json['borrowedBooks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'memberId': memberId,
      'borrowedBooks': borrowedBooks,
    };
  }

  @override
  String toString() {
    return 'Member: $name, ID: $memberId, Borrowed Books: ${borrowedBooks.join(', ')}';
  }
}
