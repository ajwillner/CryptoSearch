//
//  ViewController.swift
//  CryptoSearch
//
//  Created by Asher Willner on 7/30/19.
//  Copyright © 2019 Asher Willner. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Accelerate
import SVProgressHUD

class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cryptoLogoImage: UIImageView!
    @IBOutlet weak var cryptoTicker: UILabel!
    @IBOutlet weak var riskRewardScore: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currencyObjects = [Currency]()
    var counter = 0
    var longevity = ""
    var position = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadCurrencies()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyObjects.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            as! HeadlineTableViewCell
        
        let headline = currencyObjects[indexPath.row]
        cell.cryptoTicker?.text = headline.symbol
        cell.riskRewardScore?.text = "$" + String(headline.price)
        cell.cryptoLogoImage?.image = UIImage(named: headline.image)
       // cell.headlineImageView?.image = UIImage(named: headline.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "InfoPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoPage" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.currency = currencyObjects[position]
        }
        
    }


    func getBitcoinData(ticker: String, placeholder: Int, completion: @escaping () -> ()) {
        let url = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&allData=true"
//        if longevity == "Long" {
//            url = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&allData=true"
//        } else if longevity == "Medium" {
//            url = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&limit=100"
//
//        } else if longevity == "Short" {
//            url = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&limit=5"
//        }
        let url2 = "https://min-api.cryptocompare.com/data/price?fsym=\(ticker)&tsyms=USD"
        Alamofire.request(url2, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.currencyObjects[placeholder].price = bitcoinJSON["USD"].double!
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                var closeArray = [Double]()
                let bitcoinJSON : JSON = JSON(response.result.value!)
                let data = bitcoinJSON["Data"]
                self.currencyObjects[placeholder].age = data.count
                var count = data.count - 1
                while count >= 0 {
                    let closeValue = data[count]["close"].double!
                    closeArray.append(closeValue)
                    count -= 1
                }
                self.currencyObjects[placeholder].closeValuesArray = closeArray
                var reversedArray = [Double]()
                reversedArray = closeArray.reversed()
                var returns = [Double]()
                for i in 0...(reversedArray.count-2) {
                    let placeholder = log(reversedArray[i+1]/reversedArray[i])
                    returns.append(placeholder)
                }
                
                var mn = 0.0
                var sddev = 0.0
                vDSP_normalizeD(returns, 1, nil, 1, &mn, &sddev, vDSP_Length(returns.count))
                sddev *= sqrt(Double(returns.count)/Double(returns.count - 1))
                
                let std = round(sddev*1000)/1000
                let mean = round(mn*1000)/1000
                //                let standard = Sigma.standardDeviationSample(returns)
                //                print(std)
                self.currencyObjects[placeholder].std = std
                self.currencyObjects[placeholder].meanDailyReturn = mean
                self.currencyObjects[placeholder].sharpeRatio = mean / std
                //                print(std)
                //                SVProgressHUD.dismiss()
                //                self.priceLabel.text = String(round(sddev*1000)/1000)
                //
                if std < 0.05 {
                    self.currencyObjects[placeholder].risk = "Low Risk"
                } else if std < 0.1 {
                    self.currencyObjects[placeholder].risk = "Fair Risk"
                } else {
                    self.currencyObjects[placeholder].risk = "High Risk"
                }
                
//                print(self.currencyObjects[placeholder].symbol)
//                print(self.currencyObjects[placeholder].std)
                //                print(self.currencyObjects[placeholder].risk)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
            
        }
        self.tableView.reloadData()
        completion()
        
    }
    
    func loadCurrencies() {
        
        let BTC = Currency()
        currencyObjects.append(BTC)
        BTC.symbol = "BTC"
        BTC.image = "btc"
        getBitcoinData(ticker: BTC.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let ETH = Currency()
        currencyObjects.append(ETH)
        ETH.symbol = "ETH"
        ETH.image = "etc"
        getBitcoinData(ticker: ETH.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        
        let EOS = Currency()
        currencyObjects.append(EOS)
        EOS.symbol = "EOS"
        EOS.image = "eos"
        getBitcoinData(ticker: EOS.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        
        let LTC = Currency()
        currencyObjects.append(LTC)
        LTC.symbol = "LTC"
        LTC.image = "ltc"
        getBitcoinData(ticker: LTC.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let XRP = Currency()
        currencyObjects.append(XRP)
        XRP.symbol = "XRP"
        XRP.image = "xrp"
        getBitcoinData(ticker: XRP.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let BCH = Currency()
        currencyObjects.append(BCH)
        BCH.symbol = "BCH"
        BCH.image = "bch"
        getBitcoinData(ticker: BCH.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let BGG = Currency()
        currencyObjects.append(BGG)
        BGG.symbol = "BGG"
        BGG.image = "bgg"
        getBitcoinData(ticker: BGG.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let BNB = Currency()
        currencyObjects.append(BNB)
        BNB.symbol = "BNB"
        BNB.image = "bnb"
        getBitcoinData(ticker: BNB.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let TRX = Currency()
        currencyObjects.append(TRX)
        TRX.symbol = "TRX"
        TRX.image = "trx"
        getBitcoinData(ticker: TRX.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let ETC = Currency()
        currencyObjects.append(ETC)
        ETC.symbol = "ETC"
        ETC.image = "etc"
        getBitcoinData(ticker: ETC.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let ZEC = Currency()
        currencyObjects.append(ZEC)
        ZEC.symbol = "ZEC"
        ZEC.image = "zec"
        getBitcoinData(ticker: ZEC.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let BSV = Currency()
        currencyObjects.append(BSV)
        BSV.symbol = "BSV"
        BSV.image = "bsv"
        getBitcoinData(ticker: BSV.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let NEO = Currency()
        currencyObjects.append(NEO)
        NEO.symbol = "NEO"
        NEO.image = "neo"
        getBitcoinData(ticker: NEO.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let QTUM = Currency()
        currencyObjects.append(QTUM)
        QTUM.symbol = "QTUM"
        QTUM.image = "qtum"
        getBitcoinData(ticker: QTUM.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let USDT = Currency()
        currencyObjects.append(USDT)
        USDT.symbol = "USDT"
        USDT.image = "usdt"
        getBitcoinData(ticker: USDT.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let ZB = Currency()
        currencyObjects.append(ZB)
        ZB.symbol = "ZB"
        ZB.image = "zb"
        getBitcoinData(ticker: ZB.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let ONT = Currency()
        currencyObjects.append(ONT)
        ONT.symbol = "ONT"
        ONT.image = "ont"
        getBitcoinData(ticker: ONT.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let DASH = Currency()
        currencyObjects.append(DASH)
        DASH.symbol = "DASH"
        DASH.image = "dash"
        getBitcoinData(ticker: DASH.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        let ADA = Currency()
        currencyObjects.append(ADA)
        ADA.symbol = "ADA"
        ADA.image = "ada"
        getBitcoinData(ticker: ADA.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter+=1

        
        let XLM = Currency()
        currencyObjects.append(XLM)
        XLM.symbol = "XLM"
        XLM.image = "xlm"
        getBitcoinData(ticker: XLM.symbol, placeholder: counter) {
            self.tableView.reloadData()
        }
        counter=0
        
    }


}

