//
//  ChatGPTService.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

protocol ChatGPTService {
    
    func getChatResponseFromMessage(_ message: String, withCompletion completion: @escaping(String?, Error?) -> Void)
    
    func urlRequestFromMessage(_ message: String) -> URLRequest?
}
