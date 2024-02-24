//
//  MemberManagementVCMethod.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2/23/24.
//

import UIKit

protocol MemberListTableViewMethodDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

class MemberListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate, MemberTableViewCellDelegate {
    weak var delegate: MemberListTableViewMethodDelegate?
    
    func didTapChangeName() {
        print("???")
        let nextVC = EditUserNameVC(title: "이름 변경하기")
        delegate?.pushViewController(nextVC, animated: true)
    }
    
    private var userDataArray: [String] = ["User 1", "User 2", "User 3"]
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.userDataView.profileUserName.text = userDataArray[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

class MemberInviteListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
   
    private var userDataArray: [String] = ["User 1", "User 2", "User 3"]
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteMemberTableViewCell", for: indexPath) as! InviteMemberTableViewCell
        cell.userDataView.profileUserName.text = userDataArray[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
