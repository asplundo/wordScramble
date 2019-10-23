import UIKit

struct WordValidator {
    
    let usedWords: [String]
    let rootWord: String
    let word: String
    
    func validate() -> Result<Void, WordError> {
        guard isLongEnough() else {
            return .failure(WordError.error(title: "Word to short", message: "Must be atleast three letters long"))
        }
        
        guard isNotRootWord() else {
            return .failure(WordError.error(title: "Same word", message: "Answer cant be the start word"))
        }
        
        
        guard isOriginal() else {
            return .failure(WordError.error(title: "Word used already", message: "Be more original"))
        }

        guard isPossible() else {
            return .failure(WordError.error(title: "Word not recognized", message: "You can't just make them up, you know!"))
        }

        guard isReal() else {
            return .failure(WordError.error(title: "Word not possible", message: "That isn't a real word."))
        }
        return .success(())
    }
    
    private func isLongEnough() -> Bool {
        return word.count > 2
    }
    
    private func isNotRootWord() -> Bool {
        return word != rootWord
    }
    
    private func isOriginal() -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isPossible() -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isReal() -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

enum WordError: Error {
    case error(title: String, message: String)
}
