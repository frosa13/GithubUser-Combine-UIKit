//
//  UserViewModel.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 07/08/2024.
//

import Combine
import Foundation

class UserViewModel {
    
    @Published var user: User?
    private var cancellables: Set<AnyCancellable> = []
    @Published var isLoading: Bool = false
    
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.loadUser(search: searchText)
            }.store(in: &cancellables)
    }
    
    func setSearchText(_ searchText: String?) {
        searchSubject.send(searchText ?? "")
    }
    
    func loadUser(search: String) {
        
        self.isLoading = true
        
        guard search.isEmpty == false else {
            self.user = nil
            self.isLoading = false
            return
        }
        
        httpClient.fetchUser(search: search)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self?.user = nil
                    print(error)
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &cancellables)
    }
}
