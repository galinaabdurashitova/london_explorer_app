//
//  URLStringConvertor.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 27.08.2024.
//

import Foundation

class URLEncoder {
    private let urlEncodingMapping: [Character: String] = [
        " " : "%20",
        "!" : "%21",
        "\"" : "%22",
        "#" : "%23",
        "$" : "%24",
        "%" : "%25",
        "&" : "%26",
        "'" : "%27",
        "(" : "%28",
        ")" : "%29",
        "*" : "%2A",
        "+" : "%2B",
        "," : "%2C",
        "-" : "%2D",
        "." : "%2E",
        "/" : "%2F",
        ":" : "%3A",
        ";" : "%3B",
        "<" : "%3C",
        "=" : "%3D",
        ">" : "%3E",
        "?" : "%3F",
        "@" : "%40",
        "[" : "%5B",
        "\\" : "%5C",
        "]" : "%5D",
        "^" : "%5E",
        "_" : "%5F",
        "`" : "%60",
        "{" : "%7B",
        "|" : "%7C",
        "}" : "%7D",
        "~" : "%7E",
        "’" : "%E2%80%99"
    ]
    
    func encode(_ string: String) -> String {
        return string.reduce("") { partialResult, character in
            if let encoded = urlEncodingMapping[character] {
                return partialResult + encoded
            } else {
                return partialResult + String(character)
            }
        }
    }
}
