//
//  PrayItemUtils.swift
//  CompanionNote
//
//  Created by 김영훈 on 3/19/25.
//

import Foundation

public enum PrayItemUtils {
    
    // String -> [PrayItem]
    public static func convertToPrayItem(with text: String) -> [PrayItem] {
        var results = [PrayItem]()
        
        // 입력 끝에 개행 추가 (마지막 항목까지 매치되도록)
        var normalizedText = text.hasSuffix("\n") ? text : text + "\n"
        
        // 줄 단위로 분해
        var lines = normalizedText.components(separatedBy: .newlines)

        // 첫 줄이 ":"를 포함하지 않으면 name 없이 content로 처리
        if let firstLine = lines.first, !firstLine.contains(":") {
            let trimmed = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                results.append(PrayItem(name: "", content: trimmed))
            }
            // 첫 줄 제거 후 나머지 텍스트 재구성
            lines.removeFirst()
            normalizedText = lines.joined(separator: "\n") + "\n"
        }

        // ":"가 없는 경우, 전체 텍스트를 하나의 description으로 처리
        if !normalizedText.contains(":") {
            let trimmedText = normalizedText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedText.isEmpty {
                let prayItem = PrayItem(name: "", content: trimmedText)
                results.append(prayItem)
            }
            return results
        }

        // ":" 기준으로 name, content 나누기
        let pattern = #"(?ms)^([^:\n]+)\s*:\s*(.*?)(?=^[^:\n]+\s*:\s*|\z)"#

        if let regex = try? NSRegularExpression(pattern: pattern) {
            let nsText = normalizedText as NSString
            let matches = regex.matches(in: normalizedText, range: NSRange(normalizedText.startIndex..., in: normalizedText))
            
            for match in matches {
                let rawName = nsText.substring(with: match.range(at: 1))
                let rawContent = nsText.substring(with: match.range(at: 2))
                
                let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
                let content = rawContent.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let prayItem = PrayItem(name: name, content: content)
                results.append(prayItem)
            }
        }
        return results
    }

    
    // [PrayItem] -> String
    public static func convertFromPrayItem(with items: [PrayItem]) -> String {
        let lines = items.map { item in
            if item.name.isEmpty {
                return item.content
            } else {
                return "\(item.name) : \(item.content)"
            }
        }
        
        return lines.joined(separator: "\n\n")
    }
}
