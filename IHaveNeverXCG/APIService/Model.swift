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

// MARK: For custom cards
struct FetchAllCustom: Decodable {
    let appErrorValue: Bool
    let appMessagesValue: [String]
    let appDataValue: [AppCategory]
}

struct AppCategory: Decodable {
    let appCategoryIdValue: Int
    let appCategoryTitleValue: String
    let appCategoryTitleEnValue: String
    let appCategoryCardsValue: [AppCard]
    let appUpdatedAtValue: String?
}

// MARK: Model for saving in userDefaults
struct CustomCards: Codable {
    let name: String
    let uuid: String
}
