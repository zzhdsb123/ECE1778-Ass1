//
//  FlowStack.swift
//
//  Created by John Susek on 6/25/19.
//  Copyright © 2019 John Susek. All rights reserved.
//
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FlowStack<Content>: View where Content: View {
  // The number of columns we want to display
  var columns: Int
  // The total number of items in the stack
  var numItems: Int
  // The alignment of our columns in the last row
  // when they don't fill all the column slots
  var alignment: HorizontalAlignment

    var count : Int
    var count1 : Int
    var innerCount : Int
    var contentIndex : Int
    var vSpacing : CGFloat = 0.0
    var hSpacing : CGFloat = 0.0
    var sizeOfItem : Int
    
  public let content: (Int, CGFloat) -> Content

  public init(
    columns: Int,
    numItems: Int,
    alignment: HorizontalAlignment?,
    @ViewBuilder content: @escaping (Int, CGFloat) -> Content) {
    self.content = content
    self.columns = columns
    self.numItems = numItems
    self.alignment = alignment ?? HorizontalAlignment.leading
    sizeOfItem = self.numItems / self.columns
    contentIndex   =  sizeOfItem * self.columns
    innerCount = self.columns - 1
    count1 = self.numItems % self.columns
    count = self.numItems / self.columns
  }

  public var body : some View {
    // A GeometryReader is required to size items in the scroll view
    GeometryReader { geometry in
      // Assume a vertical scrolling orientation for the grid
      
        // VStacks are our rows
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0 ..< self.count) { row in
            // HStacks are our columns
                HStack(spacing: 0) {
                ForEach(0 ... self.innerCount,id: \.self) { column in
                self.content(
                  row * self.columns + column,
                  geometry.size.width/CGFloat(self.columns)
                ).frame(width: geometry.size.width/CGFloat(self.columns))
                // Size the content to frame to fill the column
              }
            }
          }
          // Last row
          // HStacks are our columns
          HStack(spacing: 0) {
            ForEach(0 ..< self.count1) { column in
              self.content(
                // Pass the index to the content
                self.contentIndex + column,
                // Pass the column width to the content
                geometry.size.width/CGFloat(self.columns)
              )
              // Size the content to frame to fill the column
              .frame(width: geometry.size.width/CGFloat(self.columns))
            }
          }
        }
      
    }
  }
}
