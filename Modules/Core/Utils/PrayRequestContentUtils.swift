//
//  PrayRequestContentUtils.swift
//  CompanionNote
//
//  Created by 김영훈 on 3/19/25.
//

import Foundation

public enum PrayRequestContentUtils {
    
    // String -> [PrayRequestContent]
    public static func convertToPrayRequestContent(with text: String) -> [PrayRequestContent] {
        var results = [PrayRequestContent]()
        
        // 입력 끝에 개행 추가 (마지막 항목까지 매치되도록)
        let normalizedText = text.hasSuffix("\n") ? text : text + "\n"
        
        // ":"가 없을 때는 전체 Text를 하나의 Description으로 처리
        if !text.contains(":") {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let prayRequestContent = PrayRequestContent(subject: "", description: trimmedText)
            results.append(prayRequestContent)
            print(results)
            return results
        }
        
        // ":" 기준으로 둘로 나눔
        let pattern = #"(?ms)^([^:\n]+)\s*:\s*(.*?)(?=^[^:\n]+\s*:\s*|\z)"#
        
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let nsText = normalizedText as NSString
            let matches = regex.matches(in: normalizedText, range: NSRange(normalizedText.startIndex..., in: normalizedText))
            
            for match in matches {
                let rawSubject = nsText.substring(with: match.range(at: 1))
                let rawDescription = nsText.substring(with: match.range(at: 2))
                
                let subject = rawSubject.trimmingCharacters(in: .whitespacesAndNewlines)
                let description = rawDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let prayRequestContent = PrayRequestContent(subject: subject, description: description)
                results.append(prayRequestContent)
            }
        }
        return results
    }
    
    // [PrayRequestContent] -> String
    public static func convertFromPrayRequestContents(with contents: [PrayRequestContent]) -> String {
        let lines = contents.map { content in
            if content.subject.isEmpty {
                return content.description
            } else {
                return "\(content.subject) : \(content.description)"
            }
        }
        
        return lines.joined(separator: "\n\n")
    }
}
