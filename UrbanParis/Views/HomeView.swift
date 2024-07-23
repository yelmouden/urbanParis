import CharteFeature
import ProfileFeature
import DesignSystem
import SwiftUI
import Utils

struct HomeView : View {

    @State var index = 0
    @State var show = false

    var body: some View{
        ZStack{
            HStack{

                VStack {

                    let image =  ConfigurationReader.isUrbanApp ? Image("urbanHead")
                    : Image("letters")

                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: 80,
                            height: 80)

                    Text("Hello")
                        .font(DSFont.grafTitle3)
                        .padding(.top, 10)

                    Text("Jean Jean")
                        .font(DSFont.grafTitle3)

                    Divider()
                        .frame(width: 50)
                        .frame(height: 4)
                        .overlay(.white)
                        .padding(.bottom, Margins.extraLarge)

                    ScrollView {
                        VStack(alignment: .leading, spacing: Margins.medium) {
                            Button {
                                index = 0
                                show = false
                            } label: {
                                Text("Mon Profil")
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 0 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 1
                                show = false
                            } label: {
                                Text("Charte Urban Paris")
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 1 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 2
                                show = false
                            } label: {
                                Text("Paramètres")
                                    .font(DSFont.grafTitle3)
                                    .opacity(index == 2 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)


                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)

                    Spacer()

                    
                    ZStack {
                        SmokeManView(orientation: .right)
                            .offset(.init(width: -40, height: 0))

                        SmokeManView(orientation: .left)
                            .offset(.init(width: 80, height: 0))
                    }

                    //.offset(.init(width: 0, height: 21))
                    //.transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .frame(maxWidth: (UIScreen.main.bounds.width / 2) - 20, alignment: .leading)

                .background(DSColors.red.swiftUIColor)
                .padding(.top,25)
                .padding(.horizontal,20)

                Spacer(minLength: 0)
            }

            // MainView...
            ZStack {
                if index == 0 {
                    ProfileCoordinator(showMenu: $show)
                } else if index == 1 {
                    CharteCoordinator(showMenu: $show)
                } else if index == 2 {
                    CharteCoordinator(showMenu: $show)
                }
            }
            .cornerRadius(self.show ? 8 : 0)
            .scaleEffect(self.show ? 0.9 : 1)
            .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y: self.show ? 15 : 0)
            .rotationEffect(.init(degrees: self.show ? -5 : 0))
            .ignoresSafeArea()
        }
        .animation(.spring(duration: 0.4, bounce: show ? 0.3 : 0), value: show)
        .background(DSColors.red.swiftUIColor)
    }
}
