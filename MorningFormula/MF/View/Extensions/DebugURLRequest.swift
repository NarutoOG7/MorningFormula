//
//  URLRequest.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
}
