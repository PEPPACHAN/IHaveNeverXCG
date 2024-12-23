//
//  String+extension.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 29.11.2024.
//

import Foundation

extension String {
    func localizedPlural(_ count: Int, lang: String) -> String {
        // translate words from bundle by plural values
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return "\(self) couldn't be found in Localizable.stringsdict for language \(lang)"
        }
        let formatString = NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "\(self) couldn't be found in Localizable.stringsdict")
        return String.localizedStringWithFormat(formatString, count)
    }
    
    func changeLocale(lang: String) -> String{
        // select language from bundle by burger and automatically
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") else { print("localization path error"); return "" }
        let bundle = Bundle(path: path)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func capitalizeFirstLetter() -> String {
        // make first letter is upper in cards from MainGameFieldView.swift
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst().lowercased()
    }
}
