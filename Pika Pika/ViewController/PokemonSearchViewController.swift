//
//  PokemonSearchViewController.swift
//  Pika Pika
//
//  Created by Jason Goodney on 9/4/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class PokemonSearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var blurImageView: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    let numberOfPokemon = 802
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        setupNavigationBarImage()
        
        pokemonImageView.addShadow()
        
        blurImageView.addBlurEffect()
        
        view.isUserInteractionEnabled = true
    }
    
    func iChooseYou(pokemonName: String) {
        self.pokemonImageView.image = #imageLiteral(resourceName: "pokeball")
        self.pokemonImageView.spin()
        self.pokemonImageView.layer.shadowOpacity = 0.0
        
        
        PokemonController.shared.fetchPokemon(by: pokemonName) { (pokemon) in
            guard let pokemon = pokemon else { return }
            DispatchQueue.main.async {
                self.nameLabel.text = "Name: \(pokemon.name.capitalized)"
                self.idLabel.text = "Id: \(pokemon.id)"
                self.abilitiesLabel.text = "Abilities: \(pokemon.abilitiesName.joined(separator: ", "))"
            }
            
            PokemonController.shared.fetchImage(pokemon: pokemon, completion: { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        self.pokemonImageView.image = image
                        self.pokemonImageView.layer.removeAllAnimations()
                        self.pokemonImageView.layer.shadowOpacity = 1.0
                    }
                } else {
                    self.pokemonImageView.image = #imageLiteral(resourceName: "pokeball")
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ sender: UISearchBar) {
        guard let pokemonText = searchBar.text?.lowercased() else { return }
        
        iChooseYou(pokemonName: pokemonText)
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        let id = Int(arc4random_uniform(802))
        
        iChooseYou(pokemonName: "\(id + 1)")
    }
    
    func setupNavigationBarImage() {
        let pokemonLogoImageView = UIImageView()
        pokemonLogoImageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "pokemonLogo")
        pokemonLogoImageView.image = image
        navigationItem.titleView = pokemonLogoImageView
    }
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 30, height: 40)
        self.layer.shadowRadius = 10
    }
    
    func spin() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.25 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        DispatchQueue.main.async {
            self.layer.add(rotation, forKey: "rotationAnimation")
        }
    }
}


