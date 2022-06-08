// ignore: one_member_abstracts
abstract class Decodeable<T> {
  T decode(dynamic data);
}

class TypeDecodable<T> implements Decodeable<TypeDecodable<T>> {

  T? value;
  TypeDecodable({ this.value });

  @override
  TypeDecodable<T> decode(dynamic data) {
    value = data;
    return this;
  }

}