//
//  OnBoarding4ViewController.swift
//  Mohaeng
//
//  Created by 김윤서 on 2021/10/12.
//

import UIKit

import SnapKit
import Then

class OnBoarding4ViewController: UIViewController {
    
// MARK: - Properties
  
    private let label = UILabel().then {
        $0.font = .gmarketFont(weight: .medium, size: 16)
        $0.numberOfLines = 0
        $0.makeTyping(text: """
                오늘의 챌린지를 인증하고 나서
                하루에 한 번씩 안부를 작성할 수 있어.
                
                챌린지를 하면서 느꼈던 사소한 것도 괜찮아.
                자유롭게 안부를 남겨봐~
                """, highlightedText: "안부")
    }
    
    private let feedImageView = UIImageView().then {
        $0.image = Const.Image.feedEx
        $0.dropShadow(rounded: 20)
        $0.alpha = 0
        $0.makeMoveUpWithFade()
    }
    
    let characterImageView = UIImageView().then {
        $0.image = Const.Image.grpXonboarding5
        $0.alpha = 0
        $0.makeMoveUpWithFade()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        setLayout()
        addAnimation()
        
    }
    
 // MARK: - View Life Cycle

    private func initViewController() {
        view.backgroundColor = .White
    }
    
    private func addAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
            self?.navigationController?.pushViewController(OnBoarding5ViewController(), animated: true)
        }
    }
    
    private func setLayout() {
        setViewHierachy()
        setConstraints()
    }
    
    private func setViewHierachy() {
        view.addSubviews(label, feedImageView, characterImageView)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIDevice.current.hasNotch ? 44 : 32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        feedImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(feedImageView.snp.width).multipliedBy(1.2)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIDevice.current.hasNotch ? 208 : 174)
            $0.centerX.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints {
            $0.width.height.equalTo(160)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(feedImageView.snp.bottom).offset(44)
        }
    }
    
}
