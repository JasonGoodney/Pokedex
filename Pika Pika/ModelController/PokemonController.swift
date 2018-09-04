//
//  PokemonController.swift
//  Pika Pika
//
//  Created by Jason Goodney on 9/4/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class PokemonController {
    
    static let shared = PokemonController(); private init() {}
    
    // MARK: - Propeties
    var baseURL = URL(string: "https://pokeapi.co/api/v2")
    
    func fetchPokemon(by pokemonName: String, completion: @escaping (Pokemon?) -> Void) {
    
        guard let baseURL = baseURL else { fatalError("bad base url") }
        let requestURL = baseURL
                            .appendingPathComponent("pokemon")
                            .appendingPathComponent(pokemonName)

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in

            do {
                // Handle error
                if let error = error { throw error }
                // Handle data
                guard let data = data else { throw NSError() }
                
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(pokemon)
                
            } catch let error {
                print("😳\nThere was an error in \(#function): \(error)\n\n\(error.localizedDescription)\n👿")
                completion(nil); return
            }
        }.resume()
    }
    
    func fetchImage(pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
     
        let imageURL = pokemon.sprites.image
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            
            do {
                if let error = error { throw error }
                
                guard let data = data else { throw NSError() }
                
                guard let image = UIImage(data: data) else { completion(nil); return }
                completion(image)
                
            } catch let error {
                print("😳\nThere was an error in \(#function): \(error)\n\n\(error.localizedDescription)\n👿")
            }
        }.resume()
    }
    
}
