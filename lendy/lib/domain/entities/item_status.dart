enum ItemStatus {
  lent('lent'),
  returned('returned');

  final String value;
  const ItemStatus(this.value);

  static ItemStatus fromString(String value) {
    return ItemStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ItemStatus.lent,
    );
  }
}

