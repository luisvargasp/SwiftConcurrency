//
//  SendableSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI
actor UserManager {
    func updateUser(userInfo:ClassUserInfo) async {
        
    }
}

struct UserInfo : Sendable {
    let name: String
}
final class ClassUserInfo : Sendable{
    let name: String = "User"
}

class SendableViewModel: ObservableObject {
    let manager = UserManager()
    func updateUser() async {
        await manager.updateUser(userInfo:  ClassUserInfo())
    }
}

struct SendableSample: View {
    @StateObject private var viewModel = SendableViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await viewModel.updateUser()
            }
    }
}

#Preview {
    SendableSample()
}
