//
//  ToggleWord.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/19.
//

import Foundation
struct ToggledWord: Identifiable, Codable {
	var id: Int
	let word: String
	var highlighted: Bool
}

struct ToggledWordSentence: Codable {
	var sentence: String
	var words: [ToggledWord]
}
