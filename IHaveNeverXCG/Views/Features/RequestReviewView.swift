//
//  RequestReviewView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 06.12.2024.
//

import SwiftUI

struct RequestReviewView: View {
    @Environment(\.requestReview) var requestReview
    @AppStorage("countGames") private var isFirstGame = true
    @Binding var showRating: Bool
    @Binding var isExitButtonPressed: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 23)
            .frame(width: 337.48, height: 198)
            .foregroundStyle(.white)
            .overlay {
                VStack(spacing: 21){
                    Image("logo")
                        .resizable()
                        .frame(width: 82.72, height: 82.72)
                        .clipShape(RoundedRectangle(cornerRadius: 19.39))
                    Text("Show your love by rating\nus on the AppStore!")
                        .multilineTextAlignment(.center)
                        .font(.custom("inter", size: 20))
                        .fontWeight(.semibold)
                        .aspectRatio(contentMode: .fill)
                    
                    Button {
                        requestReview()
                        showRating = false
                        isExitButtonPressed = true
                        isFirstGame = false
                    } label: {
                        Text("Share Love")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 51.58)
                            .background(Color.init(red: 56/255, green: 25/255, blue: 145/255))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 16.39)
                    }
                }
                .offset(y: -28)
            }
    }
}

//#Preview {
//    RequestReviewView()
//}
