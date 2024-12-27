import Foundation
import Dependencies
import DependenciesMacros
import TravelMatchesFeature
import Utils

@MainActor
@Observable
final class TeamCellViewModel: Identifiable, Equatable {
    @ObservationIgnored
    @Dependency(\.travelMatchesRepository)
    var travelMatchesRepository

    let id: Int
    let name: String

    var stateView: StateView<EmptyResource> = .idle

    let team: Team

    init(team: Team) {
        self.team = team
        self.id = team.id
        self.name = team.name
    }

    public nonisolated static func == (lhs: TeamCellViewModel, rhs: TeamCellViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func deleteTeam() async {
        do {
            stateView = .loading

            try await travelMatchesRepository.deleteTeam(idTeam: id)

            stateView = .idle
        } catch {
            print("error ", error)
            stateView = .idle
        }

    }
}
