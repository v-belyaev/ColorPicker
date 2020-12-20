//
//  ColorPickerViewController.swift
//  ColorPicker
//
//  Created by Владимир Беляев on 20.12.2020.
//

import UIKit

protocol ColorPickerViewControllerDelegate: class {
    func updateUI()
}

class ColorPickerViewController: UIViewController {

    // MARK: - Properties
    var model: BackgroundColorModel!
    weak var delegate: ColorPickerViewControllerDelegate?
    
    // MARK: - IB Outlets
    @IBOutlet var backgroundColorView: UIView! {
        didSet {
            backgroundColorView.layer.cornerRadius = 12
            backgroundColorView.layer.shadowColor = UIColor.black.cgColor
            backgroundColorView.layer.shadowOpacity = 0.1
            backgroundColorView.layer.shadowOffset = .zero
            backgroundColorView.layer.shadowRadius = 10
        }
    }
    
    @IBOutlet var doneButton: UIButton! {
        didSet {
            doneButton.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    // MARK: - Init/Deinit
    deinit {
        print("ColorPickerViewController deinit")
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - IB Actions
    @IBAction func doneButtonDidTapped(_ sender: UIButton) {
        delegate?.updateUI()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderDidMoved(_ sender: UISlider) {
        updateModelFromSlidersValue(sender)
    }
    
}

// MARK: - UITextFieldDelegate
extension ColorPickerViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateModelFromTextFieldsValue()
        return self.view.endEditing(true)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return true }
        
        if let char = string.cString(using: String.Encoding.utf8), strcmp(char, "\\b") == -92 {
            return true
        }
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet) && text.count < 4
    }
}

// MARK: - Private
extension ColorPickerViewController {
    private func updateUI() {
        let (red, green, blue) = model.getCurrentColorValues()
        
        backgroundColorView.backgroundColor = model.getCurrentColor()
        
        redValueLabel.text = String(format: "%.2f", red)
        greenValueLabel.text = String(format: "%.2f", green)
        blueValueLabel.text = String(format: "%.2f", blue)
        
        redTextField.text = String(format: "%.2f", red)
        greenTextField.text = String(format: "%.2f", green)
        blueTextField.text = String(format: "%.2f", blue)
        
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
    }
    
    private func updateModelFromSlidersValue(_ sender: UISlider) {
        switch sender {
        case redSlider:
            model.setNewColorFrom(red: CGFloat(sender.value)) { [weak self] in
                self?.updateUI()
            }
        case greenSlider:
            model.setNewColorFrom(green: CGFloat(sender.value)) { [weak self] in
                self?.updateUI()
            }
        case blueSlider:
            model.setNewColorFrom(blue: CGFloat(sender.value)) { [weak self] in
                self?.updateUI()
            }
        default:
            break
        }
    }
    
    private func updateModelFromTextFieldsValue() {
        guard
            let redValue = redTextField.text,
            let greenValue = greenTextField.text,
            let blueValue = blueTextField.text
        else { return }
        
        let red = (redValue as NSString).floatValue
        let green = (greenValue as NSString).floatValue
        let blue = (blueValue as NSString).floatValue
        
        self.model.setNewColorFrom(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue)) { [weak self] in
            self?.updateUI()
        }
    }
}
