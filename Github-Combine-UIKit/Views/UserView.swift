//
//  UserView.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 04/10/2024.
//

import UIKit

class UserVIew: UIView {
    
    private var avatarImageView = WebImageView()
    private var mainInfoCardView = InfoCardView(displayMainTitle: true)
    private var statsTitleLabel = UILabel(weight: .bold, size: 22, color: .black)
    private var statsInfoCardView = InfoCardView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = Size.s100.rawValue / 2
        avatarImageView.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        avatarImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        avatarImageView.layer.shadowOpacity = 1
        avatarImageView.layer.zPosition = 1
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        
        mainInfoCardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainInfoCardView)
        
        statsTitleLabel.numberOfLines = 0
        statsTitleLabel.text = "Stats"
        statsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsTitleLabel)
        
        statsInfoCardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsInfoCardView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: Size.s100.rawValue),
            avatarImageView.widthAnchor.constraint(equalToConstant: Size.s100.rawValue),
            
            mainInfoCardView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -(Size.s100.rawValue / 2)),
            mainInfoCardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Margins.m16.rawValue),
            mainInfoCardView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Margins.m16.rawValue),
            
            statsTitleLabel.topAnchor.constraint(equalTo: mainInfoCardView.bottomAnchor, constant: Margins.m32.rawValue),
            statsTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Margins.m16.rawValue),
            statsTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Margins.m16.rawValue),
            
            statsInfoCardView.topAnchor.constraint(equalTo: statsTitleLabel.bottomAnchor, constant: Margins.m8.rawValue),
            statsInfoCardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Margins.m16.rawValue),
            statsInfoCardView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Margins.m16.rawValue),
            statsInfoCardView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Margins.m32.rawValue)
        ])
    }
    
    func updateView(user: User) {
        avatarImageView.loadImage(urlString: user.avatarURL)
        
        var mainInfoElements = [InfoCardViewElement]()
        
        mainInfoElements.append(
            InfoCardViewElement(
                title: "Company",
                description: user.company ?? "N/A"
            )
        )
        
        mainInfoElements.append(
            InfoCardViewElement(
                title: "Username",
                description: user.name ?? "N/A"
            )
        )
        
        mainInfoElements.append(
            InfoCardViewElement(
                title: "Location",
                description: user.location ?? "N/A"
            )
        )
        
        mainInfoCardView.updateView(mainTitle: user.login, infoElements: mainInfoElements)
        
        var statsInfoElements = [InfoCardViewElement]()
        
        statsInfoElements.append(
            InfoCardViewElement(
                title: "Followers",
                description: String(describing: user.followers)
            )
        )
        
        statsInfoElements.append(
            InfoCardViewElement(
                title: "Public repos",
                description: String(describing: user.publicRepos)
            )
        )
        
        statsInfoElements.append(
            InfoCardViewElement(
                title: "Public gists",
                description: String(describing: user.publicGists)
            )
        )
        
        statsInfoCardView.updateView(infoElements: statsInfoElements)
    }
}
