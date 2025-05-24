//
//  DisclosureStyleYear.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI


struct DisclosureStyleYear: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: .center, spacing: 0) {
        Button {
          withAnimation {
            configuration.isExpanded.toggle()
          }
        } label: {
          HStack(alignment: .center, spacing: 0) {
            configuration.label
            Spacer()
            Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.forward")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.rectangle)
              .foregroundStyle(.blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .buttonStyle(.plain)
        if configuration.isExpanded {
          configuration.content
            //.font(Font.custom(GroupLabelFont, size: 40))
            .lineLimit(1)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSpacing(0)
            .frame(width: .infinity, alignment: .leading)

        }
      }
      .listRowSpacing(0)
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
      .background(Color.clear.edgesIgnoringSafeArea(.all))
      .foregroundStyle(.blue)
      .font(Font.custom(GroupLabelFont, size: 40))
      .border(Color.clear, width: 0)
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.blue, lineWidth: 2)
      )
      .frame(width: .infinity, alignment: .leading)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))

    }
  }

  struct DisclosureStyleMonth: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: .center, spacing: 0) {
        Button {
          withAnimation {
            configuration.isExpanded.toggle()
          }
        } label: {
          HStack(alignment: .center, spacing: 0) {
            configuration.label
            Spacer()
            Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.forward")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.rectangle)
              .foregroundStyle(.blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .buttonStyle(.plain)
        if configuration.isExpanded {
          configuration.content
            //.font(Font.custom(GroupLabelFont, size: 40))
            .lineLimit(1)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSpacing(0)
            .frame(width: .infinity, alignment: .leading)

        }
      }
      .listRowSpacing(0)
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
      .background(Color.clear.edgesIgnoringSafeArea(.all))
      .foregroundStyle(.blue)
      .font(Font.custom(GroupLabelFont, size: 35))
      .border(Color.clear, width: 0)
      .overlay(
        Rectangle().frame(width: nil, height: 2, alignment: .top).foregroundColor(Color.blue),
        alignment: .top
      )
      .frame(width: .infinity, alignment: .leading)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))

    }
  }

  struct DisclosureStyleDay: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: .center, spacing: 0) {
        Button {
          withAnimation {
            configuration.isExpanded.toggle()
          }
        } label: {
          HStack(alignment: .center, spacing: 0) {
            configuration.label
            Spacer()
            Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.forward")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.rectangle)
              .foregroundStyle(.blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .buttonStyle(.plain)
        if configuration.isExpanded {
          configuration.content
            //.font(Font.custom(GroupLabelFont, size: 40))
            .lineLimit(1)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSpacing(0)
            .frame(width: .infinity, alignment: .leading)

        }
      }
      .listRowSpacing(0)
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
      .background(Color.clear.edgesIgnoringSafeArea(.all))
      .foregroundStyle(.blue)
      .font(Font.custom(GroupLabelFont, size: 30))
      .border(Color.clear, width: 0)
      .overlay(
        Rectangle()
          .frame(width: 2, height: nil, alignment: .leading).foregroundColor(Color.blue),
        alignment: .leading
      )
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
      .frame(width: .infinity, alignment: .leading)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))

    }
  }
