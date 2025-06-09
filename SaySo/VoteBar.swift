//
//  VoteBar.swift
//  SaySo
//
//  Created by Jenny Choi on 6/7/25.
//

import SwiftUI

struct VoteBar: View {
    var voted: Bool = false
    var yesPercentage: Double
    var votedYes: Bool // gray background for chosen option
    
    var onVote: ((Bool) -> Void)?  // optional call back
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if !voted {
                    // Divider line in the middle
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                }
                HStack(spacing: 0) {
                    // yes block
                    ZStack {
                        Rectangle()
                            .fill(voted && votedYes ? Color.gray.opacity(0.3) : Color.gray.opacity(0.05))
                        
                        VStack {
                            Text("Yes")
                                .foregroundStyle(Color.green)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, 8)
                                .lineLimit(1)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if !voted {
                                        onVote?(true) // votedYes = true
                                    }
                                }
                            if voted {
                                Text("\(Int(yesPercentage * 100))%")
                            }
                        }
                    }
                    .frame(width: geometry.size.width * yesPercentage)
                    
                    // no block
                    ZStack {
                        Rectangle()
                            .fill(voted && !votedYes ? Color.gray.opacity(0.3) : Color.gray.opacity(0.05))
                        VStack {
                            Text("No")
                                .foregroundStyle(Color.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, 8)
                                .lineLimit(1)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if !voted {
                                        onVote?(false) // votedYes = false
                                    }
                                }
                            if voted {
                                Text("\(100 - Int(yesPercentage * 100) )%")
                            }
                        }
                    }
                    .frame(width: geometry.size.width * (1-yesPercentage))
                }
                .cornerRadius(8)
                .animation(.easeInOut(duration: 0.3), value: yesPercentage)
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    VoteBar(voted: false, yesPercentage: 0.5, votedYes: false)
}
