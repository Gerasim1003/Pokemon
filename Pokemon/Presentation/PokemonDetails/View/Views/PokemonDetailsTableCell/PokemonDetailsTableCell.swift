//
//  PokemonDetailsTableCell.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

class PokemonDetailsTableCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
}

// MARK: - Public methods

extension PokemonDetailsTableCell {
    func setData(_ firstValue: String?, _ secondValue: String?) {
        keyLabel.text = firstValue
        valueLabel.text = secondValue
        valueLabel.isHidden = secondValue == nil
    }
}
