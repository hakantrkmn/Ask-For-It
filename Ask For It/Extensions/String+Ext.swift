//
//  String+Ext.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.08.2024.
//

import Foundation

    extension String {
        private static let CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        private var idToNum: Int {
            return self.compactMap { char -> Int? in
                if let index = String.CHARS.firstIndex(of: char) {
                    return String.CHARS.distance(from: String.CHARS.startIndex, to: index)
                }
                return nil
            }.reduce(0) { $0 * 36 + $1 }
        }
        
        private static func numToId(_ num: Int) -> String {
            var n = num
            var idStr = ""
            repeat {
                idStr = String(CHARS[CHARS.index(CHARS.startIndex, offsetBy: n % 36)]) + idStr
                n /= 36
            } while n > 0
            return idStr.isEmpty ? "0" : idStr
        }
        
        var shortenedId: String {
            return String.numToId(self.idToNum)
        }
        
        var restoredId: String {
            return String.numToId(self.idToNum)
        }
    }
