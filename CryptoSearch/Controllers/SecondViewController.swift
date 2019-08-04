//
//  SecondViewController.swift
//  CryptoSearch
//
//  Created by Asher Willner on 8/1/19.
//  Copyright © 2019 Asher Willner. All rights reserved.
//

import UIKit
import SwiftChart
import AAInfographics

class SecondViewController: UIViewController {

    var currency = Currency()
    
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var whatOurAnalystsSay: UILabel!
    @IBOutlet weak var meanDailyReturn: UILabel!
    @IBOutlet weak var standardDeviation: UILabel!
    @IBOutlet weak var titleSymbol: UINavigationItem!
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let chart = Chart(frame: CGRect(x: 31, y: 150, width: 200, height: 100))
//        let series = ChartSeries(currency.closeValuesArray)
//        series.color = ChartColors.blueColor()
//        series.area = true
//        chart.add(series)
        
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.chartContainer.frame.size.height
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.chartContainer.addSubview(aaChartView)
        
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.easeInBack)
//            .xAxisLabelsEnabled(false)
//            .yAxisLabelsEnabled(true)
            .backgroundColor("#000000")
            .titleColor("#85bb65")
            .subtitleColor("#85bb65")
            .axisColor("#ffffff")
            .legendEnabled(false)
            .markerRadius(1)
            .title("Price - Last 30 Days")//The chart title
            .dataLabelEnabled(false) //Enable or disable the data labels. Defaults to false
//            .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
            .colorsTheme(["#85bb65","#ffc069","#06caf4","#7dffc0"])
            .series([
                AASeriesElement()
                    .name(currency.symbol)
                    .data(currency.closeValuesArray[0..<29].reversed()),
                ])
        aaChartView.aa_drawChartWithChartModel(aaChartModel)

        
        titleSymbol.title? = currency.symbol
        meanDailyReturn.text? = String(currency.meanDailyReturn)
        standardDeviation.text? = String(currency.std)
        currencyImage?.image = UIImage(named: currency.image)
        currencyPrice.text? = "$" + String(currency.price)
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
