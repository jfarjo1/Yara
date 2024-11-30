//
//  Apartment.swift
//  Yara
//
//  Created by Johnny Owayed on 24/10/2024.
//

struct Apartment: Identifiable {
    let id: String
    let name: String
    let area: String
    let bathrooms: String
    let bedrooms: String
    let description: String
    let imageUrls: [String]
    let location: String
    let locationName: String
    let oneTime: String
    let perMonth: String
    let propertySize: String
    let serviceCharge: String
    let unitsLeft: Int
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String ?? ""
        self.area = data["area"] as? String ?? ""
        self.bathrooms = data["bathrooms"] as? String ?? ""
        self.bedrooms = data["bedrooms"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.imageUrls = data["image_urls"] as? [String] ?? []
        self.location = data["location"] as? String ?? ""
        self.locationName = data["location_name"] as? String ?? ""
        
        // Handle price values which might come in different formats
        if let oneTime = data["one_time"] as? String {
            self.oneTime = oneTime
        } else if let oneTimeDouble = data["one_time"] as? Double {
            self.oneTime = String(format: "%.2f$", oneTimeDouble)
        } else {
            self.oneTime = "N/A"
        }
        
        if let perMonth = data["per_month"] as? String {
            self.perMonth = perMonth
        } else if let perMonthDouble = data["per_month"] as? Double {
            self.perMonth = String(format: "%.2f$", perMonthDouble)
        } else {
            self.perMonth = "N/A"
        }
        
        let superscriptTwo = "\u{00B2}"
        let m2 = "m" + superscriptTwo
        let propertySize = data["property_size"] as? String ?? ""
        self.propertySize = propertySize + " " + m2
        
        let serviceCharge = data["service_charge"] as? String ?? ""
        self.serviceCharge = serviceCharge + m2
        
        // Handle units_left which might be Double or Int
        if let unitsLeftInt = data["units_left"] as? Int {
            self.unitsLeft = unitsLeftInt
        } else if let unitsLeftDouble = data["units_left"] as? Double {
            self.unitsLeft = Int(unitsLeftDouble)
        } else {
            self.unitsLeft = 0
        }
    }
}
