//
//  MainViewModel.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 21.02.2022.
//

import UIKit

struct MainViewModel {
    
    var countryNameArray: [String] = ["Afghanistan", "Albania", "Austria", "Azerbaijan", "Bangladesh", "Canada", "China", "Denmark", "France", "Turkey", "Russia", "United Kingdom", "US"]
    
    func numberOfItems() -> Int {
        return self.countryNameArray.count
    }
    
    func cellForItem(_ index: Int) -> String {
        let country = self.countryNameArray[index]
        return country
    }
}
