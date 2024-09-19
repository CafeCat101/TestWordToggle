//
//  SentenceToWordsView.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/19.
//

import SwiftUI

struct SentenceToWordsView: View {
	@StateObject private var viewModel = SentenceViewModel()
	@Environment(\.openURL) private var openURL
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack {
			Button("Create Toggled Sentence") {
				let sentence = "This is a sample sentence for toggling words"
				viewModel.createToggledWordSentence(from: sentence)
			}
			
			wordFlow
		}
	}
	
	private var wordFlow: some View {
		Text(attributedString(for: viewModel.toggledSentence))
			.lineSpacing(14)
			.multilineTextAlignment(.center)
			.padding()
			.environment(\.openURL, OpenURLAction { url in
				handleTap(url)
				return .handled
			})
	}
	
	private func attributedString(for sentence: ToggledWordSentence) -> AttributedString {
		var result = AttributedString()
		
		for (index, word) in viewModel.toggledSentence.words.enumerated() {
			var attributedWord = AttributedString(word.word)
			
			// Apply bold if needed and set larger font size
			let fontSize: CGFloat = 33 // Adjust this value to make text bigger
			
			if word.highlighted {
				// Bold and red for bold words
				attributedWord.font = .systemFont(ofSize: fontSize, weight: .heavy)
				//attributedWord.foregroundColor = .red
			} else {
				// Normal weight and black for non-bold words
				attributedWord.font = .systemFont(ofSize: fontSize, weight: .regular)
				//attributedWord.foregroundColor = colorScheme == .light ? .black : .white
			}
			
			//attributedWord.font = word.bold ?
			//		.boldSystemFont(ofSize: fontSize) :
			//		.systemFont(ofSize: fontSize)
			
			// Set text color to black
			attributedWord.foregroundColor = colorScheme == .light ? .black : .white
			
			// Apply underline
			//attributedWord.underlineStyle = .single
			//attributedWord.underlineColor = .black
			
			// Add tap gesture
			attributedWord.link = URL(string: "word://\(index)")
			
			// Add more space after each word
			if index < viewModel.toggledSentence.words.count - 1 {
				attributedWord += AttributedString("   ") // Three spaces for more separation
			}
			
			result += attributedWord
		}
		
		return result
	}
	
	
	private func handleTap(_ url: URL) {
		guard url.scheme == "word",
					let index = Int(url.host ?? ""),
					index < viewModel.toggledSentence.words.count else { return }
		
		viewModel.toggleHighlight(for: viewModel.toggledSentence.words[index])
	}
	
}


#Preview {
	SentenceToWordsView()
}
