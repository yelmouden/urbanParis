import CotisationsFeature
import DesignSystem
import ProfileFeature
import PDFFeature
import MatosFeature
import SettingsFeature
import SwiftUI
import TravelMatchesFeature
import Utils

@MainActor
struct HomeView : View {

    @State var menuViewModel = MenuViewModel()
    @State var homeViewModel = HomeViewModel()

    @State var index = 0
    @State var show = false

    var body: some View{
        ZStack{
            MenuView(index: $index, showMenu: $show)

            VStack {
                if index == 0 {
                    CotisationsCoordinator(showMenu: $show)
                        .transition(.opacity)
                } else if index == 1 {
                    TravelMatchesCoordinator(showMenu: $show)
                        .transition(.opacity)
                } else if index == 2 {
                    MatosCoordinator(showMenu: $show)
                        .transition(.opacity)
                } else if index == 3 {
                    ProfileCoordinator(showMenu: $show, getMyTravels: {
                        AnyView(MyTravelsView(interModuleAction: $0))
                    })
                        .transition(.opacity)
                } else if index == 4 {
                    PDFCoordinator(showMenu: $show, docType: .chart)
                        .transition(.opacity)
                } else if index == 5 {
                    PDFCoordinator(showMenu: $show, docType: .organigrame)
                        .transition(.opacity)
                } else if index == 6 {
                    SettingsCoordinator(showMenu: $show)
                        .transition(.opacity)
                } else if index == 7 {
                    MenuAdminCoordinator(showMenu: $show)
                        .transition(.opacity)
                }
            }
            .cornerRadius(self.show ? 8 : 0)
            .scaleEffect(self.show ? 1 : 1)
            .offset(x: self.show ? (UIScreen.main.bounds.width / 2) + 20 : 0, y: self.show ? 10 : 0)
            .rotationEffect(.init(degrees: self.show ? -5 : 0))
            .ignoresSafeArea()
        }
        .animation(.spring(duration: 0.4, bounce: show ? 0.3 : 0), value: show)
        .animation(.default, value: index)
        .background(DSColors.red.swiftUIColor)
    }
}
