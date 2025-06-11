//
//  DisclosureStyleYear.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI


struct DisclosureStyleYear: DisclosureGroupStyle {
    
    @Environment(\.appStyles) var appStyles
    
    func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: .center, spacing: 0) {
        Button {
          withAnimation {
            configuration.isExpanded.toggle()
          }
        } label: {
          HStack(alignment: .center, spacing: 0) {
            configuration.label
                  .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            Spacer()
            Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.forward")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.rectangle)
              .foregroundStyle(.blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
          }
          .frame(height: 70)
          
          //.background(Color.clear.edgesIgnoringSafeArea(.all))
          .background(
            LinearGradient(gradient: Gradient(colors: [appStyles.NavigationTreeDisclosureYearGradientStart, appStyles.NavigationTreeDisclosureYearGradientEnd]), startPoint: .leading, endPoint: .trailing))
          .foregroundStyle(.blue)
          .font(Font.custom(GroupLabelFont, size: 20))
          .border(Color.clear, width: 0)
          .cornerRadius(15)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        //.buttonStyle(.plain)
        if configuration.isExpanded {
          configuration.content
            //.font(Font.custom(GroupLabelFont, size: 40))
            .lineLimit(1)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSpacing(0)
            .foregroundStyle(.blue)
            //.frame(width: .infinity, alignment: .leading)
        }
              
      }
      //.frame(height: 70)
      
      //.background(Color.clear.edgesIgnoringSafeArea(.all))
      .background(
        LinearGradient(gradient: Gradient(colors: [appStyles.NavigationTreeDisclosureYearGradientStart, appStyles.NavigationTreeDisclosureYearGradientEnd]), startPoint: .leading, endPoint: .trailing))
      .foregroundStyle(.blue)
      .font(Font.custom(GroupLabelFont, size: 20))
      .border(Color.clear, width: 0)
      .cornerRadius(15)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

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
         //   .frame(width: .infinity, alignment: .leading)

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
      //.frame(width: .infinity, alignment: .leading)
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
            //.frame(width: .infinity, alignment: .leading)

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
      //.frame(width: .infinity, alignment: .leading)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))

    }
  }
