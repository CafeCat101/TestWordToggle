//
//  SentenceViewModel.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/19.
//

import Foundation

class SentenceViewModel: ObservableObject {
	@Published var userSentenceObj: ToggledWordSentence {
		didSet {
			updateJSONString()
		}
	}
	@Published var userSentenceJson: String = ""
	
	init() {
		self.userSentenceObj = ToggledWordSentence(sentence: "", words: [])
		loadData()
	}
	
	private func loadData() {
		let jsonString = """
 {
 "sentence":"We can go out for a walk now.",
 "words":[
 {"word":"We","highlighted":true},
 {"word":"can","highlighted":false},
 {"word":"go out","highlighted":true},
 {"word":"for","highlighted":false},
 {"word":"a","highlighted":false},
 {"word":"walk","highlighted":true},
 {"word":"now.","highlighted":true}
 ]
 }
 """
		
		if let jsonData = jsonString.data(using: .utf8) {
			do {
				let decoder = JSONDecoder()
				self.userSentenceObj = try decoder.decode(ToggledWordSentence.self, from: jsonData)
				updateJSONString()
			} catch {
				print("Error parsing JSON: \(error)")
			}
		}
	}
	
	func toggleHighlight(for word: ToggledWord) {
		if let index = userSentenceObj.words.firstIndex(where: { $0.id == word.id }) {
			userSentenceObj.words[index].highlighted.toggle()
			updateJSONString()
		}
	}
	
	private func updateJSONString() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		
		do {
			let jsonData = try encoder.encode(userSentenceObj)
			if let jsonString = String(data: jsonData, encoding: .utf8) {
				self.userSentenceJson = jsonString
			}
		} catch {
			print("Error encoding to JSON: \(error)")
		}
	}
}
