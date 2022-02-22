//
//  DetailViewController.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 8.02.2022.
//

import UIKit
import Charts

class DetailViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChart : LineChartView = {
        let lcView = LineChartView()
        lcView.backgroundColor = .systemBlue
        lcView.rightAxis.enabled = false
        lcView.layer.cornerRadius = 20
        lcView.clipsToBounds = true
        
        let yAxis = lcView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 8)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .insideChart
        
        let xAxis = lcView.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 8)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .white
        xAxis.labelPosition = .topInside
        
        return lcView
    }()
    
    var isLoading: Bool? {
        didSet {
            if isLoading! {
                loadingAnimation.startAnimating()
                view.isUserInteractionEnabled = false
                loadingAnimation.isHidden = false
            } else {
                loadingAnimation.stopAnimating()
                view.isUserInteractionEnabled = true
                loadingAnimation.isHidden = true
            }
        }
    }
    // UI Properties
    private var loadingAnimation = UIActivityIndicatorView()
    private var chartBackgroundView = UIView()
    private var detailBackgroundView = UIView()
    private var vaccinationRatesButton = UIButton()
    private var chartEntries = [ChartDataEntry]()
    
    private var lastCases = ""
    private var population = ""
    private var confirmedCase = ""
    private var confirmedDeath = ""
    private var capital = ""
    private var location = ""
    
    private var detailVM = DetailViewModel()
    lazy var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        loadData()
        loadFurtherData()
    }
    
    
    private func loadFurtherData() {
        
        self.detailVM.loadFutherData(self.country) {
            DispatchQueue.main.async {
                
                self.confirmedDeath = self.detailVM.confirmedDeath
                self.confirmedCase = self.detailVM.confirmedCases
                self.capital = self.detailVM.capitalCity
                self.location = self.detailVM.location
                
                self.configureDetail()

            }

        }
        
    }
    
    private func loadData() {
        
        self.detailVM.loadData(self.country) {
            
            DispatchQueue.main.async {
                
                self.population = self.detailVM.population
                self.lastCases = self.detailVM.lastDayCases
                self.chartEntries = self.detailVM.chartEntries
                
                self.lineChart.animate(xAxisDuration: 2.5)
                self.setChartData(self.chartEntries)
                self.isLoading = false
                
                self.configureDetail()
                self.configureUI()
            }
            
        }
        
        
        
    }
    
    private func setChartData(_ chartEntry: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: chartEntry, label: "Day numbers since Covid-19 began")
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.setColor(.white)
        dataSet.fill = Fill(color: .white)
        dataSet.fillAlpha = 0.8
        //        dataSet.drawFilledEnabled = true
        //        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        lineChart.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    
    @objc private func handleVaccinationRates() {
        let vaccinationVC = VaccinationViewController()
        vaccinationVC.countryName = country
        vaccinationVC.isLoadingAnimation = true
        let navVC = UINavigationController(rootViewController: vaccinationVC)
        present(navVC, animated: true, completion: nil)
    }
    
    // ALL UI Configuration
    
    private func configureDetail() {
        
        let lastDayCases = makeLabel()
        detailBackgroundView.addSubview(lastDayCases)
        lastDayCases.topAnchor.constraint(equalTo: detailBackgroundView.topAnchor, constant: 20).isActive = true
        lastDayCases.leadingAnchor.constraint(equalTo: detailBackgroundView.leadingAnchor, constant: 20).isActive = true
        lastDayCases.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lastDayCases.text = "Last Day Cases: \(lastCases)"
        
        let confirmedCases = makeLabel()
        detailBackgroundView.addSubview(confirmedCases)
        confirmedCases.topAnchor.constraint(equalTo: lastDayCases.bottomAnchor, constant: 10).isActive = true
        confirmedCases.leadingAnchor.constraint(equalTo: detailBackgroundView.leadingAnchor, constant: 20).isActive = true
        confirmedCases.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmedCases.text = "Confirmed Total Cases: \(confirmedCase)"
        
        let confirmedDeaths = makeLabel()
        detailBackgroundView.addSubview(confirmedDeaths)
        confirmedDeaths.topAnchor.constraint(equalTo: confirmedCases.bottomAnchor, constant: 10).isActive = true
        confirmedDeaths.leadingAnchor.constraint(equalTo: detailBackgroundView.leadingAnchor, constant: 20).isActive = true
        confirmedDeaths.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmedDeaths.text = "Confirmed Total Death: \(confirmedDeath)"
        
        let totalPopulation = makeLabel()
        detailBackgroundView.addSubview(totalPopulation)
        totalPopulation.topAnchor.constraint(equalTo: confirmedDeaths.bottomAnchor, constant: 30).isActive = true
        totalPopulation.leadingAnchor.constraint(equalTo: detailBackgroundView.leadingAnchor, constant: 20).isActive = true
        totalPopulation.font = UIFont.systemFont(ofSize: 14, weight: .light)
        totalPopulation.text = "Population: \(population)"
        
        let locationContinent = makeLabel()
        detailBackgroundView.addSubview(locationContinent)
        locationContinent.topAnchor.constraint(equalTo: totalPopulation.bottomAnchor, constant: 10).isActive = true
        locationContinent.leadingAnchor.constraint(equalTo: detailBackgroundView.leadingAnchor, constant: 20).isActive = true
        locationContinent.font = UIFont.systemFont(ofSize: 14, weight: .light)
        locationContinent.text = "Location: \(location)"
        
        let capitalCity = makeLabel()
        detailBackgroundView.addSubview(capitalCity)
        capitalCity.topAnchor.constraint(equalTo: locationContinent.bottomAnchor, constant: 10).isActive = true
        capitalCity.leadingAnchor.constraint(equalTo: detailBackgroundView.leadingAnchor, constant: 20).isActive = true
        capitalCity.font = UIFont.systemFont(ofSize: 14, weight: .light)
        capitalCity.text = "Capital City: \(capital)"
        
    }
    
    
    private func configureUI() {
        
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(exitPage))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        view.addSubview(chartBackgroundView)
        chartBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        chartBackgroundView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        chartBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        chartBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        chartBackgroundView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        chartBackgroundView.backgroundColor = .white
        chartBackgroundView.layer.cornerRadius = 20
        
        lineChart.delegate = self
        chartBackgroundView.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.topAnchor.constraint(equalTo: chartBackgroundView.topAnchor, constant: 10).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: chartBackgroundView.bottomAnchor, constant: -10).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: chartBackgroundView.leadingAnchor, constant: 10).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: chartBackgroundView.trailingAnchor, constant: -10).isActive = true
        
        view.addSubview(detailBackgroundView)
        detailBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        detailBackgroundView.topAnchor.constraint(equalTo: chartBackgroundView.bottomAnchor, constant: 20).isActive = true
        detailBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        detailBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        detailBackgroundView.heightAnchor.constraint(equalToConstant: (view.frame.height / 3) - 50).isActive = true
        detailBackgroundView.backgroundColor = .white
        detailBackgroundView.layer.cornerRadius = 20
        
        view.addSubview(vaccinationRatesButton)
        vaccinationRatesButton.translatesAutoresizingMaskIntoConstraints = false
        vaccinationRatesButton.topAnchor.constraint(equalTo: detailBackgroundView.bottomAnchor, constant: 30).isActive = true
        vaccinationRatesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vaccinationRatesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        vaccinationRatesButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        vaccinationRatesButton.backgroundColor = .red
        vaccinationRatesButton.layer.cornerRadius = 12
        vaccinationRatesButton.layer.borderWidth = 3
        vaccinationRatesButton.layer.borderColor = UIColor.white.cgColor
        vaccinationRatesButton.sizeToFit()
        vaccinationRatesButton.contentMode = .scaleToFill
        vaccinationRatesButton.setTitle("Vaccination Rates", for: .normal)
        vaccinationRatesButton.addTarget(self,
                                         action: #selector(handleVaccinationRates),
                                         for: .touchUpInside)
        
        view.addSubview(loadingAnimation)
        loadingAnimation.translatesAutoresizingMaskIntoConstraints = false
        loadingAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingAnimation.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingAnimation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingAnimation.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingAnimation.contentMode = .scaleAspectFill
        loadingAnimation.color = .black
        loadingAnimation.backgroundColor = .clear
        
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.alpha = 0.7
        label.sizeToFit()
        label.contentMode = .scaleAspectFit
        
        return label
    }
    
    @objc private func exitPage() {
        self.dismiss(animated: true, completion: nil)
    }
}
