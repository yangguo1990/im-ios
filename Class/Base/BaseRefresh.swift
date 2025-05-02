//
//  BaseRefresh.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/3/2.
//

import UIKit
import ESPullToRefresh
import RxSwift

protocol RefreshControllerProtocol: AnyObject {
    associatedtype E: ListDatasProtocol
    var r_viewModel: BaseListVM<E> { get }
    var r_list: UIScrollView { get }
    var r_disposeBag: DisposeBag { get }
    func r_reloadData()
}

extension RefreshControllerProtocol {
    func r_reloadData() {
        if let tableView = r_list as? UITableView {
            tableView.reloadData()
            return
        }
        if let collectionView = r_list as? UICollectionView {
            collectionView.reloadData()
            return
        }
    }
    //修改 下拉 上拉刷新 文字提示
    var header: ESRefreshHeaderAnimator {
        let h = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        h.pullToRefreshDescription = "下拉刷新"
        h.releaseToRefreshDescription = "松开获取最新数据"
        h.loadingDescription = "加载中..."
        return h
    }
    
    var footer: ESRefreshFooterAnimator {
        let f = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        f.loadingMoreDescription = "上拉加载更多"
        f.noMoreDataDescription = "已经到底了~"
        f.loadingDescription = "加载中..."
        return f
    }
    
    func startPullToRefresh() {
        r_list.es.startPullToRefresh()
    }
    
    ///添加下刷新和加载更多
    func addRefreshControl(alsoLoadMore: Bool = true) {
        r_viewModel.emptyDataResponser = r_list
        r_list.es.addPullToRefresh(animator: header) { [weak self] in
            self?.r_viewModel.refresh()
        }
        if alsoLoadMore {
            r_list.es.addInfiniteScrolling(animator: footer) { [weak self] in
                self?.r_viewModel.loadmore()
            }
        }
        
        r_viewModel.datasSubject.subscribe(onNext: { [weak self] _ in
            self?.r_reloadData()
        }).disposed(by: r_disposeBag)
        
        r_viewModel.completionSubject.subscribe(onNext: { [weak self] _ in
            self?.r_list.es.stopPullToRefresh()
            self?.r_list.es.stopLoadingMore()
        }).disposed(by: r_disposeBag)
        
        r_viewModel.isCanLoadMoreSubject.subscribe(onNext: { [weak self] in
            if $0 {
                self?.r_list.es.resetNoMoreData()
            }else {
                self?.r_list.es.noticeNoMoreData()
            }
        }).disposed(by: r_disposeBag)
    }
}
