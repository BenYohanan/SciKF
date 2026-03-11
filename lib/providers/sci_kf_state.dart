import '../model/innovation_model.dart';
import '../model/user.dart';

class SciKFState {
  final ApplicationUser? user;
  final List<InnovationModel> recentInnovations;
  final List<InnovationModel> flashInnovations;
  final List<InnovationModel> approvedInnovations;
  final List<InnovationModel> myInnovations;
  final bool isLoading;

  const SciKFState({
    this.user,
    this.recentInnovations = const [],
    this.flashInnovations = const [],
    this.approvedInnovations = const [],
    this.myInnovations = const [],
    this.isLoading = false,
  });

  SciKFState copyWith({
    ApplicationUser? user,
    List<InnovationModel>? recentInnovations,
    List<InnovationModel>? flashInnovations,
    List<InnovationModel>? approvedInnovations,
    List<InnovationModel>? myInnovations,
    bool? isLoading,
  }) {
    return SciKFState(
      user: user ?? this.user,
      recentInnovations: recentInnovations ?? this.recentInnovations,
      flashInnovations: flashInnovations ?? this.flashInnovations,
      approvedInnovations: approvedInnovations ?? this.approvedInnovations,
      myInnovations: myInnovations ?? this.myInnovations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}