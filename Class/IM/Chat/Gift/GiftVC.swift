//
//  GiftVC.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/16.
//

import UIKit
import PanModal
import Segmentio
import AMPopTip
import RxSwift

class GiftVC: BaseVC {
    var chatViewModel: IMChatVM?
    var userId: Int?
    private var datas = UserCenter.share.giftInfo?.sortGifts
    let disposeBag = DisposeBag()
    let numbers: [GiftNumberModel] = [.number1314, .number520, .number66, .number10, .number1]
    var selectGiftIndex = 0 {
        didSet {
            if oldValue != selectGiftIndex {
                collectionView.reloadData()
            }
        }
    }
    var selectNumberIndex = 4 {
        didSet {
            updateNumber()
        }
    }
    func updateNumber() {
        let model = numbers[selectNumberIndex]
        numberBtn.setTitle(model.number.string, for: .normal)
    }
    lazy var segment: Segmentio = {
        let segment = Segmentio()
        let gift = SegmentioItem(title: "礼物", image: nil)
        segment.setup(content: [gift], style: .onlyLabel, options: Utils.segmentioOptions())
        segment.selectedSegmentioIndex = 0

        return segment
    }()
    
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = .background.container
        page.currentPageIndicatorTintColor = .background.yuanlai
        page.currentPage = 0
        page.isUserInteractionEnabled = false
        return page
    }()
    
    lazy var balanceLabel: UIButton = {
        let label = UIButton()
        label.titleLabel?.font = .body14
        label.setTitleColor(.text.body, for: .normal)
        label.setImage(UIImage(named: "coin"), for: .normal)
        return label
    }()
    
    lazy var chargeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("充值", for: .normal)
        btn.titleLabel?.font = .medium14
        btn.setTitleColor(.background.yuanlai, for: .normal)
        btn.addTarget(self, action: #selector(onCharge), for: .touchUpInside)
        return btn
    }()
    
    lazy var numberBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.text.body, for: .normal)
        btn.titleLabel?.font = .medium16
        btn.addTarget(self, action: #selector(onNumber), for: .touchUpInside)
        return btn
    }()
    
    lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .background.yuanlai
        btn.setTitle("赠送", for: .normal)
        btn.setTitleColor(.text.white, for: .normal)
        btn.titleLabel?.font = .title16
        btn.addTarget(self, action: #selector(onSend), for: .touchUpInside)
        return btn
    }()
    
    lazy var sendView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.main
        view.layerBorderColor = .background.yuanlai
        view.layerBorderWidth = 1
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(onNumber))
        view.addGestureRecognizer(tap)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .background.yuanlai
        label.text = "赠送Ta|";
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalTo(50)
        }
        
        view.addSubview(numberBtn)
        numberBtn.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.left.equalTo(60)
        }
        
        let iv = UIImageView()
        iv.image = UIImage(named: "downP")
        view.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.centerY.equalTo(numberBtn.snp.centerY)
            make.width.height.equalTo(16)
            make.right.equalTo(-10)
        }
        
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background.main
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellWithClass: GiftCell.self)
        return collectionView
    }()
    
    lazy var numberList: UITableView = {
        let list = UITableView(frame: .init(x: 0, y: 0, width: 140, height: 200), style: .plain)
        list.dataSource = self
        list.delegate = self
        list.rowHeight = 40
        list.separatorStyle = .none
        list.register(cellWithClass: GiftNumberCell.self)
        return list
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNumber()
        updateData()
        
        UserCenter.giftInfoSubject.subscribe(onNext: { [weak self] _ in
            self?.datas = UserCenter.share.giftInfo?.sortGifts
            self?.updateData()
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        UserCenter.getGifts()
    }
    
    func updateData() {
        pageControl.numberOfPages = ((datas?.count ?? 0) / 9) + 1
        balanceLabel.setTitle("\(UserCenter.share.giftInfo?.coin ?? 0)", for: .normal)
    }
    
    override func setupView() {
        super.setupView()
        
        view.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(70)
        }
        
        let line = UIView()
        line.backgroundColor = .background.separator
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
            make.height.equalTo(240)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(20)
        }
        
        let bottomContainer = UIView()
        view.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(pageControl.snp.bottom)
            make.height.equalTo(40)
        }
        
        view.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(segment.snp.centerY)
            make.left.equalTo(238)
            make.leading.equalToSuperview().offset(16)
        }
        
        view.addSubview(chargeBtn)
        chargeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(balanceLabel.snp.centerY)
            make.right.equalTo(-10)
            make.width.equalTo(60)
        }
        
        bottomContainer.addSubview(sendView)
        sendView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalTo(145)
        }
        sendView.layerCornerRadius = 18
        sendBtn.layerCornerRadius = 19
        
        bottomContainer.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.centerY.equalTo(sendView.snp.centerY)
            make.height.equalTo(38)
            make.width.equalTo(80)
            make.right.equalTo(-16)
        }
    }
    
    @objc func onSend() {
        guard let gift = datas?[selectGiftIndex] else {
            return
        }
        let num = numbers[selectNumberIndex]
        
        if let vm = chatViewModel {
            vm.sendGift(gift, num: num.number)
        }else if let userId = userId {
            IMManager.sendGift(gift, number: num.number, to: userId)
        }
        
        dismiss(animated: true)
    }
    
    weak var pop: PopTip?
    @objc func onNumber() {
        let pop = PopTip()
        pop.shouldDismissOnTap = false
        pop.shouldShowMask = true
        pop.bubbleColor = UIColor.background.main
        pop.borderColor = .background.yuanlai
        pop.borderWidth = 1
        pop.cornerRadius = 16
        
        let convertedFrame = sendView.superview!.convert(sendView.frame, to: view)

        pop.show(customView: numberList, direction: .up, in: view, from: convertedFrame)
        
        self.numberList.reloadData()
        self.pop = pop
    }
    @objc func onCharge() {
        modalToTopupController()
    }
}

extension GiftVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    var longFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(400)
    }
}

extension GiftVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.width - 64) / 4.0
        return .init(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GiftCell.self, for: indexPath)
        cell.model = datas?[indexPath.item]
        cell.isChoose = selectGiftIndex == indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 12, left: 8, bottom: 12, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectGiftIndex = indexPath.item
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let page = scrollView.contentOffset.x / scrollView.width
            pageControl.currentPage = Int(page)
        }
    }
}

extension GiftVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: GiftNumberCell.self)
        cell.selectionStyle = .none
        cell.model = numbers[indexPath.row]
        cell.isChoose = selectNumberIndex == indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectNumberIndex = indexPath.row
        pop?.hide()
    }
}
