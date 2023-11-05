//
//  DeviceViewModel.swift
//  CombineWithSwiftUIExample
//
//  Created by Aya Irshaid on 05/11/2023.
//

import Foundation
import Combine

class DeviceViewModel: ObservableObject {
    
    @Published private(set) var devices: Device = []
    @Published private(set) var appleProducts: Device = []
    private var cancellables = Set<AnyCancellable>()
    private let subject = PassthroughSubject<Device, Never>()
    
    deinit {
        cancellables.forEach{$0.cancel()}
    }
    
    func fetchDevices() {
        if let url = URL(string: "https://api.restful-api.dev/objects") {
            let getDevices = URLSession.shared
                .dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global())
                .map { $0.data }
                .removeDuplicates()
                .decode(type: Device.self, decoder: JSONDecoder())
                .replaceError(with: [])
                .print()
                .multicast(subject: self.subject)
            
            getDevices
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .finished:
                        return
                    }
                    print("\(String(describing: completion))")
                } receiveValue: { [weak self] devices in
                    print("receiveValue 1")
                    self?.devices = devices
                }
                .store(in: &cancellables)
            
            getDevices
                .receive(on: DispatchQueue.main)
                .map { devices in
                    return devices.filter {
                        $0.name.lowercased().contains("apple") || $0.name.lowercased().contains("iPh")
                    }
                }
                .assign(to: \.appleProducts, on: self)
                .store(in: &cancellables)
            
            getDevices.connect()
                .store(in: &cancellables)
        }
    }
}
