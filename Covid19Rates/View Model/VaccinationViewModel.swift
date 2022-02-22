//
//  VaccinationViewModel.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 20.02.2022.
//

import UIKit
import Charts

class VaccinationViewModel {
    
    let service = Webservice()
    
    var chartEntries = [ChartDataEntry]()
    var fullyVac = ""
    var partiallyVac = ""
    var population = ""
    
    func loadData(_ country: String, completion: @escaping() -> ()) {
        
        guard let url = URL(string: "https://covid-api.mmediagroup.fr/v1/vaccines?country=\(country)") else { return }
        let resource = Resource<VaccinationRates>(url: url)
        
        service.fetchData(resource: resource) { result in
            
            switch result {
            case .success(let data):
                
                self.fullyVac = data.allForVaccine.peopleFullyVaccinated.IntToDecimals(number: data.allForVaccine.peopleFullyVaccinated)
                self.partiallyVac = data.allForVaccine.peoplePartiallyVaccinated.IntToDecimals(number: data.allForVaccine.peoplePartiallyVaccinated)
                self.population = data.allForVaccine.population.IntToDecimals(number: data.allForVaccine.population)
                
                self.chartEntries.append(ChartDataEntry(x: 0, y: Double(data.allForVaccine.peopleFullyVaccinated)))
                self.chartEntries.append(ChartDataEntry(x: 0, y: Double(data.allForVaccine.peoplePartiallyVaccinated) - Double(data.allForVaccine.peopleFullyVaccinated)))
                self.chartEntries.append(ChartDataEntry(x: 0, y: Double((data.allForVaccine.population) - (data.allForVaccine.peoplePartiallyVaccinated))))
                
                completion()
                
            case .failure(let error):
                print(error)
                completion()
            }
        }
        
    }
}
