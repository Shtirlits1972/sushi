class DataResult<T> {
  bool isError = false;
  String message = '';
  T? model = null;

  @override
  String toString() {
    return 'DataResult { isError = $isError, message = $message, model = $model }';
  }
}
