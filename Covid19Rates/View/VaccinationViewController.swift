//
//  VaccinationViewController.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 12.02.2022.
//

import UIKit
import Charts

class VaccinationViewController: UIViewController, ChartViewDelegate {
    
    lazy var pieChart: PieChartView = {
        let pcView = PieChartView()
        pcView.backgroundColor = .systemBlue
        pcView.layer.cornerRadius = 20
        pcView.clipsToBounds = true
        pcView.holeColor = .white
        pcView.animate(yAxisDuration: 2.5)

        return pcView
    }()
    
    private var vaccinationBackground = UIView()
    private var exitButton = UIButton()
    private var chartBackground = UIView()
    private var vaccinationDetailView = UIView()
    private var loadingAnimation = UIActivityIndicatorView()

    public var isLoadingAnimation: Bool? {
        didSet {
            if isLoadingAnimation! {
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
    
    
    private var chartEntries = [ChartDataEntry]()
    private var fully = ""
    private var partially = ""
    private var population = ""
    public var countryName = ""
    
    private var vaccinationVM = VaccinationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configureUI()
        loadData()
    }
    // Chart also can be separeted from the view(like labels). Because like that it is gonna be more smooth transition on view after data loads!!!
    private func loadData() {
        
        vaccinationVM.loadData(countryName) {
            DispatchQueue.main.async {
                
                self.fully = self.vaccinationVM.fullyVac
                self.partially = self.vaccinationVM.partiallyVac
                self.population = self.vaccinationVM.population
                self.chartEntries = self.vaccinationVM.chartEntries
                
                self.setChartData()
                self.pieChart.animate(xAxisDuration: 2)
                self.isLoadingAnimation = false
                self.configureUI()
                self.configureDetail()
            }
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("entry")
    }
    
    private func setChartData() {
        let dataSet = PieChartDataSet(entries: chartEntries, label: "Vaccination rates compared to the population")
        dataSet.colors = ChartColorTemplates.material()
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
    }
    
    private func configureUI() {
        
        view.backgroundColor = .clear
        view.addSubview(vaccinationBackground)
        vaccinationBackground.translatesAutoresizingMaskIntoConstraints = false
        vaccinationBackground.heightAnchor.constraint(equalToConstant: 550).isActive = true
        vaccinationBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true
        vaccinationBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        vaccinationBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        vaccinationBackground.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        vaccinationBackground.layer.cornerRadius = 30
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.bottomAnchor.constraint(equalTo: vaccinationBackground.topAnchor, constant: -10).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: vaccinationBackground.trailingAnchor, constant: -20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        exitButton.backgroundColor = .secondarySystemBackground
        exitButton.setTitle("X", for: .normal)
        exitButton.setTitleColor(.black, for: .normal)
        exitButton.layer.cornerRadius = 30
        exitButton.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        
        vaccinationBackground.addSubview(chartBackground)
        chartBackground.translatesAutoresizingMaskIntoConstraints = false
        chartBackground.topAnchor.constraint(equalTo: vaccinationBackground.topAnchor, constant: 30).isActive = true
        chartBackground.leadingAnchor.constraint(equalTo: vaccinationBackground.leadingAnchor, constant: 20).isActive = true
        chartBackground.trailingAnchor.constraint(equalTo: vaccinationBackground.trailingAnchor, constant: -20).isActive = true
        chartBackground.heightAnchor.constraint(equalToConstant: 270).isActive = true
        chartBackground.backgroundColor = .white
        chartBackground.layer.cornerRadius = 20
        
        pieChart.delegate = self
        chartBackground.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.topAnchor.constraint(equalTo: chartBackground.topAnchor, constant: 10).isActive = true
        pieChart.bottomAnchor.constraint(equalTo: chartBackground.bottomAnchor, constant: -10).isActive = true
        pieChart.leadingAnchor.constraint(equalTo: chartBackground.leadingAnchor, constant: 10).isActive = true
        pieChart.trailingAnchor.constraint(equalTo: chartBackground.trailingAnchor, constant: -10).isActive = true
        
        vaccinationBackground.addSubview(vaccinationDetailView)
        vaccinationDetailView.translatesAutoresizingMaskIntoConstraints = false
        vaccinationDetailView.topAnchor.constraint(equalTo: chartBackground.bottomAnchor, constant: 20).isActive = true
        vaccinationDetailView.leadingAnchor.constraint(equalTo: vaccinationBackground.leadingAnchor,constant: 20).isActive = true
        vaccinationDetailView.trailingAnchor.constraint(equalTo: vaccinationBackground.trailingAnchor, constant: -20).isActive = true
        vaccinationDetailView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        vaccinationDetailView.backgroundColor = .white
        vaccinationDetailView.layer.cornerRadius = 15
        
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
    
    private func configureDetail() {
        
        let fullyLabel = makeLabel()
        vaccinationDetailView.addSubview(fullyLabel)
        fullyLabel.topAnchor.constraint(equalTo: vaccinationDetailView.topAnchor, constant: 30).isActive = true
        fullyLabel.leadingAnchor.constraint(equalTo: vaccinationDetailView.leadingAnchor, constant: 20).isActive = true
        fullyLabel.text = "Fully Vaccinated People: \(fully)"
        
        let partiallyLabel = makeLabel()
        vaccinationDetailView.addSubview(partiallyLabel)
        partiallyLabel.topAnchor.constraint(equalTo: fullyLabel.bottomAnchor, constant: 10).isActive = true
        partiallyLabel.leadingAnchor.constraint(equalTo: vaccinationDetailView.leadingAnchor, constant: 20).isActive = true
        partiallyLabel.text = "Partially Vaccinated People: \(partially)"
        
        let populationLabel = makeLabel()
        vaccinationDetailView.addSubview(populationLabel)
        populationLabel.topAnchor.constraint(equalTo: partiallyLabel.bottomAnchor, constant: 10).isActive = true
        populationLabel.leadingAnchor.constraint(equalTo: vaccinationDetailView.leadingAnchor, constant: 20).isActive = true
        populationLabel.text = "Total Population: \(population)"
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0.7
        label.sizeToFit()
        label.contentMode = .scaleAspectFit
        return label
    }
    
    @objc private func exitAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
