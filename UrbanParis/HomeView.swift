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
                        .font(DSFont.grafTitle)
                        .padding(.top, 10)

                    Text("Jean Jean")
                        .font(DSFont.grafTitle)

                    Divider()
                        .frame(width: 50)
                        .frame(height: 4)
                        .overlay(.white)
                        .padding(.bottom, Margins.veryLarge)

                    ScrollView {
                        VStack(spacing: Margins.medium) {
                            Button {
                                index = 0
                                show = false
                            } label: {
                                Text("Menu 1")
                                    .font(DSFont.grafTitle2)
                                    .opacity(index == 0 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)

                            Button {
                                index = 1
                                show = false
                            } label: {
                                Text("Menu 2")
                                    .font(DSFont.grafTitle2)
                                    .opacity(index == 1 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)


                            Button {
                                index = 2
                                show = false
                            } label: {
                                Text("Menu 3")
                                    .font(DSFont.grafTitle2)
                                    .opacity(index == 2 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)


                            Button {
                                index = 3
                                show = false
                            } label: {
                                Text("Menu 4")
                                    .font(DSFont.grafTitle2)
                                    .opacity(index == 3 ?  1 : 0.3)
                            }
                            .buttonStyle(.plain)


                        }

                    }

                }
                .frame(maxWidth: (UIScreen.main.bounds.width / 2) - 20, alignment: .leading)

                .background(DSColors.red.swiftUIColor)
                .padding(.top,25)
                .padding(.horizontal,20)

                Spacer(minLength: 0)
            }

            // MainView...
            ZStack {
                NavigationStack {
                    MainContainer {
                        Text("hello ecran \(index + 1)")
                    }
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {

                                withAnimation(.spring) {

                                    self.show.toggle()
                                }

                            }) {

                                // close Button...

                                Image(systemName: self.show ? "xmark" : "line.horizontal.3")
                                    .resizable()
                                    .frame(width: self.show ? 18 : 22, height: 18)
                                    .foregroundColor(DSColors.white.swiftUIColor)
                            }
                        }
                    }
                    .navigationTitle("Titre ecran \(index + 1)")
                }
            }
            .cornerRadius(self.show ? 30 : 0)
            .scaleEffect(self.show ? 0.9 : 1)
            .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y: self.show ? 15 : 0)
            .rotationEffect(.init(degrees: self.show ? -5 : 0))
            .ignoresSafeArea()
        }
        .animation(.smooth, value: index)
        .background(DSColors.red.swiftUIColor)
    }
}


/*
 VStack(spacing: 0){

     HStack(spacing: 15){

         Button(action: {

             withAnimation{

                 self.show.toggle()
             }

         }) {

             // close Button...

             Image(systemName: self.show ? "xmark" : "line.horizontal.3")
                 .resizable()
                 .frame(width: self.show ? 18 : 22, height: 18)
                 .foregroundColor(DSColors.white.swiftUIColor)
         }




         Spacer(minLength: 0)
     }
     .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
     .padding()
     .background(DSColors.background.swiftUIColor)

     GeometryReader{_ in

         VStack{

             // Changing Views Based On Index...

             if self.index == 0{
                 DSColors.background.swiftUIColor
                 //MainPage()
             }
             else if self.index == 1{

                 DSColors.background.swiftUIColor

             }
             else if self.index == 2{

                 DSColors.background.swiftUIColor

             }
             else{

                 DSColors.background.swiftUIColor

             }
         }
     }
 }
 .background(Color.white)
     .cornerRadius(self.show ? 30 : 0)
     .scaleEffect(self.show ? 0.9 : 1)
     .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y: self.show ? 15 : 0)
     .rotationEffect(.init(degrees: self.show ? -5 : 0))

 */
