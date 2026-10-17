//
//  CustomPlayerView.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import UIKit

@IBDesignable
class CustomPlayerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    private var isPlayed: Bool = false
    
    var onPlayPauseToggled: ((Bool) -> Void)?
    var onNextTapped: (() -> Void)?
    var onPreviousTapped: (() -> Void)?
    var onSliderValueChanged: ((Float) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomPlayerView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        
        centerButton.setImage(UIImage(named: "icon_play"), for: .normal)
    }
    
    func configure(isPlayed: Bool) {
        if isPlayed {
            centerButton.setImage(UIImage(named: "icon_pause"), for: .normal)
        } else {
            centerButton.setImage(UIImage(named: "icon_play"), for: .normal)
        }
    }
    
    func configure(sliderMaxValue: Float, sliderValue: Float) {
        slider.maximumValue = sliderMaxValue
        slider.value = sliderValue
    }
    
    func resetSlider() {
        configure(sliderMaxValue: 1, sliderValue: 0)
    }
    
    @IBAction private func prevTapped(_ sender: UIButton) {
        onPreviousTapped?()
    }

    @IBAction private func playPauseTapped(_ sender: UIButton) {
        isPlayed.toggle()
        let iconName = isPlayed ? "icon_play" : "icon_pause"
        centerButton.setImage(UIImage(named: iconName), for: .normal)
        onPlayPauseToggled?(isPlayed)
    }

    @IBAction private func nextTapped(_ sender: UIButton) {
        onNextTapped?()
    }

    @IBAction private func sliderChanged(_ sender: UISlider) {
        onSliderValueChanged?(sender.value)
    }
}
