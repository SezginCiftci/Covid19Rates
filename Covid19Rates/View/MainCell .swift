//
//  MainCell .swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 8.02.2022.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    var nameLabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    func configureCell() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        nameLabel.sizeToFit()
        nameLabel.contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
