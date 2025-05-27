//
//  PrayRequest.swift
//  CompanionNote
//
//  Created by 김영훈 on 3/19/25.
//

import Foundation

public class PrayRequest {
    public let date: Date
    public var title: String
    public var items: [PrayItem]
    public let uuid: UUID
    
    public init(date: Date, title: String, items: [PrayItem], uuid: UUID = UUID()) {
        self.date = date
        self.title = title
        self.items = items
        self.uuid = uuid
    }
    
    public func updateData(title: String, items: [PrayItem]) {
        self.title = title
        self.items = items
    }
    
    public static let dummyDatas = [
        PrayRequest(date: Date(), title: "조 모임", items: [
            PrayItem(name: "지수", content: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayItem(name: "영훈", content: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayItem(name: "하진", content: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", items: [
            PrayItem(name: "지수", content: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayItem(name: "영훈", content: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayItem(name: "하진", content: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", items: [
            PrayItem(name: "지수", content: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayItem(name: "영훈", content: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayItem(name: "하진", content: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", items: [
            PrayItem(name: "지수", content: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayItem(name: "영훈", content: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayItem(name: "하진", content: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
    ]
}

public struct PrayItem: Equatable {
    public let name: String
    public let content: String
    
    public init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}
