//
//  ForecastCellController.swift
//  Weather
//
//  Created by Donald Riedl on 11/11/23.
//

import UIKit

class ForecastCellController: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // Put border on the bottom of each cell
    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        border.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(border)
    }
}
