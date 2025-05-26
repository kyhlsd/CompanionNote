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
        var normalizedText = text.hasSuffix("\n") ? text : text + "\n"
        
        // 줄 단위로 분해
        var lines = normalizedText.components(separatedBy: .newlines)

        // 첫 줄이 ":"를 포함하지 않으면 subject 없이 description으로 처리
        if let firstLine = lines.first, !firstLine.contains(":") {
            let trimmed = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                results.append(PrayRequestContent(subject: "", description: trimmed))
            }
            // 첫 줄 제거 후 나머지 텍스트 재구성
            lines.removeFirst()
            normalizedText = lines.joined(separator: "\n") + "\n"
        }

        // ":"가 없는 경우, 전체 텍스트를 하나의 description으로 처리
        if !normalizedText.contains(":") {
            let trimmedText = normalizedText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedText.isEmpty {
                let prayRequestContent = PrayRequestContent(subject: "", description: trimmedText)
                results.append(prayRequestContent)
            }
            return results
        }

        // ":" 기준으로 subject, description 나누기
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
