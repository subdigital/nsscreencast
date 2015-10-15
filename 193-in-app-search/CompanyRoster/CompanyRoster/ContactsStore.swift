//
//  ContactsStore.swift
//  CompanyRoster
//
//  Created by Ben Scheirman on 10/13/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import Foundation

class ContactsStore {
    func getContacts() -> [Contact] {
        return [
            Contact(name: "Eddard Stark", department: "Stark", imageName: "ned.jpeg"),
            Contact(name: "Jon Snow", department: "Night's Watch", imageName: "jonsnow.jpeg"),
            Contact(name: "Daenerys Targaryen", department: "Targaryen", imageName: "daenarys.jpeg"),
            Contact(name: "Jamie Lannister", department: "Lannister", imageName: "jamie.jpeg"),
            Contact(name: "Cersei Lannister", department: "Lannister", imageName: "cersei.jpeg"),
            Contact(name: "Tyrion Lannister", department: "Lannister", imageName: "tyrion.jpeg")
        ]
    }
}