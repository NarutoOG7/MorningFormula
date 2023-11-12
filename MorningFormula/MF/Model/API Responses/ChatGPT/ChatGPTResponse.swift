//
//  ChatGPTResponse.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

struct ChatGPTResponse: Codable {
    var bot: String
    
    enum CodingKeys: String, CodingKey {
        case bot = "MPT"
    }
    
    static let example = ChatGPTResponse(bot: "Spencer is a dedicated individual who embodies the essence of a true believer. He's not only a fighter when it comes to pursuing his dreams but also a loving brother who values the support of his family. As a full-time iOS developer, he codes for two hours daily, crafting innovative and user-friendly applications. Spencer's unwavering commitment to his goals is inspiring, and he tirelessly submits job applications, knowing that his hard work will lead to career success. Outside of the tech world, he's equally focused on personal growth and health, hitting the gym four days a week for invigorating one-hour workouts. In all aspects of his life, Spencer exemplifies the tenacity and dedication that make dreams a reality.")
}
