//
//  petManagersManager.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2/25/24.
//

import Foundation

struct Manager {
    let id: Int
    let uid: String
    let name: String
    let profileImageUrl: String
    let isMaster: Bool
}

struct InviteManager {
    let id: Int
    let uid: String
    let name: String
    let profileImageUrl: String
    let isMaster: Bool
    let expired: Bool
    let invitedAt: Date
}

class PetManagersManager {
    static var masterManager: Manager?
    static var subManagers: [Manager] = []
    static var inviteManagers: [InviteManager] = []
    
    func addManager(manager: Manager) {
        if manager.isMaster {
            PetManagersManager.masterManager = manager
        } else {
            PetManagersManager.subManagers.append(manager)
        }
    }
    func addInviteManager(inviteManager: InviteManager) {
        PetManagersManager.inviteManagers.append(inviteManager)
    }
}