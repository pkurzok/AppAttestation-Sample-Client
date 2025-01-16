//
//  Sample.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Foundation

// MARK: - Sample

struct Sample: Codable, Identifiable {
    var id = UUID()
    let title: String
    let subtitle: String
    let hexColor: String
}

// MARK: - Mockable

extension Sample: Mockable {

    public static var mockList: [Sample] = [
        Sample(title: "Lorem ipsum dolor sit amet", subtitle: "Consectetur adipiscing elit", hexColor: "#FF5733"),
        Sample(title: "Sed do eiusmod tempor", subtitle: "Incididunt ut labore et dolore", hexColor: "#33FF57"),
        Sample(title: "Magna aliqua ut enim ad", subtitle: "Minim veniam quis nostrud", hexColor: "#3357FF"),
        Sample(title: "Exercitation ullamco laboris", subtitle: "Nisi ut aliquip ex ea commodo", hexColor: "#FF33A1"),
        Sample(title: "Duis aute irure dolor in", subtitle: "Reprehenderit in voluptate velit", hexColor: "#A133FF"),
        Sample(title: "Esse cillum dolore eu fugiat", subtitle: "Nulla pariatur excepteur sint", hexColor: "#33FFA1"),
        Sample(title: "Occaecat cupidatat non proident", subtitle: "Sunt in culpa qui officia", hexColor: "#FF5733"),
        Sample(title: "Deserunt mollit anim id est", subtitle: "Laborum sed ut perspiciatis", hexColor: "#33FF57"),
        Sample(title: "Unde omnis iste natus error", subtitle: "Sit voluptatem accusantium", hexColor: "#3357FF"),
        Sample(title: "Doloremque laudantium totam", subtitle: "Rem aperiam eaque ipsa", hexColor: "#FF33A1")
    ]
}
