    //
    //  OnScreenArrows.swift
    // Echo
    //
    //  Created by Gavin Henderson on 05/07/2024.
    //

    import Foundation
    import SwiftUI

    struct OnScreenArrows: View {
        @Environment(Settings.self) var settings: Settings
        
        // Thanks to https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
        @AppStorage("locationX") var locationX: Double = 300
        @AppStorage("locationY") var locationY: Double = 200
        @GestureState private var startLocation: CGPoint?
        
        var up: (() -> Void) = {}
        var down: (() -> Void) = {}
        var left: (() -> Void) = {}
        var right: (() -> Void) = {}
        
        var body: some View {
            HStack {
                ZStack {
                    VStack(spacing: .zero) {
                        HStack(spacing: .zero) {
                            
                            Spacer()
                            Button {
                                up()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .offset(CGSize(width: 0, height: 3))
                                    .opacity(settings.arrowBorderOpacity)
                                    .accessibilityLabel(
                                        String(
                                            localized: "Arrow pointing up",
                                            comment: "An accessibility label for the up arrow image"
                                        )
                                    )
                            }
                            Spacer()
                            
                        }
                        HStack(spacing: .zero) {
                            
                            Button {
                                left()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(-90))
                                    .opacity(settings.arrowBorderOpacity)
                                    .accessibilityLabel(
                                        String(
                                            localized: "Arrow pointing left",
                                            comment: "An accessibility label for the left arrow image"
                                        )
                                    )
                            }
                            Spacer()
                            Button {
                                right()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(90))
                                    .opacity(settings.arrowBorderOpacity)
                                    .accessibilityLabel(
                                        String(
                                            localized: "Arrow pointing right",
                                            comment: "An accessibility label for the right arrow image"
                                        ))
                            }
                            
                        }
                        
                        HStack(spacing: .zero) {
                            
                            Spacer()
                            Button {
                                down()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(180))
                                    .offset(CGSize(width: 0, height: -3))
                                    .opacity(settings.arrowBorderOpacity)
                                    .accessibilityLabel(
                                        String(
                                            localized: "Arrow pointing down",
                                            comment: "An accessibility label for the down arrow image"
                                        ))
                            }
                            Spacer()
                            
                        }
                    }
                    
                }
                .frame(width: settings.arrowSize, height: settings.arrowSize)
                .background(Color("transparent"))
                .position(CGPoint(
                    x: locationX.clamped(172.0 / 2, UIScreen.main.bounds.width - (172.0 / 2)),
                    y: locationY.clamped(172.0 / 2, UIScreen.main.bounds.height - (172.0))
                ))
                .zIndex(1)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { value in
                            var newLocation = startLocation ?? CGPoint(x: locationX, y: locationY)
                            newLocation.x += value.translation.width
                            newLocation.y += value.translation.height
                            
                            locationX = newLocation.x
                            locationY = newLocation.y
                        }
                        .updating($startLocation) { (_, startLocation, _) in
                            startLocation = startLocation ?? CGPoint(x: locationX, y: locationY)
                        }
                )
            }
            .zIndex(1)
        }

    }
