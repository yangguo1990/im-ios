//
//  BaseListVM.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/29.
//

import Foundation
import RxSwift

protocol ListDatasProtocol {
    associatedtype Item: Codable
    var list: [Item]? { get }
}

class BaseListVM<Result: ListDatasProtocol>: BaseVM {
    
    //空数据展示
    weak var emptyDataResponser: UIView?
    var emptyTopOffset: CGFloat { 0 }
    
    //api请求完成(失败以及成功) --- 对应下拉刷新和加载更多控件stop
    let completionSubject = PublishSubject<Void>()
    //数据改变 --- 对应刷新列表reloadData
    let datasSubject = PublishSubject<[Result.Item]?>()
    //能否加载更多 --- 对应显示和隐藏加载更多控件
    let isCanLoadMoreSubject = PublishSubject<Bool>()
    //默认不可加载更多，调用refresh后，再根据返回数据判断是否可以加载更多
    private(set) var isCanLoadMore: Bool = false
    
    //page属性
    private(set) var page: Int = Constants.firtPage
    var size: Int { Constants.pageSize }
    
    var datas: [Result.Item]?
    
    var api: Single<Result?> {
        fatalError("子类重写")
    }
    
    final func refresh() {
        let oldPage = page
        page = Constants.firtPage
        let _ = api.subscribe(onSuccess: { model in
            self.datas = model?.list
            
            if let newDatas = model?.list, !newDatas.isEmpty {
                self.emptyDataResponser?.hideEmpty()
                if newDatas.count < self.size {
                    self.isCanLoadMore = false
                }else {
                    self.isCanLoadMore = true
                }
            }else {
                self.isCanLoadMore = false
                self.emptyDataResponser?.showEmpty(topOffset: self.emptyTopOffset)
            }
            self.datasSubject.onNext(model?.list)
            self.completionSubject.onNext(())
            self.isCanLoadMoreSubject.onNext(self.isCanLoadMore)
        }, onFailure: { _ in
            //接口失败page保持原来不变
            self.page = oldPage
            self.completionSubject.onNext(())
        })
    }
    
    final func loadmore() {
        let oldPage = page
        page += 1
        let _ = api.subscribe(onSuccess: { model in
            if let newDatas = model?.list, !newDatas.isEmpty {
                self.datas?.append(contentsOf: newDatas)
                if newDatas.count < self.size {
                    self.isCanLoadMore = false
                }
                self.datasSubject.onNext(self.datas)
            }else {
                self.isCanLoadMore = false
            }
            self.completionSubject.onNext(())
            self.isCanLoadMoreSubject.onNext(self.isCanLoadMore)
        }, onFailure: { _ in
            //接口失败page保持原来不变
            self.page = oldPage
            self.completionSubject.onNext(())
        })
    }
}
