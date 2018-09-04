//
//  Pokemon.swift
//  Pika Pika
//
//  Created by Jason Goodney on 9/4/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let sprites: Sprite
    let abilities: [AbilitiesDictionary]
    
    var abilitiesName: [String] {
        return abilities.compactMap({ $0.ability.name })
    }
    
    struct AbilitiesDictionary: Decodable {
        let ability: Ability
        
        struct Ability: Decodable {
            let name: String
        }
    }
}

struct Sprite: Decodable {
    let image: URL
    
    private enum CodingKeys: String, CodingKey {
        case image = "front_default"
    }
}
