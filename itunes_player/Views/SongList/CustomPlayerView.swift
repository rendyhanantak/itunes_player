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
}
