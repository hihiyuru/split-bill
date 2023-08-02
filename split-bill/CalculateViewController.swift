//
//  CalculateViewController.swift
//  split-bill
//
//  Created by 徐于茹 on 2023/8/1.
//

import UIKit
import OSLog

class CalculateViewController: UIViewController {
    let logger = Logger()
    
    var currentNumber = 0
    var people = 1
    var percent = 0
    var isClear = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var personSlider: UISlider!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var smallTatolLabel: UILabel!
    
    @IBOutlet weak var smallPeopleLabel: UILabel!
    @IBOutlet weak var smallTipLabel: UILabel!
    @IBOutlet var percentButtons: [UIButton]!
    @IBOutlet var selectedTagImageView: [UIImageView]!
    @IBOutlet weak var splitBillButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlider()
        setPercentButton()
        setSelectedTagImageView()
        splitButton.backgroundColor = UIColor(cgColor: CGColor(red: 15/255, green: 186/255, blue: 70/255, alpha: 1))
        selectedTagImageView[0].isHidden = false
    }
    
    func setSelectedTagImageView() {
        for tag in selectedTagImageView {
            tag.isHidden = true
        }
    }
    
    func setPercentButton() {
        for percent in percentButtons {
            percent.layer.borderWidth = 1.0
            percent.layer.borderColor = UIColor.gray.cgColor
            percent.layer.cornerRadius = 5.0
        }
    }
    
    func setSlider(){
        personSlider.minimumValue = 1
        personSlider.maximumValue = 40
        personSlider.setMinimumTrackImage(UIImage(named: "green_track"), for: .normal)
        personSlider.setMaximumTrackImage(UIImage(named: "gray_track"), for: .normal)
        personSlider.setThumbImage(UIImage(named: "thumb"), for: .normal)
    }
    
    func changeNumber(addNumber: Int) {
        logger.log("按幾號\(addNumber)")
        
        let stringCurrentNumber: String = currentNumber == 0 && currentNumber / 10 < 1 ? "\(addNumber)" : "\(currentNumber)\(addNumber)"
        
        logger.log("多少\(stringCurrentNumber)")
        if let customNumber = Int(stringCurrentNumber) {
            currentNumber = customNumber
            totalLabel.text = stringCurrentNumber
            smallTatolLabel.text = "NT$\(stringCurrentNumber)"
        }
        
    }
    
    func calculate() {
        let currentPercent = Float(percent) * (1 / 100)
        let currentTip = Float(currentNumber) * currentPercent
        let splitAmount = (Float(currentNumber) +  currentTip) / Float(people)
        logger.log("分攤的錢\(splitAmount)")
        smallTipLabel.text = "NT$\(Int(round(currentTip)))"
        titleLabel.text = "‼️分攤金額"
        totalLabel.text = "\(Int(round(splitAmount)))"
    }
    
    func initLayout() {
        splitButton.backgroundColor = UIColor(cgColor: CGColor(red: 15/255, green: 186/255, blue: 70/255, alpha: 1))
        splitButton.setTitle("分帳", for: .normal)
        currentNumber = 0
        people = 1
        percent = 0
        totalLabel.text = "0"
        smallTatolLabel.text = "NT$0"
        smallPeopleLabel.text = "1"
        smallTipLabel.text = "NT$0"
        personSlider.value = 1
        peopleLabel.text = "1"
        titleLabel.text = "總額"
        setSelectedTagImageView()
        selectedTagImageView[0].isHidden = false
        isClear = false
    }
    
    @IBAction func onClickNumber(_ sender: UIButton) {
        changeNumber(addNumber: sender.tag)
    }
    
    
    @IBAction func changePerson(_ sender: UISlider) {
        peopleLabel.text = String(Int(sender.value))
        logger.log("人數\(Int(sender.value))")
        people = Int(sender.value)
        smallPeopleLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func selectPercent(_ sender: UIButton) {
        setSelectedTagImageView()
        switch sender.tag {
        case 0:
            selectedTagImageView[0].isHidden = false
        case 5:
            selectedTagImageView[1].isHidden = false
        case 10:
            selectedTagImageView[2].isHidden = false
        case 20:
            selectedTagImageView[3].isHidden = false
        default:
            selectedTagImageView[0].isHidden = false
        }
        percent = sender.tag
    }
    
    @IBAction func splitOrClear(_ sender: UIButton) {
        if currentNumber != 0, !isClear {
            sender.backgroundColor = UIColor.red
            sender.setTitle("重新計算", for: .normal)
            calculate()
            isClear = true
        } else if (isClear) {
            
            initLayout()
            
        } else {
            let alertController = UIAlertController(title: "提示", message: "請輸入總金額", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            isClear = false
        }
    }
    
    @IBAction func deletNumber(_ sender: Any) {
        var stringCurrentNumber = "\(currentNumber)"
        stringCurrentNumber.removeLast()
        currentNumber = Int(stringCurrentNumber) ?? 0
        totalLabel.text = currentNumber == 0 ? "0" : stringCurrentNumber
        logger.log("??\(self.currentNumber)")
    }
    
    @IBAction func allDelet(_ sender: Any) {
        initLayout()
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
    }
}
