//
//  Application.swift
//  Yara
//
//  Created by Johnny Owayed on 25/10/2024.
//

import FirebaseCore

struct Application {
    let id: String
    let userID: String
    var emiratesIDFrontURL: String
    var emiratesIDBackURL: String
    var bankStatementURL: String
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var employmentStatus: String
    var address: String
    var monthlySalary: Double
    var nationality: String
    var phoneNumber: String
    var status: String
    let createdAt: Date
    var updatedAt: Date
    
    // Initialize from Firestore document
    init?(id: String, data: [String: Any]) {
        guard let userID = data["userID"] as? String,
              let emiratesIDFrontURL = data["emiratesIDFrontURL"] as? String,
              let emiratesIDBackURL = data["emiratesIDBackURL"] as? String,
              let bankStatementURL = data["bankStatementURL"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let dateOfBirth = data["dateOfBirth"] as? String,
              let employmentStatus = data["employmentStatus"] as? String,
              let address = data["address"] as? String,
              let monthlySalary = data["monthlySalary"] as? Double,
              let nationality = data["nationality"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let status = data["status"] as? String,
              let createdAt = data["createdAt"] as? Timestamp,
              let updatedAt = data["updatedAt"] as? Timestamp else {
            return nil
        }
        
        self.id = id
        self.userID = userID
        self.emiratesIDFrontURL = emiratesIDFrontURL
        self.emiratesIDBackURL = emiratesIDBackURL
        self.bankStatementURL = bankStatementURL
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.employmentStatus = employmentStatus
        self.address = address
        self.monthlySalary = monthlySalary
        self.nationality = nationality
        self.phoneNumber = phoneNumber
        self.status = status
        self.createdAt = createdAt.dateValue()
        self.updatedAt = updatedAt.dateValue()
    }
}
