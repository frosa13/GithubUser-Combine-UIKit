//
//  InfoCardView.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 04/10/2024.
//

import UIKit

struct InfoCardViewElement {
    let title: String
    let description: String
}

class InfoCardView: UIView {
    
    private var mainTitleLabel: UILabel?
    private var infoStackView = UIStackView()
    private var infoElementView = UIView()
    
    private let displayMainTitle: Bool
    
    init(displayMainTitle: Bool? = false) {
        self.displayMainTitle = displayMainTitle ?? false
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.cornerRadius = Radius.r12.rawValue
        
        if displayMainTitle {
            mainTitleLabel = UILabel(weight: .bold, size: 28, color: .black, alignment: .center)
            mainTitleLabel?.numberOfLines = 0
            mainTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
            if let mainTitleLabel { addSubview(mainTitleLabel) }
        }
        
        infoStackView.axis = .horizontal
        infoStackView.spacing = Margins.m8.rawValue
        infoStackView.alignment = .firstBaseline
        infoStackView.distribution = .fillProportionally
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoStackView)
    }
    
    private func setupConstraints() {
        if let mainTitleLabel {
            NSLayoutConstraint.activate([
                mainTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Margins.m69.rawValue),
                mainTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Margins.m16.rawValue),
                mainTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Margins.m16.rawValue),
                mainTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                
                infoStackView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: Margins.m16.rawValue)
            ])
        } else {
            NSLayoutConstraint.activate([
                infoStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Margins.m16.rawValue)
            ])
        }
        
        NSLayoutConstraint.activate([
            infoStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Margins.m16.rawValue),
            infoStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Margins.m16.rawValue),
            infoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Margins.m16.rawValue),
        ])
    }
    
    func updateView(mainTitle: String? = nil, infoElements: [InfoCardViewElement]) {
        if let mainTitle {
            mainTitleLabel?.text = mainTitle
        }
        
        for (index, infoElement) in infoElements.enumerated() {
            if let infoElementView = infoStackView.arrangedSubviews[safe: index] as? InfoElementView {
                infoElementView.infoTitle = infoElement.title
                infoElementView.infoDescription = infoElement.description
                
            } else {
                let infoElementView = InfoElementView()
                infoElementView.infoTitle = infoElement.title
                infoElementView.infoDescription = infoElement.description
                
                self.infoStackView.addArrangedSubview(infoElementView)
            }
        }
    }
}
