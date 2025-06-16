part of 'bird_post_cubit.dart';

enum BirdPostStatus {
  initial, error, loading, loaded, postAdded, postRemove
}

class BirdPostState extends Equatable {
  final List<BirdPostModel> birdPostsModel;

  final BirdPostStatus status;

  const BirdPostState({required this.birdPostsModel, required this.status,});

  @override 
  List<Object> get props => [birdPostsModel, status];

  BirdPostState copyWith({
    List<BirdPostModel>? birdPostsModel,
    BirdPostStatus? status,
  }){
    return BirdPostState(
      birdPostsModel: birdPostsModel ?? this.birdPostsModel,
      status: status ?? this.status,
    );
  }
}