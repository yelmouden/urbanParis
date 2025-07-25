import Foundation
import Dependencies
import DependenciesMacros
import Logger
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

    var showError = false

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
            if !(error is CancellationError) {
                stateView = .idle
                AppLogger.error(error.decodedOrLocalizedDescription)
            }
        }

    }
}
