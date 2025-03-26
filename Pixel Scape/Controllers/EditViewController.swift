//
//  EditViewController.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 20/03/2025.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var fontPickerView: UIPickerView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var colorPicker: UIColorWell!
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var sliderView: UIView!
    
    private var imageText: UITextView!
    private var doneButton: UIButton!
    private var editButton: UIButton!
    private let availableFonts = UIFont.familyNames.sorted()
    private var frameHeight = CGFloat(0)
    
    var imageUrl: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        continueButton.layer.cornerRadius = 20
        imageView.layer.cornerRadius = 10
        pickerView.layer.cornerRadius = 10
        sliderView.layer.cornerRadius = 10
        image.layer.cornerRadius = 10
        
        fontPickerView.delegate = self
        fontPickerView.dataSource = self
        
        pickerView.isHidden = true
        
        setupTextView()
        setupColorWell()
        setUpButtons()
        setUpImageView()
    }
    
    private func setUpImageView() {
        if let imageUrl {
            guard let url = URL(string: imageUrl) else { return }
            
            // Fetch image asynchronously
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, let data = data, error == nil else { return }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image.image = image
                    }
                }
            }.resume()
        }
    }
    
    private func setUpButtons() {
        editButton = UIButton()
        editButton.setImage(UIImage(systemName: "applepencil.and.scribble"), for: .normal)
        editButton.backgroundColor = .tertiaryShade
        editButton.setTitleColor(.textShade, for: .normal)
        editButton.layer.cornerRadius = 10
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.tintColor = .textShade
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        doneButton = UIButton()
        doneButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        doneButton.backgroundColor = .tertiaryShade
        doneButton.setTitleColor(.textShade, for: .normal)
        doneButton.layer.cornerRadius = 10
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.tintColor = .textShade
        doneButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        view.addSubview(doneButton)
        view.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            // Button 1 (Top-Right)
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Button 2 (Below Button 1)
            doneButton.trailingAnchor.constraint(equalTo: editButton.trailingAnchor),
            doneButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 10),
            doneButton.widthAnchor.constraint(equalTo: editButton.widthAnchor),
            doneButton.heightAnchor.constraint(equalTo: editButton.heightAnchor)
        ])
    }
    
    private func setupTextView() {
        imageText = UITextView()
        imageText.backgroundColor = .clear
        imageText.textAlignment = .center
        imageText.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        imageText.textColor = .white
        imageText.isScrollEnabled = false  // Auto-expanding
        imageText.delegate = self
        
        // Add textView to view
        view.addSubview(imageText)
        
        // Enable Auto Layout
        imageText.translatesAutoresizingMaskIntoConstraints = false

        // Set Constraints (adjust these as needed)
        NSLayoutConstraint.activate([
            imageText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageText.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        // Setup Gesture Recognizer for Moving Text
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageText.isUserInteractionEnabled = true
        imageText.addGestureRecognizer(panGesture)
    }

    
    private func setupColorWell() {
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = imageText.textColor
        colorPicker.addTarget(self, action: #selector(colorChanged(_:)), for: .valueChanged)
    }
    
    @objc func colorChanged(_ sender: UIColorWell) {
        imageText.textColor = sender.selectedColor
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let textView = gesture.view as? UITextView else { return }
        
        let translation = gesture.translation(in: view)
        textView.center = CGPoint(x: textView.center.x + translation.x, y: textView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc private func didTapNextButton() {
        //handle sharing image
    }

    @objc private func didTapEditButton() {
        doneButton.isEnabled = false
        pickerView.isHidden = false
        imageText.isUserInteractionEnabled = false
        imageText.becomeFirstResponder()
    }


    @IBAction func didChangeFontSize(_ sender: UISlider) {
        let newSize = CGFloat(sender.value * 100)
        imageText.font = imageText.font?.withSize(newSize)
        imageText.frame.size.height = frameHeight
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        doneButton.isEnabled = true
        pickerView.isHidden = true
        imageText.isUserInteractionEnabled = true
    }
    
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableFonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFont = availableFonts[row]
        imageText.font = UIFont(name: selectedFont, size: CGFloat(imageText.font?.pointSize ?? 0))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: availableFonts[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.textShade])
    }
    
}

extension EditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        textView.frame.size.height = newSize.height
        frameHeight = newSize.height
    }
}
