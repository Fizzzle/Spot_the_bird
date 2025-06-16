import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/model/bird_post_model.dart';

part 'bird_post_state.dart';
class BirdPostCubit extends Cubit<BirdPostState> {
    BirdPostCubit() : super(BirdPostState(birdPostsModel: [], status: BirdPostStatus.initial));

    void addBirdPost(BirdPostModel birdPostModel){
      emit(state.copyWith(status: BirdPostStatus.loading));

      List<BirdPostModel> birdPosts = state.birdPostsModel;

      birdPosts.add(birdPostModel);

      emit(state.copyWith(birdPostsModel: birdPosts ,status: BirdPostStatus.loading));
    } 

}