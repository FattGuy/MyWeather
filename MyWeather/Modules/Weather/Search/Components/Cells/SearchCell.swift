//
//  SearchCell.swift
//  MyWeather
//
//  Created by Feng Chang on 3/31/23.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var weatherInfo: WeatherInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupDesign() {
        titleLabel.textColor = .black
    }
    
    func configure(for weatherInfo: WeatherInfo) {
        self.weatherInfo = weatherInfo
        setupLabel()
    }
    
    private func setupLabel() {
        titleLabel.text = weatherInfo?.name
    }
}
