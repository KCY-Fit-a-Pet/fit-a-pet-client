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

class petManagersManager {
    static var masterManager: Manager?
    static var subManagers: [Manager] = []
    
    func addManager(manager: Manager) {
        if manager.isMaster {
            petManagersManager.masterManager = manager
        } else {
            petManagersManager.subManagers.append(manager)
        }
    }
}
