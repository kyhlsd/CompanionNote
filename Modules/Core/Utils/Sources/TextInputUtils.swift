//
//  TextInputUtils.swift
//  Features
//
//  Created by 김영훈 on 5/27/25.
//
//

import Foundation

public enum TextInputUtils {
    // 최대 길이 제한 + 한글 조합 허용 판단 함수
    public static func shouldAllowChange(oldText: String, replacementText: String, maxLength: Int) -> Bool {
        let newText = oldText + replacementText
        if newText.count <= maxLength {
            return true
        }
        
        guard let lastChar = oldText.last else { return false }
        
        let decomposedScalars = String(lastChar)
            .decomposedStringWithCanonicalMapping
            .unicodeScalars
            .map { String($0) }
        
        let componentCount = decomposedScalars.count
        guard let lastComponent = decomposedScalars.last else {
            return false
        }
        
        // 1. 단독 자음 + 모음 → 조합 허용
        if componentCount == 1,
           isKoreanConsonant(lastComponent),
           isKoreanVowel(replacementText) {
            return true
        }
        
        // 2. 초성 + 중성 조합 → 겹모음 or 종성 허용
        if componentCount == 2,
           let scalar = lastComponent.unicodeScalars.first,
           let mappedVowel = compatibilityVowelMap[Character(scalar)] {
            let baseVowel = String(mappedVowel)
            // 겹모음 허용
            if canComposeCompoundVowel(lastCharacter: baseVowel, addCharacter: replacementText) {
                return true
            }
            // 종성으로 허용 가능한 자음인지 확인
            if isKoreanConsonant(replacementText), canBeFinalConsonant(replacementText) {
                return true
            }
        }
        
        // 3. 초성 + 중성 + 종성 조합 → 겹받침 허용
        if componentCount == 3,
           let scalar = lastComponent.unicodeScalars.first,
           let mappedFinal = compatibilityFinalConsonantMap[Character(scalar)] {
            let baseFinal = String(mappedFinal)
            if canComposeCompoundFinalConsonant(lastCharacter: baseFinal, addCharacter: replacementText) {
                return true
            }
        }
        return false
    }
    
    // 한글 자음인지 판단
    private static func isKoreanConsonant(_ character: String) -> Bool {
        guard let scalar = character.unicodeScalars.first?.value else {
            return false
        }
        
        // 한글 자음 범위 (ㄱ ~ ㅎ)
        let consonantScalarRange: ClosedRange<UInt32> = 0x3131...0x314E
        return consonantScalarRange.contains(scalar)
    }
    
    // 한글 모음인지 판단
    private static func isKoreanVowel(_ character: String) -> Bool {
        guard let scalar = character.unicodeScalars.first?.value else {
            return false
        }
        
        // 한글 모음 범위 (ㅏ ~ ㅣ)
        let vowelScalarRange: ClosedRange<UInt32> = 0x314F...0x3163
        return vowelScalarRange.contains(scalar)
    }
    
    // 겹모음 되는지 판단
    private static func canComposeCompoundVowel(lastCharacter: String, addCharacter: String) -> Bool {
        let compoundVowelMap: [String: [String]] = [
            "ㅗ": ["ㅏ", "ㅐ", "ㅣ"],
            "ㅜ": ["ㅓ", "ㅔ", "ㅣ"],
            "ㅡ": ["ㅣ"]
        ]
        
        guard let possibleNexts = compoundVowelMap[lastCharacter] else {
            return false
        }
        
        return possibleNexts.contains(addCharacter)
    }
    
    // 겹받침 되는지 판단
    private static func canComposeCompoundFinalConsonant(lastCharacter: String, addCharacter: String) -> Bool {
        let compoundFinalConsonantMap: [String: [String]] = [
            "ㄱ": ["ㅅ"],       // ㄳ
            "ㄴ": ["ㅈ", "ㅎ"], // ㄵ, ㄶ
            "ㄹ": ["ㄱ", "ㅁ", "ㅂ", "ㅅ", "ㅌ", "ㅍ", "ㅎ"], // ㄺ ~ ㅀ
            "ㅂ": ["ㅅ"]        // ㅄ
        ]
        
        guard let possibleNexts = compoundFinalConsonantMap[lastCharacter] else {
            return false
        }
        
        return possibleNexts.contains(addCharacter)
    }
    
    // 받침으로 올 수 있는 자음인지 확인
    private static func canBeFinalConsonant(_ character: String) -> Bool {
        let validFinalConsonants: Set<String> = [
            "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ",
            "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
        ]
        return validFinalConsonants.contains(character)
    }
    
    // 중성 자모 변환 맵
    private static let compatibilityVowelMap: [Character: Character] = [
        "ᅡ": "ㅏ", "ᅢ": "ㅐ", "ᅣ": "ㅑ", "ᅤ": "ㅒ", "ᅥ": "ㅓ", "ᅦ": "ㅔ", "ᅧ": "ㅕ",
        "ᅨ": "ㅖ", "ᅩ": "ㅗ", "ᅪ": "ㅘ", "ᅫ": "ㅙ", "ᅬ": "ㅚ", "ᅮ": "ㅜ", "ᅯ": "ㅝ",
        "ᅰ": "ㅞ", "ᅱ": "ㅟ", "ᅳ": "ㅡ", "ᅴ": "ㅢ", "ᅵ": "ㅣ"
    ]
    
    // 종성 자모 변환 맵
    private static let compatibilityFinalConsonantMap: [Character: Character] = [
        "ᆨ": "ㄱ", "ᆩ": "ㄲ", "ᆪ": "ㄳ", "ᆫ": "ㄴ", "ᆬ": "ㄵ", "ᆭ": "ㄶ",
        "ᆮ": "ㄷ", "ᆯ": "ㄹ", "ᆰ": "ㄺ", "ᆱ": "ㄻ", "ᆲ": "ㄼ", "ᆳ": "ㄽ",
        "ᆴ": "ㄾ", "ᆵ": "ㄿ", "ᆶ": "ㅀ", "ᆷ": "ㅁ", "ᆸ": "ㅂ", "ᆹ": "ㅄ",
        "ᆺ": "ㅅ", "ᆻ": "ㅆ", "ᆼ": "ㅇ", "ᆽ": "ㅈ", "ᆾ": "ㅊ", "ᆿ": "ㅋ",
        "ᇀ": "ㅌ", "ᇁ": "ㅍ", "ᇂ": "ㅎ"
    ]
}
