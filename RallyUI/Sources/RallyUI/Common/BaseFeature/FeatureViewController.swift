//
//  FeatureViewController.swift
//  RallyUI
//
//  Created by Povilas Staskus on 9/27/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit
import SnapKit

protocol FeatureViewModel {
    associatedtype ContentViewModel: FeatureContentViewModel
    var state: ViewState<ContentViewModel> { get }
}

protocol FeatureContentViewModel {
    var hasContent: Bool { get }
}

extension FeatureContentViewModel {
    var hasContent: Bool { return true }
}

enum ViewState<ViewModel> {
    case loading(viewModel: ViewModel?)
    case loaded(viewModel: ViewModel, errorMessage: String?)
    case error(message: String)

    var viewModel: ViewModel? {
        switch self {
        case .loading(let viewModel):
            return viewModel
        case .loaded(let viewModel, _):
            return viewModel
        default:
            return nil
        }
    }
}

protocol FeatureViewController: class {

    associatedtype ViewModel: FeatureViewModel

    var errorView: UIView? { get set }
    var loadingView: UIView? { get set }
    var emptyView: UIView? { get set }
    var viewModel: ViewModel? { get set }
    var alertViewController: UIViewController? { get set }

    func update(with viewModel: ViewModel)
    func configureView()
    func setupErrorView()
    func setupLoadingView()
    func setupEmptyView()
    func setupStateViews()
    func display()
    func reload()
}

extension FeatureViewController {
    var viewModelState: ViewState<Self.ViewModel.ContentViewModel>? {
        return viewModel?.state
    }
}

extension FeatureViewController where Self: UIViewController {
    func update(with viewModel: ViewModel) {
        guard isViewLoaded else {
            return
        }

        self.viewModel = viewModel
        self.configureView()
    }
}

extension FeatureViewController where Self: UIViewController {
    func configureView() {
        guard let viewModelState = viewModelState else {
//            Logger.feature.warning("configureView called in \(String(describing: type(of: self)))but no viewModel available")
            return
        }

        switch viewModelState {
        case .loading(let viewModel):
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            if let viewModel = viewModel {
                configureView(for: viewModel)
            } else {
                emptyView?.isHidden = true
                errorView?.isHidden = true
            }
            
            if let loadingView = loadingView {
                view.bringSubviewToFront(loadingView)
                loadingView.isHidden = false
            }
        case .error(let error):
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            errorView?.isHidden = true
            loadingView?.isHidden = true
            if let emptyView = emptyView {
                view.bringSubviewToFront(emptyView)
                emptyView.isHidden = false
            }
            (emptyView as? EmptyView)?.configure(
                .init(
                    imageName: "car",
                    title: error,
                    details: nil,
                    action: EmptyViewModel.Action(title: ~"retry", action: { [weak self] in
                        self?.reload()
                    }))
            )
        case .loaded(let viewModel, let error):
            if let errorMessage = error {
                configureAlertView(errorMessage: errorMessage)
            } else {
                dismissAlert()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            configureView(for: viewModel)
        }

    }

    private func configureView(for viewModel: FeatureContentViewModel) {
        // If viewModel doesn't have content
        if !viewModel.hasContent {
            if let emptyView = emptyView {

                // Show Empty view
                view.bringSubviewToFront(emptyView)
                emptyView.isHidden = false
                display()
            }
        } else {
            // If viewModel has content, hide emptyView
            emptyView?.isHidden = true
            display()
        }

        errorView?.isHidden = true
        loadingView?.isHidden = true
    }
}

extension FeatureViewController where Self: UIViewController {
    func setupStateViews() {
        view.backgroundColor = Theme.backgroundColor
        setupLoadingView()
        setupEmptyView()
        setupErrorView()
    }

    func setupErrorView() {
        errorView = ErrorView()
        guard let errorView = errorView else { return }
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        errorView.isHidden = true
    }

    func setupLoadingView() {
        loadingView = LoadingView()
        guard let loadingView = loadingView else { return }
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        loadingView.isHidden = true
    }

    func setupEmptyView() {
        emptyView = EmptyView()
        guard let emptyView = emptyView else { return }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        emptyView.isHidden = true
    }
    
    func configureAlertView(errorMessage: String) {
        dismissAlert()
        
        let alert = UIAlertController(title: "Įvyko klaida",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true) {
            self.alertViewController = alert
        }
    }
    
    private func dismissAlert() {
        alertViewController?.dismiss(animated: true, completion: nil)
        alertViewController = nil
    }
}
