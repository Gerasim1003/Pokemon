//
//  PokemonDetailsHeaderView.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

class PokemonDetailsHeaderView: UIView {
    // MARK: - Outlets
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PokemonDetailsHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // MARK: - Public methods
    
    func setData(_ imageUrl: String?, _ name: String?) {
        if let imageUrl = imageUrl {
            imageView.imageFromURL(urlString: imageUrl)
        }
        nameLabel.text = name
    }
}
