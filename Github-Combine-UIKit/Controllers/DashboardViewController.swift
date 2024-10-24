//
//  DashboardViewController.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 07/08/2024.
//

import Combine
import UIKit

class DashboardViewController: UIViewController {
    
    private enum Constants {
        static let searchTextFieldHeight: CGFloat = 40
    }
    
    // MARK: - Views
    private var searchTextField: SearchTextField!
    private var userView: UserVIew!
    private var loadingView: LoadingView!
    
    // MARK: - Properties
    private let viewModel: UserViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewController lifecycle
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .gray238
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapOnViewController))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateViewState(isLoading: isLoading)
            }.store(in: &cancellables)
        
        searchTextField = SearchTextField()
        searchTextField.delegate = self
        searchTextField.searchTextFieldDelegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        
        userView = UserVIew()
        userView.isHidden = true
        userView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userView)
        
        loadingView = LoadingView()
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.m32.rawValue),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.m16.rawValue),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.m16.rawValue),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.searchTextFieldHeight),
            
            userView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Margins.m32.rawValue),
            userView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            userView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            userView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            loadingView.widthAnchor.constraint(equalToConstant: Size.s100.rawValue),
            loadingView.heightAnchor.constraint(equalToConstant: Size.s100.rawValue),
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func updateViewState(isLoading: Bool) {
        if isLoading {
            loadingView.isHidden = false
            loadingView.startLoading()
        } else if let user = viewModel.user {
            userView.updateView(user: user)
            userView.isHidden = false
            
            loadingView.isHidden = true
            loadingView.stopLoading()
        } else {
            userView.isHidden = true
            loadingView.isHidden = true
            loadingView.stopLoading()
        }
    }
    
    @objc
    func didTapOnViewController() {
        searchTextField.resignFirstResponder()
    }
}

// MARK: - SearchTextFieldDelegate
extension DashboardViewController: SearchTextFieldDelegate, UITextFieldDelegate {
    
    func clearButtonPressed(view: SearchTextField) {
        viewModel.user = nil
    }
    
    func searchButtonPressed(_ view: SearchTextField) {
        viewModel.setSearchText(view.text)
    }
    
    func textFieldDidChange(_ view: SearchTextField, text: String) {
        viewModel.setSearchText(view.text)
    }
}
