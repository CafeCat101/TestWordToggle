//
//  SentenceToWordsView.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/19.
//

import SwiftUI

struct SentenceToWordsView: View {
	@State private var sentence = "This is a sample sentence."
			@State private var wordArray: [String] = []

			var body: some View {
					VStack {
							TextField("Enter a sentence", text: $sentence)
									.textFieldStyle(RoundedBorderTextFieldStyle())
									.padding()

							Button("Create Word Array") {
									wordArray = createWordArray(from: sentence)
							}
							.padding()

							List(wordArray, id: \.self) { word in
									Text(word)
							}
					}
			}
	
	func createWordArray(from sentence: String) -> [String] {
			// Remove leading and trailing whitespace
			let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
			
			// Split the sentence into words
			let words = trimmedSentence.components(separatedBy: .whitespacesAndNewlines)
			
			// Filter out any empty strings
			let nonEmptyWords = words.filter { !$0.isEmpty }
			
			return nonEmptyWords
	}
}


#Preview {
    SentenceToWordsView()
}
