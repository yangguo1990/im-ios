//
//  phoneRecordCell.swift
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/27.
//

import UIKit
import Kingfisher
class phoneRecordCell: UITableViewCell {
    
    var model: phoneRecordHost? {
        didSet {
            let domain = ML_AppUserInfoManager.shared().currentLoginUserData.domain
            let url = domain! + "/" + model!.icon
            iconImage.kf.setImage(with: URL(string: url))
            if (model?.type == 0) {
                unlike.isSelected = false;
                likeBt.isSelected = true;
            } else if (model?.type == 1) {
                unlike.isSelected = true;
                likeBt.isSelected = false;
            }else{
                unlike.isSelected = false;
                likeBt.isSelected = false;
            }
            
            switch model?.status {
            case 1:
                let text:String
                let ntime = (model?.secs ?? 0)/1000
                let m = ntime / 60
                let s = ntime % 60
                if m > 0 {
                    text = "  通话\(m)分\(s)秒"
                }else {
                    text = "  通话\(s)秒"
                }
                nameButton.setImage(UIImage(named: "icon_call_20"), for: .normal)
                nameButton.setTitle(text, for: .normal)
                
                break
            case 2:
                nameButton.setImage(UIImage(named: "icon_removed_20"), for: .normal)
                nameButton.setTitle("  已取消", for: .normal)
                break
            case 3:
                nameButton.setImage(UIImage(named: "icon_missed_call_20"), for: .normal)
                nameButton.setTitle("  已拒绝", for: .normal)
                break
            case 4:
                nameButton.setImage(UIImage(named: "icon_missed_call_20"), for: .normal)
                nameButton.setTitle("  未接听", for: .normal)
                break
            case 5:
                nameButton.setImage(UIImage(named: "icon_missed_call_20"), for: .normal)
                nameButton.setTitle("对方占线中", for: .normal)
                break
                
            default:
                break
            }
            
            signLabel.text = model!.name + "  " + model!.create_time
            
        }
    }
    
    
    var middleView :UIView = {
        let middle = UIView()
        middle.backgroundColor = UIColor(hex: "#ff6fb3")
        middle.layer.cornerRadius = 12
        middle.layer.masksToBounds = true
        return middle
    }()
   
    var middleViewTop : UIView = {
        let middle = UIView()
        middle.backgroundColor = UIColor(hex: "#ffffff")
        middle.layer.cornerRadius = 12
        middle.layer.masksToBounds = true
        middle.layer.borderWidth = 1
        middle.layer.borderColor = UIColor(hex: "#ff6fb3").cgColor
        return middle
    }()
    
    var iconImage : UIImageView = {
        let iconimage = UIImageView();
        return iconimage
    }()
    
    var nameButton : UIButton = {
        let nameBt = UIButton()
        nameBt.setTitleColor(UIColor(hex:"#000000"), for: .normal)
        nameBt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return nameBt
    }()
    
    var shipinBt : UIButton = {
        let shipin = UIButton()
        shipin.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        shipin.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        shipin.setTitle("视频", for: .normal)
        shipin.setImage(UIImage(named: "recordShip"), for: .normal)
        shipin.centerTextAndImage(imageAboveText: true, spacing: 8)
        shipin.addTarget(self, action: #selector(shipinClick), for: .touchUpInside)
        return shipin
    }()
    
    @objc func shipinClick() {
        RTCManager.call(model!.userId)
    }
    
    var signLabel : UILabel = {
        let sign = UILabel()
        sign.numberOfLines = 0
        sign.textColor = UIColor(hex:"#a9a9ab")
        sign.font = UIFont.systemFont(ofSize: 12)
        return sign
    }()
    
    var likeBt : UIButton = {
        let like = UIButton()
        like.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        like.setTitleColor(UIColor(hex: "#a9a9ab"), for: .normal)
        like.setTitle("喜欢", for: .normal)
        like.setImage(UIImage(named: "icon_rating_like_unchecked_24"), for: .normal)
        like.setImage(UIImage(named: "icon_rating_like_check_24"), for: .selected)
        like.centerTextAndImage(imageAboveText: true, spacing: 8)
        return like
    }()
    
    var unlike : UIButton = {
        let unlike = UIButton()
        unlike.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        unlike.setTitleColor(UIColor(hex: "#a9a9ab"), for: .normal)
        unlike.setTitle("讨厌", for: .normal)
        unlike.setImage(UIImage(named: "icon_rating_dislike_selected_242"), for: .normal)
        unlike.setImage(UIImage(named: "icon_rating_dislike_selected_24"), for: .selected)
        unlike.centerTextAndImage(imageAboveText: true, spacing: 8)
        return unlike
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        backgroundColor = .clear
        contentView.addSubview(middleView)
        let scale = UIScreen.main.bounds.size.width/375.0
        middleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(343*scale)
            make.height.equalTo(76*scale)
        }
        
        contentView.addSubview(middleViewTop)
        middleViewTop.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(300*scale)
            make.height.equalTo(76*scale)
            make.left.equalTo(middleView)
            
        }
        
        contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.width.height.equalTo(44*scale)
            make.centerY.equalToSuperview()
            make.left.equalTo(32*scale)
        }
        iconImage.layer.cornerRadius = 22*scale
        iconImage.layer.masksToBounds = true
        
        contentView.addSubview(nameButton)
        nameButton.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(5*scale)
            make.top.equalTo(iconImage.snp.top)
            make.height.equalTo(16*scale)
        }
        
        contentView.addSubview(likeBt)
        likeBt.snp.makeConstraints { make in
            make.width.equalTo(24*scale)
            make.height.equalTo(44*scale)
            make.centerY.equalToSuperview()
            make.left.equalTo(248*scale)
        }
        
        contentView.addSubview(unlike)
        unlike.snp.makeConstraints { make in
            make.width.equalTo(24*scale)
            make.height.equalTo(44*scale)
            make.centerY.equalToSuperview()
            make.left.equalTo(280*scale)
        }
        
        contentView.addSubview(signLabel)
        signLabel.snp.makeConstraints { make in
            make.left.equalTo(nameButton.snp.left)
            make.top.equalTo(nameButton.snp.bottom).offset(5*scale)
            make.height.equalTo(35*scale)
            make.right.equalTo(likeBt.snp.left)
        }
        
        contentView.addSubview(shipinBt)
        shipinBt.snp.makeConstraints { make in
            make.width.equalTo(20*scale)
            make.height.equalTo(40*scale)
            make.centerY.equalToSuperview()
            make.right.equalTo(middleView.snp.right).offset(-12*scale)
        }
        
    }

}
