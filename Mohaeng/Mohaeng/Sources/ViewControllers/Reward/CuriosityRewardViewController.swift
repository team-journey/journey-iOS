//
//  CuriosityRewardViewController.swift
//  Mohaeng
//
//  Created by 김윤서 on 2021/10/19.
//

import UIKit

class CuriosityRewardViewController: RewardBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setUp() {
        type = .curiosity
    }
    
    // TODO : - 플로우에 따라 분기처리
    override func touchButton() {
        navigationController?.pushViewController(WritingRewardViewController(), animated: true)
    }
    
    override func touchSubButton() {
        
    }

}
