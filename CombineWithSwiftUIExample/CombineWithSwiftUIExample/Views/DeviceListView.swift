//
//  DeviceListView.swift
//  CombineWithSwiftUIExample
//
//  Created by Aya Irshaid on 05/11/2023.
//


import SwiftUI

struct DeviceListView: View {
    
    @State var selectedTab = 0
    
    @ObservedObject var deviceViewModel = DeviceViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    Button {
                        selectedTab = 0
                    } label: {
                        Text("All Products")
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(Capsule().fill(.blue.opacity(selectedTab == 0 ? 1 : 0.5)))
                            .disabled(selectedTab == 0)
                    }
                    .disabled(selectedTab == 0)
                    Button {
                        selectedTab = 1
                    } label: {
                        Text("Apple Products")
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(Capsule().fill(.blue.opacity(selectedTab == 1 ? 1 : 0.5)))
                    }
                    .disabled(selectedTab == 1)
                    Spacer()
                }
                .padding(.leading)
                
                if deviceViewModel.devices.isEmpty {
                    Text("No available devices")
                }
                
                List(selectedTab == 0 ? deviceViewModel.devices : deviceViewModel.appleProducts, id: \.id) { device in
                    VStack(alignment: .leading) {
                        Text(device.name)
                            .font(.headline)
                        if let size = device.data?.screenSize {
                            Text("Screen size: \(size)")
                                .font(.subheadline)
                        }
                        if let price = device.data?.dataPrice {
                            Text("Price: \(price)")
                                .font(.subheadline)
                        }
                    }
                    .navigationTitle("Devices")
                }
                .task {
                    deviceViewModel.fetchDevices()
                }
            }
        }
    }
}

struct DeviceListView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceListView()
    }
}
