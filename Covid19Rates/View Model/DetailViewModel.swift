//
//  DetailViewModel.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 18.02.2022.
//

import UIKit
import Charts

class DetailViewModel {
    
    let service = Webservice()
     
    //UI Api related properties
    var chartEntries = [ChartDataEntry]()
    var lastDayArray = [Int]()
    var population = ""
    var lastDayCases = ""
    var confirmedCases = ""
    var confirmedDeath = ""
    var location = ""
    var capitalCity = ""
    
    func loadData(_ country: String, completion: @escaping() -> ()) {

        guard let url = URL(string: "https://covid-api.mmediagroup.fr/v1/history?country=\(country)&status=Confirmed") else { return }
        let resource = Resource<DeathRate>(url: url)
        
        service.fetchData(resource: resource) { result in
            
            switch result {
            case .success(let data):
                
                //Population op.
                self.population = data.allForDetail.population.IntToDecimals(number: data.allForDetail.population)
                
                for (key, value) in data.allForDetail.dates {
                    //Chart entries operations
                    self.chartEntries.append(BarChartDataEntry(x: ((key.stringToDateToDouble(toDouble: key)) / (60 * 60 * 24)) - 6959.875, y: Double(value)))
                    self.chartEntries = Array(self.chartEntries).sorted { $0.x < $1.x }
                    //Last day cases implementation
                    self.lastDayArray.append(value)

                }
                //Last day cases more
                let myArray = self.lastDayArray.sorted { $0 > $1 }
                self.lastDayCases = (myArray[0] - myArray[1]).IntToDecimals(number: (myArray[0] - myArray[1]))
                
                completion()
                
            case .failure(let error):
                print(error)
                completion()
            }
        }
        
    }
    
    func loadFutherData(_ country: String, completion: @escaping() -> ()) {
        
        guard let url = URL(string: "https://covid-api.mmediagroup.fr/v1/cases?country=\(country)") else { return }
        let resource = Resource<DataModel>(url: url)
        
        service.fetchData(resource: resource) { result in
            
            switch result {
            case .success(let data):
                //Further datas
                self.location = data.all.location
                self.capitalCity = data.all.capitalCity
                self.confirmedCases = data.all.confirmed.IntToDecimals(number: data.all.confirmed)
                self.confirmedDeath = data.all.deaths.IntToDecimals(number: data.all.deaths)
                                
                completion()
                
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
}

