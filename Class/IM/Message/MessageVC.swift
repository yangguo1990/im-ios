//
//  MessageVC.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AMPopTip

@objcMembers
public class MessageVC: BaseVC {
    let viewModel = MessageVM()
    let disposeBag = DisposeBag()
    var noticeHeightConstraint: Constraint?
    var myindex:Int = 0
    var recordHosts:[phoneRecordHost] = []
    weak var pop: PopTip?
    lazy var list: UITableView = {
        let list = UITableView(frame: .zero, style: .plain)
        list.delegate = self
        list.dataSource = self
        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 62
        list.showsVerticalScrollIndicator = false
        list.register(cellWithClass: ConversationCell.self)
        list.register(cellWithClass: phoneRecordCell.self)
        list.separatorStyle = .none
        list.backgroundColor = .white
        list.layer.cornerRadius = 20
        list.layer.masksToBounds = true;
        return list
    }()
    
    lazy var noticeView: MessageNoticeView = {
        MessageNoticeView()
    }()
    
    lazy var leftItem: UIImageView = {
        let label = UIImageView(image: .init(named: "msg_name"))
//        label.text = "消息"
//        label.font = .title18
//        label.textColor = .text.body
        return label
    }()
    
    lazy var menuView: UIView = {
        let view = UIView()
        let btn1 = UIButton()
        btn1.setTitle("一键删除", for: .normal)
        btn1.setTitleColor(.black, for: .normal)
        btn1.titleLabel?.font = .medium14
        btn1.addTarget(self, action: #selector(onDeleteAll), for: .touchUpInside)
        view.addSubview(btn1)
        btn1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let btn2 = UIButton()
        btn2.setTitle("一键已读", for: .normal)
        btn2.setTitleColor(.black, for: .normal)
        btn2.titleLabel?.font = .medium14
        btn2.addTarget(self, action: #selector(onRemarkReadAll), for: .touchUpInside)
        view.addSubview(btn2)
        btn2.snp.makeConstraints { make in
            make.top.equalTo(btn1.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(btn1)
        }
        btn1.sizeToFit()
        btn2.sizeToFit()
        var w = max(btn1.size.width, btn2.size.width)
        w += 40
        view.frame = .init(x: 0, y: 0, width: w, height: 96)
        return view
    }()
    
    lazy var headerView: MessageHeaderView = {
        MessageHeaderView(frame: .init(x: 0, y: 0, width: view.width, height: MessageHeaderView.height))
    }()
    
  public  override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = .init(customView: leftItem)
      self.isNavigationBarHidden = true
        view.addSubview(leftItem)
      self.isNavigationBarHidden = true
      leftItem.snp.makeConstraints { make in
          make.left.equalTo(16)
          make.top.equalTo(56)
          make.width.equalTo(42)
          make.height.equalTo(28)
      }
        let rightbt = UIButton()
       rightbt.setBackgroundImage(UIImage(named: "msg_more"), for:UIControl.State.normal)
       rightbt.addTarget(self, action: #selector(onRightItemClick), for: UIControl.Event.touchUpInside)
       view.addSubview(rightbt)
      rightbt.snp.makeConstraints { make in
          make.right.equalTo(-16)
          make.top.equalTo(56)
          make.width.equalTo(24)
          make.height.equalTo(24)
      }
//        navigationItem.rightBarButtonItem = .init(image: .init(named: "msg_more")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onRightItemClick))
        let topS = JXCategoryTitleView(frame: CGRectZero)
        topS.titles = ["聊天","记录"]
        topS.titleColor = UIColor(hex: "#666666")
        topS.titleSelectedColor = UIColor(hex: "#000000")
        topS.titleSelectedFont = UIFont.boldSystemFont(ofSize: 20)
        topS.delegate = self
        view.addSubview(topS)
      topS.snp.makeConstraints { make in
          make.width.equalTo(150)
          make.height.equalTo(20)
          make.centerX.equalTo(self.view.snp.centerX)
          make.centerY.equalTo(leftItem.snp.centerY)
      }
         
        checkNotificationSettings()
    }
    
  public  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      self.isNavigationBarHidden = true;
        IMManager.requestConversations()
    }
    
    ///检测是否开启通知
    func checkNotificationSettings() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            var h = 0
            var alpha = 0.0
            if settings.authorizationStatus == .denied ||
                settings.authorizationStatus == .notDetermined {
                h = 48
                alpha = 1
            }
            DispatchQueue.main.async {
                self.noticeHeightConstraint?.update(offset: h)
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                    self.noticeView.alpha = alpha
                }
            }
        })
    }
}

extension MessageVC {
    @objc func onRightItemClick() {
        let pop = PopTip()
        pop.shouldDismissOnTap = false
        pop.shouldShowMask = true
        pop.bubbleColor = UIColor(hex: "#ffffff")
        let x = navigationController!.navigationBar.frame.maxX - menuView.width / 2 - 16
        let y = 88 + menuView.height / 2
        pop.show(customView: menuView, direction: .none, in: navigationController!.view, from: .init(x: x, y: y, width: 0, height: 0))
        
        self.pop = pop
    }
    @objc func onDeleteAll() {
        pop?.hide()
        alert(title: "删除会话", message: "是否确认删除所有会话？", .cancel("取消", nil), .destructive("删除", {
            IMManager.deleteAllConversations()
        }))
    }
    @objc func onRemarkReadAll() {
        pop?.hide()
        IMManager.markReadedAll()
    }
}

extension MessageVC {
    func reloadData(animate: Bool) {
        if animate {
            let range = NSMakeRange(0, list.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            list.reloadSections(sections as IndexSet, with: .automatic)
        }else {
            list.reloadData()
        }
        
        if myindex == 0 {
            if IMManager.share.conversations.isEmpty{
                list.showEmpty()
            }else{
                list.hideEmpty()
            }
        }else{
            if recordHosts.isEmpty {
                list.showEmpty()
            }else{
                list.hideEmpty()
            }
        }
    
    }
    override func setupVM() {
        super.setupVM()
        
        IMManager.share.conversationsSubjectWithAnimate.subscribe(onNext: { [weak self] in
            self?.reloadData(animate: $0)
        }).disposed(by: disposeBag)
        
        IMManager.share.unreadMsgCountSubject.subscribe(onNext: { [weak self] _ in
            self?.reloadData(animate: false)
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).subscribe(onNext: { [weak self] _ in
            self?.checkNotificationSettings()
        }).disposed(by: disposeBag)
        
        GlobalSignal.noticePermissionChanged.subscribe(onNext: { [weak self] _ in
            self?.checkNotificationSettings()
        }).disposed(by: disposeBag)
    }
    override func setupView() {
        super.setupView()
        let topBg = UIImageView(image: UIImage(named: "msg_top"))
        topBg.contentMode = .scaleAspectFill
        view.addSubview(topBg)
        view.sendSubviewToBack(topBg)
        topBg.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        noticeView.alpha = 0
        view.addSubview(noticeView)
        noticeView.snp.makeConstraints { make in
            make.top.equalTo(leftItem.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            self.noticeHeightConstraint = make.height.equalTo(0).constraint
        }
        view.addSubview(headerView)
        let scale = UIScreen.main.bounds.size.width/375.0
        headerView.snp.makeConstraints { make in
            make.top.equalTo(noticeView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(100*scale)
        }
        
        view.addSubview(list)
        list.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension MessageVC: UITableViewDataSource, UITableViewDelegate ,JXCategoryViewDelegate {
public    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if myindex == 0 {
        IMManager.share.conversations.count
    }else{
        recordHosts.count
    }
       
    }
    
public    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
    if myindex == 0 {
        let cell = tableView.dequeueReusableCell(withClass: ConversationCell.self)
        cell.selectionStyle = .none
        cell.model = IMManager.share.conversations[row]
        cell.isLast = row == IMManager.share.conversations.count - 1
        return cell
    }else{
        let cell = tableView.dequeueReusableCell(withClass: phoneRecordCell.self)
        cell.selectionStyle = .none
        cell.model = recordHosts[row]
        return cell
    }
       
    }
    
public    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if myindex == 0 {
        let model = IMManager.share.conversations[indexPath.row]
        if let chatId = model.conversation.conversationId {
            navigationController?.pushViewController(IMChatVC(chatId: chatId))
        }
    }else{
        let model:phoneRecordHost = recordHosts[indexPath.row]
        let detai = ML_HostdetailsViewController(userId: String(model.userId))
        navigationController?.pushViewController(detai, animated: true)
  
    }
        
    }
    
public    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let conversation = IMManager.share.conversations[indexPath.row].conversation
        let pinActionTitle = conversation.isPinned ? "取消置顶" : "置顶"
        let pinAction = UIContextualAction(style: .normal, title: pinActionTitle) { _, _, completion in
            IMManager.pin(conversation: conversation) {
                completion(true)
            }
        }
        pinAction.backgroundColor = UIColor(hex: "#0089FF")

        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { _, _, completion in
            IMManager.delete(conversation: conversation) {
                completion(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, pinAction])
    }
public   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
            let label = UILabel()
    if myindex == 0 {
        label.text = "    消息列表"
    }else{
        label.text = "    通话记录"
    }
            
            label.font = .title16
            label.textColor = .text.body
            label.frame = CGRectMake(0, 0,self.view.width, 40)
        return label
    }
public    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 40
    }
public    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    if myindex == 0 {
        return 80
    }else{
        return 96
    }
    }
          
    
public    func categoryView(_ categoryView:JXCategoryBaseView, didSelectedItemAt index:Int){
       myindex = index
    if myindex == 0 {
        list.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        self.reloadData(animate: false)
    }else{
        list.snp.remakeConstraints { make in
            make.top.equalTo(noticeView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        let _ = MLRequest.send(.getPhoneRecord(page: 1, limit: 50), type: recordData.self).subscribe { [self] recordata in
            recordHosts = recordata!.hosts
            self.reloadData(animate: false)
        }
       
    }
    
     
    };
}




