//
//  Model.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 28.11.2024.
//

import Foundation

// MARK: For all default data
struct IHNFetchAll: Decodable {
    let appErrorValue: Bool
    let appStatValue: AppStat
    let appVersionValue: Int
    let appDataValue: [AppData]
}

struct AppStat: Decodable {
    let appTotalCardsValue: Int
    let appTotalCategoriesValue: Int
    let appTotalCustomCardsValue: Int
    let appTotalCustomCardsUnlockedValue: Int
    let appTotalCardsUnlockedValue: Int
    let appPercentValue: Double
    let appTotalDecksValue: Int
    let appTotalDecksUnlockedValue: Int
}

struct AppData: Decodable {
    let appCategoryIdValue: Int
    let appCategoryTitleValue: String
    let appCategoryTitleEnValue: String
    let appCategoryInfoValue: String
    let appIsPaidValue: Bool
    let appTotalCardsValue: Int
    let appTotalOpenedValue: Int
    let appPercentValue: Double
    let appCategoryCardsValue: [AppCard]
}

struct AppCard: Decodable {
    let appCardIdValue: Int
    let appCardTextValue: String
    let appCardCounterValue: Int?
    let appTotalLikesValue: Int
    let appTotalDislikesValue: Int
    let appIsCustomValue: Bool
    let appStateValue: Bool
    let appUpdatedAtValue: String
}

// MARK: AI Cards
struct AICards: Decodable {
    let candidates: [Candidate]
    let usageMetadata: UsageMetadata
    let modelVersion: String
}

struct Candidate: Decodable {
    let content: Content
    let finishReason: String
    let avgLogprobs: Double
}

struct Content: Decodable {
    let parts: [Part]
    let role: String
}

struct Part: Decodable {
    let text: String
}

struct UsageMetadata: Decodable {
    let promptTokenCount: Int
    let candidatesTokenCount: Int
    let totalTokenCount: Int
}
