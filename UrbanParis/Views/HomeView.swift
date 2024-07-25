import CotisationsFeature
import DesignSystem
import ProfileFeature
import PDFFeature
import SettingsFeature
import SwiftUI
import Utils

@MainActor
struct HomeView : View {

    @State var menuViewModel = MenuViewModel()

    @State var index = 0
    @State var show = false

    var body: some View{
        ZStack{
            MenuView(index: $index, showMenu: $show)

            ZStack {
                if index == 0 {
                    CotisationsCoordinator(showMenu: $show)
                        .transition(.opacity)
                } else if index == 1 {
                    ProfileCoordinator(showMenu: $show)
                        .transition(.opacity)
                } else if index == 2 {
                    PDFCoordinator(showMenu: $show, docType: .chart)
                        .transition(.opacity)
                } else if index == 3 {
                    PDFCoordinator(showMenu: $show, docType: .organigrame)
                        .transition(.opacity)
                } else if index == 4 {
                    SettingsCoordinator(showMenu: $show)
                        .transition(.opacity)
                }
            }
            .cornerRadius(self.show ? 8 : 0)
            .scaleEffect(self.show ? 0.9 : 1)
            .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y: self.show ? 15 : 0)
            .rotationEffect(.init(degrees: self.show ? -5 : 0))
            .ignoresSafeArea()
        }
        .animation(.spring(duration: 0.4, bounce: show ? 0.3 : 0), value: show)
        .animation(.default, value: index)
        .background(DSColors.red.swiftUIColor)
    }
}