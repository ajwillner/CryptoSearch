//
//  Currency.swift
//  CryptoCalc
//
//  Created by Asher Willner on 7/16/19.
//  Copyright © 2019 Asher Willner. All rights reserved.
//

import Foundation

class Currency {
    var symbol : String = ""
    var std : Double = 0
    var risk : String = ""
    var age : Int = 0
    var meanDailyReturn : Double = 0
    var sharpeRatio : Double = 0
    var price : Double = 0
    var image : String = ""
    var closeValuesArray = [Double]()
}
