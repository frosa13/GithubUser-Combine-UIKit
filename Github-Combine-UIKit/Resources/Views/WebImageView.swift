//
//  WebImageView.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 04/10/2024.
//

import UIKit

class WebImageView: UIImageView {
    
    init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentMode = .scaleAspectFill
        backgroundColor = .clear
    }
    
    func reset() {
        image = nil
    }
    
    func loadImage(urlString: String) {
        reset()

        guard let url = URL(string: urlString) else {
            print("Impossible to read url")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url) {
                if let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            }
        }
    }
}
