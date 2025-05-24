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
    public var contents: [PrayRequestContent]
    public let uuid: UUID
    
    public init(date: Date, title: String, contents: [PrayRequestContent], uuid: UUID = UUID()) {
        self.date = date
        self.title = title
        self.contents = contents
        self.uuid = uuid
    }
    
    public func updateData(title: String, contents: [PrayRequestContent]) {
        self.title = title
        self.contents = contents
    }
    
    public static let dummyDatas = [
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
    ]
}

public struct PrayRequestContent: Equatable {
    public let subject: String
    public let description: String
    
    public init(subject: String, description: String) {
        self.subject = subject
        self.description = description
    }
}
