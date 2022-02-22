//
//  DataModel.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 7.02.2022.
//

import Foundation

struct DataModel: Codable {
    let all: All

    enum CodingKeys: String, CodingKey {
        case all = "All"
    }
}

struct All: Codable {
    let confirmed: Int
    let deaths: Int
    let country: String
    let population: Int
    let continent: String
    let location: String
    let capitalCity: String

    enum CodingKeys: String, CodingKey {
        case capitalCity = "capital_city"
        case confirmed
        case deaths
        case country
        case population
        case continent
        case location
    }
}

// MARK: - DeathRates

struct DeathRate: Codable {
    let allForDetail: AllForDetail

    enum CodingKeys: String, CodingKey {
        case allForDetail = "All"
    }
}

struct AllForDetail: Codable {
    
    let population: Int
    let dates: [String: Int]
}

// MARK: - Vaccination

struct VaccinationRates: Codable {
    
    let allForVaccine: AllForVaccine
    
    enum CodingKeys: String, CodingKey {
        case allForVaccine = "All"
    }
}

struct AllForVaccine: Codable {
    let peopleFullyVaccinated: Int
    let peoplePartiallyVaccinated: Int
    let population: Int
    
    enum CodingKeys: String, CodingKey {
        case peopleFullyVaccinated = "people_vaccinated"
        case peoplePartiallyVaccinated = "people_partially_vaccinated"
        case population 
    }
}
