//
//  ViewController.swift
//  ColorPicker
//
//  Created by Владимир Беляев on 20.12.2020.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    private let colorPickerSegue = "showColorPicker"
    private let model = BackgroundColorModel()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorPickerViewController = segue.destination as? ColorPickerViewController else { return }
        colorPickerViewController.delegate = self
        colorPickerViewController.model = model
    }

    // MARK: - IB Actions
    @IBAction func editBarButtonDidTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: colorPickerSegue, sender: sender)
    }

}

// MARK: - ColorPickerViewControllerDelegate
extension MainViewController: ColorPickerViewControllerDelegate {
    func updateUI() {
        view.backgroundColor = model.getCurrentColor()
    }
}
