//
//  InfoElementView.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 04/10/2024.
//

import UIKit

class InfoElementView: UIView {

    private var infoTitleLabel = UILabel(weight: .regular, size: 20, color: .black, alignment: .center)
    private var infoDescriptionLabel = UILabel(weight: .light, size: 16, color: .black, alignment: .center)
    
    var infoTitle: String? {
        didSet {
            infoTitleLabel.text = infoTitle
        }
    }
    
    var infoDescription: String? {
        didSet {
            infoDescriptionLabel.text = infoDescription ?? "N/A"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        infoTitleLabel.numberOfLines = 0
        infoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoTitleLabel)
        
        infoDescriptionLabel.numberOfLines = 0
        infoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoDescriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            infoTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            infoTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            infoDescriptionLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: Margins.m8.rawValue),
            infoDescriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            infoDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            infoDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
