//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 27/07/2024.
//

import DesignSystem
import SharedResources
import SwiftUI

@MainActor
struct PoolView: View {

    @State private var viewModel: PoolViewModel

    @State private var task: Task<Void, Never>?

    init(pool: Pool) {
        self.viewModel = .init(pool: pool)
    }

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.pool.title)
                    .font(DSFont.robotoTitle3)
                    .foregroundStyle(DSColors.white.swiftUIColor)

                Spacer()
            }

            Divider()
                .frame(height: 1)
                .overlay(.white)
                .padding(.bottom, Margins.small)

            if viewModel.hasAlreadyAnswered {
                ForEach(viewModel.pool.proposals) { proposal in

                    let ratio: Float = viewModel.pool.ratioForResponse(idProposal: proposal.id)

                    VStack {
                        HStack {
                            VStack(alignment: .trailing) {
                                Text(ratio.percentageText)
                                    .font(DSFont.robotoCaption1)
                                    .foregroundStyle(DSColors.white.swiftUIColor)

                                if viewModel.isProposalChoosenByUser(idProposal: proposal.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(DSColors.red.swiftUIColor)
                                } else {
                                    Spacer()
                                }
                            }
                            .frame(width: 35, alignment: .trailing)

                            VStack {
                                HStack {
                                    Text(proposal.title)
                                        .font(DSFont.robotoBody)
                                        .foregroundStyle(DSColors.white.swiftUIColor)

                                    Spacer()
                                }

                                GeometryReader { proxy in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(DSColors.white.swiftUIColor)
                                        .frame(width: CGFloat(proxy.size.width) * CGFloat(ratio), height: 8)
                                }
                            }
                        }
                        .padding(.bottom, Margins.small)

                    }
                    .transition(.opacity)
                }
            } else {
                ForEach(viewModel.pool.proposals) { proposal in
                    VStack {
                        HStack {
                            Button(action: {
                                if viewModel.selectedProposal.isEmpty || viewModel.pool.isMultipleChoices || viewModel.selectedProposal.contains(proposal)
                                {
                                    viewModel.manageSelectedResponse(response: proposal)
                                }
                            }, label: {
                                HStack {
                                    Circle()
                                        .stroke(DSColors.red.swiftUIColor, lineWidth: 2)
                                        .fill(viewModel.isSelectedResponse(response: proposal) ? DSColors.red.swiftUIColor : .clear)
                                        .frame(width: 20, height: 20)
                                        .padding([.leading, .trailing], Margins.small)

                                    Text(proposal.title)
                                        .font(DSFont.robotoBody)
                                        .foregroundStyle(DSColors.white.swiftUIColor)
                                }


                            })

                            Spacer()
                        }
                        .padding(.bottom, Margins.small)

                        Divider()
                            .frame(height: 1)
                            .overlay(.white)
                            .padding(.bottom, Margins.small)
                    }
                    .transition(.opacity)

                }
            }

            FWButton(title: viewModel.hasAlreadyAnswered ? "Retirer mon vote" : "Voter", state: viewModel.state.toFWButtonState()) {
                if viewModel.hasAlreadyAnswered {
                    task?.cancel()

                    task = Task {
                        await viewModel.deleteResponses()
                    }
                } else {
                    task = Task {
                        await viewModel.saveResponses()
                    }
                }

            }
            .enabled(!viewModel.selectedProposal.isEmpty || viewModel.hasAlreadyAnswered)
            .fwButtonStyle(.primary)
        }
        .onDisappear {
            task?.cancel()
        }
        .animation(.smooth, value: viewModel.pool)
        .padding()
        .background(DSColors.red.swiftUIColor.opacity(0.6))
        .addBorder(Color.clear, cornerRadius: 12)
        .showBanner($viewModel.showError, text: SharedResources.commonErrorText, type: .error)
    }
}
