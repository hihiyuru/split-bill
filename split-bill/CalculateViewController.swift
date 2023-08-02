//
//  CalculateViewController.swift
//  split-bill
//
//  Created by 徐于茹 on 2023/8/1.
//

import UIKit

class CalculateViewController: UIViewController {
    
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
        setupUI()
    }
    
    func setupUI() {
        setupSlider()
        setupPercentButtons()
        hideSelectedTagImageViews()
        // 初始化 Split 按鈕樣式
        splitButton.backgroundColor = UIColor(red: 15/255, green: 186/255, blue: 70/255, alpha: 1)
        selectedTagImageView[0].isHidden = false
    }
    
    func setupSlider() {
        // 設置人數選擇的 Slider 屬性
        personSlider.minimumValue = 1
        personSlider.maximumValue = 40
        personSlider.setMinimumTrackImage(UIImage(named: "green_track"), for: .normal)
        personSlider.setMaximumTrackImage(UIImage(named: "gray_track"), for: .normal)
        personSlider.setThumbImage(UIImage(named: "thumb"), for: .normal)
    }
    
    func setupPercentButtons() {
        // 設置百分比按鈕樣式
        for percentButton in percentButtons {
            percentButton.layer.borderWidth = 1.0
            percentButton.layer.borderColor = UIColor.gray.cgColor
            percentButton.layer.cornerRadius = 5.0
        }
    }
    
    func hideSelectedTagImageViews() {
        // 隱藏所有標籤圖像視圖
        for tagImageView in selectedTagImageView {
            tagImageView.isHidden = true
        }
    }
    
    // MARK: - UI Update
    
    func updateUI() {
        // 計算並更新 UI
        let currentPercent = Float(percent) * (1 / 100)
        let currentTip = Float(currentNumber) * currentPercent
        let splitAmount = (Float(currentNumber) + currentTip) / Float(people)
        
        smallTipLabel.text = "NT$\(Int(round(currentTip)))"
        titleLabel.text = "‼️分攤金額"
        totalLabel.text = "\(Int(round(splitAmount)))"
    }
    
    func resetUI() {
        // 重置 UI 到初始狀態
        splitButton.backgroundColor = UIColor(red: 15/255, green: 186/255, blue: 70/255, alpha: 1)
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
        hideSelectedTagImageViews()
        selectedTagImageView[0].isHidden = false
        isClear = false
    }
    
    // MARK: - Button Actions
    
    @IBAction func onClickNumber(_ sender: UIButton) {
        // 按下數字按鈕，更新目前輸入的金額
        let number = sender.tag
        currentNumber = currentNumber * 10 + number
        totalLabel.text = "\(currentNumber)"
        smallTatolLabel.text = "NT$\(currentNumber)"
    }
    
    @IBAction func changePerson(_ sender: UISlider) {
        // 變更人數選擇，更新 UI
        people = Int(sender.value)
        peopleLabel.text = "\(people)"
        smallPeopleLabel.text = "\(people)"
    }
    
    @IBAction func selectPercent(_ sender: UIButton) {
        hideSelectedTagImageViews()
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
            // 進行分攤計算
            sender.backgroundColor = UIColor.red
            sender.setTitle("重新計算", for: .normal)
            updateUI()
            isClear = true
        } else if isClear {
            // 重置 UI
            resetUI()
        } else {
            // 顯示提示訊息
            let alertController = UIAlertController(title: "提示", message: "請輸入總金額", preferredStyle: .alert)
            
            // 添加提示訊息的按鈕
            let okAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            isClear = false
        }
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        // 刪除輸入的最後一個數字
        if currentNumber >= 10 {
            currentNumber /= 10
        } else {
            currentNumber = 0
        }
        totalLabel.text = "\(currentNumber)"
    }
    
    @IBAction func clearAll(_ sender: Any) {
        // 重置所有 UI
        resetUI()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        // 收起鍵盤
        view.endEditing(true)
    }
}

