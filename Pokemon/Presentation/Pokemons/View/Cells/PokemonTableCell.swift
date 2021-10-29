//
//  PokemonTableCell.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

class PokemonTableCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

// MARK: - Setup
 
private extension PokemonTableCell {
    func setup() {
        containerView.applyShadow()
        containerView.layer.cornerRadius = 12
    }
}

// MARK: - Public methods

extension PokemonTableCell {
    func setData(_ data: Pokemon?) {
        pokemonNameLabel.text = data?.name.capitalized
    }
}
