//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 19/04/2024.
//

import SwiftUI
import Utils

public enum DisplayType {
    case vertical
    case horizontal
}

public struct SelectableViews<Item: SelectableItem>: View {
    let title: String
    let items: [Item]
    let displayType: DisplayType
    @Binding var selectedItem: Item?

    public init(
        title: String,
        items: [Item],
        displayType: DisplayType = .horizontal,
        selectedItem: Binding<Item?>
    ) {
        self.title = title
        self.items = items
        self.displayType = displayType
        self._selectedItem = selectedItem
    }

    @ViewBuilder
    var itemsView: some View {
        ForEach(items, id: \.title) { item in
            Button(action: {
                selectedItem = item
            }, label: {
                HStack {
                    Circle()
                        .stroke(DSColors.red.swiftUIColor, lineWidth: 2)
                        .fill(selectedItem == item ? DSColors.red.swiftUIColor.opacity(0.7) : .clear)
                        .frame(width: 20, height: 20)
                        .padding([.leading, .trailing], Margins.small)

                    VStack {
                        Text(item.title)
                            .foregroundStyle(DSColors.white.swiftUIColor)
                            .font(DSFont.robotoBodyBold)
                    }
                    .padding([.top, .bottom], Margins.medium)
                    .padding(.trailing, Margins.small)


                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .addBorder(DSColors.red.swiftUIColor, cornerRadius: 12)
            })
            .buttonStyle(PlainButtonStyle())
            .addSensoryFeedback()
        }
    }

    public var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(DSColors.white.swiftUIColor)
                    .font(DSFont.grafHeadline)

                Spacer()
            }

            if displayType == .horizontal {
                HStack(spacing: Margins.small) {
                    itemsView
                }
                .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(spacing: Margins.small) {
                    itemsView
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}
