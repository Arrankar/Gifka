//
//  GifData.swift
//  Gifka
//
//  Created by Александр on 04.07.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

struct GifResponse: Codable {
    let data: [Gifs]
}

struct Gifs: Codable {
    let id: String
}

