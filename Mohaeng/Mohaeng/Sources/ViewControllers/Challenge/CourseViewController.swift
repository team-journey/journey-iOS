//
//  CourseViewController.swift
//  Journey
//
//  Created by 초이 on 2021/06/29.
//

import UIKit
import Moya

class CourseViewController: UIViewController {
    
    // MARK: - Properties

    // default data
    var course: TodayChallengeCourse = TodayChallengeCourse(id: 0, situation: 1, property: 0, title: "", totalDays: 0, currentDay: 0, year: "", month: "", date: "", challenges: [])

    var backgroundView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var headerView: ChallengeStampView?
    
    enum CourseViewUsage: Int {
        case course = 0, history
    }
    
    var courseViewUsage: CourseViewUsage = .course
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var courseTableViewToTopConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        registerXib()
        assignDelegation()
        initViewRounding()
        getCourse()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if courseViewUsage == .course {
            self.initHeaderView()
        } else if courseViewUsage == .history {
            courseTableView.contentInsetAdjustmentBehavior = .never
            hidesBottomBarWhenPushed = true
        }
    }
    
    // MARK: - Functions
    
    private func initNavigationBar() {
        
        if courseViewUsage == .course {
            self.navigationController?.initWithOneCustomButton(
                navigationItem: self.navigationItem,
                firstButtonImage: Const.Image.gnbIcnList,
                firstButtonClosure: #selector(touchLibraryButton(_:)))
            self.navigationItem.setHidesBackButton(true, animated: true)
        } else if courseViewUsage == .history {
            self.navigationController?.initWithBackButton()
        }
    }
    
    @objc func touchLibraryButton(_ sender: UIBarButtonItem) {
        let courseLibraryStoryboard = UIStoryboard(name: Const.Storyboard.Name.courseLibrary, bundle: nil)
        guard let courseLibraryViewController = courseLibraryStoryboard.instantiateViewController(withIdentifier: Const.ViewController.Identifier.courseLibrary) as? CourseLibraryViewController else {
            return
        }
        self.navigationController?.pushViewController(courseLibraryViewController, animated: true)
    }
    
    private func registerXib() {
        self.headerView = Bundle.main.loadNibNamed(Const.Xib.Name.challengeStampView, owner: self, options: nil)?.last as? ChallengeStampView
        
        courseTableView.register(UINib(nibName: Const.Xib.Name.firstDayTableViewCell, bundle: nil), forCellReuseIdentifier: Const.Xib.Identifier.firstDayTableViewCell)
        courseTableView.register(UINib(nibName: Const.Xib.Name.evenDayTableViewCell, bundle: nil), forCellReuseIdentifier: Const.Xib.Identifier.evenDayTableViewCell)
        courseTableView.register(UINib(nibName: Const.Xib.Name.oddDayTableViewCell, bundle: nil), forCellReuseIdentifier: Const.Xib.Identifier.oddDayTableViewCell)
        
        courseTableView.register(UINib(nibName: Const.Xib.Name.courseHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: Const.Xib.Identifier.courseHeaderView)
        courseTableView.register(UINib(nibName: Const.Xib.Name.courseFooterView, bundle: nil), forHeaderFooterViewReuseIdentifier: Const.Xib.Identifier.courseFooterView)
        
        courseTableView.register(UINib(nibName: Const.Xib.Name.courseHistoryHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: Const.Xib.Identifier.courseHistoryHeaderView)
    }
    
    private func assignDelegation() {
        courseTableView.delegate = self
        courseTableView.dataSource = self
        self.headerView?.challengePopUpProtocol = self
    }
    
    private func initViewRounding() {
    }
    
    private func initHeaderView() {
        let tabBarHeight = tabBarController?.tabBar.bounds.size.height ?? 0
        
        self.courseTableView.tableHeaderView = self.headerView
        self.courseTableView.tableHeaderView?.frame.size.height = UIScreen.main.bounds.height - topbarHeight - tabBarHeight
    }
    
    func updateData(data: TodayChallengeData) {
        self.course = data.course
        
        // header view
        self.headerView?.setData(data: data)
        // table view
        self.courseTableView.reloadData()
        
    }
    
    func findCourseProgressDay(challenges: [Challenge]) -> Int {
        var day = 0
        for challenges in challenges {
            if challenges.situation == 0 {
                return day
            }
            day += 1
        }
        return day
    }
    
}

// MARK: - UITableViewDelegate

extension CourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 250
        }
        
        return 160
    }
    
    // section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch courseViewUsage {
        case .course:
            return 132
        case .history:
            return 176
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch courseViewUsage {
        case .course:
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.Xib.Identifier.courseHeaderView) as? CourseHeaderView {
                
                let headerBgView: UIView = {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 132))
                    view.backgroundColor = .white
                    view.makeRoundedSpecificCorner(corners: [.bottomLeft, .bottomRight], cornerRadius: 10)
                    
                    return view
                }()
                
                headerView.backgroundView = headerBgView
                // TODO: - shadow refactoring
                headerView.layer.shadowOpacity = 0.12
                headerView.layer.shadowRadius = 0
                headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
                headerView.layer.shadowColor = UIColor.black.cgColor
                
                return headerView
            }
        case .history:
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.Xib.Identifier.courseHistoryHeaderView) as? CourseHistoryHeaderView {
                
                let headerBgView: UIView = {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 176))
                    view.backgroundColor = .white
                    view.makeRoundedSpecificCorner(corners: [.bottomLeft, .bottomRight], cornerRadius: 25)
                    
                    return view
                }()
                
                headerView.backgroundView = headerBgView
                // TODO: - shadow refactoring
                headerView.layer.shadowOpacity = 0.12
                headerView.layer.shadowRadius = 2
                headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
                headerView.layer.shadowColor = UIColor.black.cgColor
                
                return headerView
            }
        }
        return UIView()
    }
    
    // section footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 95
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.Xib.Identifier.courseFooterView) as? CourseFooterView {
            if course.challenges.count > 1 {
                if course.challenges[course.challenges.count - 1].situation == 2 {
                    footerView.setIslandImage(isDone: true)
                    footerView.initLastPath(isDone: true)
                } else {
                    footerView.setIslandImage(isDone: false)
                    footerView.initLastPath(isDone: false)
                }
                footerView.setNextButton(isOnboarding: false)
            }
            return footerView
        }
        return UIView()
    }
}

// MARK: - UITableViewDataSource

extension CourseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if let cell = courseTableView.dequeueReusableCell(withIdentifier: Const.Xib.Identifier.firstDayTableViewCell) as? FirstDayTableViewCell {
                
                cell.setCell(challenge: course.challenges[indexPath.row], property: course.property)
                cell.setNextSituation(next: course.challenges[indexPath.row + 1].situation)
                return cell
            }
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 1 {
            // 짝수일차
            if let cell = courseTableView.dequeueReusableCell(withIdentifier: Const.Xib.Identifier.evenDayTableViewCell) as? EvenDayTableViewCell {
                
                cell.setCell(challenge: course.challenges[indexPath.row], property: course.property)
                
                if indexPath.row < course.challenges.count-1 {
                    cell.setNextSituation(next: course.challenges[indexPath.row + 1].situation)
                }
                
                return cell
            }
            return UITableViewCell()
        } else {
            // 홀수일차
            if let cell = courseTableView.dequeueReusableCell(withIdentifier: Const.Xib.Identifier.oddDayTableViewCell) as? OddDayTableViewCell {
                
                cell.setCell(challenge: course.challenges[indexPath.row], property: course.property)
                
                if indexPath.row < course.challenges.count-1 {
                    cell.setNextSituation(next: course.challenges[indexPath.row + 1].situation)
                } else {
                    // 맨 마지막 cell일 때
                    cell.setNextSituation(next: 9)
                }
                
                return cell
            }
            return UITableViewCell()
        }
    }
}

// MARK: - ChallengePopUpProtocol

extension CourseViewController: ChallengePopUpProtocol {
    
    func touchHelpButton(_ sender: UIButton) {
        let helpPopUp = ChallengeHelpPopUpViewController()
        helpPopUp.modalTransitionStyle = .crossDissolve
        helpPopUp.modalPresentationStyle = .overCurrentContext
        helpPopUp.challengePopUpProtocol = self
        
        tabBarController?.present(helpPopUp, animated: true, completion: nil)
    }
    
    func touchStampButton(_ sender: UITapGestureRecognizer) {
        let completePopUp = ChallengeCompletePopUpViewController()
        completePopUp.modalTransitionStyle = .crossDissolve
        completePopUp.modalPresentationStyle = .overCurrentContext
        completePopUp.popUpUsage = .challenge
        completePopUp.challengePopUpProtocol = self
        
        tabBarController?.present(completePopUp, animated: true, completion: nil)
    }
    
    func pushToFinishViewController() {
        // 스탬프 이미지 done으로 변경
        
        // TODO: - 다음 뷰 나오면 storyboard, vc 수정 필요
        let courseLibraryStoryboard = UIStoryboard(name: Const.Storyboard.Name.courseLibrary, bundle: nil)
        guard let courseLibraryViewController = courseLibraryStoryboard.instantiateViewController(withIdentifier: Const.ViewController.Identifier.courseLibrary) as? CourseLibraryViewController else {
            return
        }
        self.navigationController?.pushViewController(courseLibraryViewController, animated: true)
    }
    
    func pushToNextOnboardingViewController() {}
}

// MARK: - 서버 통신

extension CourseViewController {

    func getCourse() {
        
        ChallengeAPI.shared.getAllChallenges { (response) in
            
            switch response {
            case .success(let course):
                if let data = course as? TodayChallengeData {
                    self.updateData(data: data)
                }
                
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
}
