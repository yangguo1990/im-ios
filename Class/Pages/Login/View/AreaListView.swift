//
//  AreaListView.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/24.
//

import UIKit

class AreaListView: UIView {
    var selectedBlock: ObjBlock<AreaModel>?
    lazy var list: UITableView = {
        let list = UITableView.init(frame: .zero, style: .plain)
        list.dataSource = self
        list.delegate = self
        list.rowHeight = 44
        list.showsVerticalScrollIndicator = false
        list.register(cellWithClass: AreaCell.self)
        return list
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(list)
        list.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AreaListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        kAreaModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = kAreaModels![indexPath.row]
        let cell = tableView.dequeueReusableCell(withClass: AreaCell.self)
        cell.nameLabel.text = model.country
        cell.subtitle.text = model.mobile_prefix
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = kAreaModels![indexPath.row]
        selectedBlock?(model)
    }
}

class AreaCell: UITableViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.body
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = .text.secondary
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .background.main
        
        //title
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
}
