//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created on 21.06.2024.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var viewModel: CatalogViewModelProtocol
    
    // MARK: - UI Components
    
    private lazy var sortButton: UIBarButtonItem = {
        let sort = UIBarButtonItem(
            image: UIImage(
                named: "sort"
            ),
            style: .plain,
            target: self,
            action: #selector(
                sortMenuButton
            )
        )
        
        return sort
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypWhite
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            CatalogCell.self,
            forCellReuseIdentifier: CatalogCell.identifier
        )
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        print("CatalogViewController loaded")
        bildViewModel()
        viewModel.fetchCollections()
        setupNavigationItem()
        addElements()
        layoutConstraint()
    }
    
    init(viewModel: CatalogViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewModel Binding
    
    private func bildViewModel() {
        viewModel.collectionsBinding = { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func layoutConstraint() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
                tableView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: 16
                ),
                tableView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor,
                    constant: -16
                ),
                tableView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor
                )
            ]
        )
    }
    
    // MARK: Private Methods
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = sortButton
        sortButton.tintColor = .ypBlackDay
    }
    
    // MARK: - Action
    
    @objc func sortMenuButton() {
        // TODO: Логика сортировки
    }
}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 187
    }
}

// MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.collections.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogCell.identifier,
            for: indexPath
        ) as? CatalogCell else {
            return UITableViewCell()
        }
        cell.prepareForReuse()
        cell.selectionStyle = .none
        let collectionViewModel = viewModel.collections[indexPath.row]
        cell.configure(with: collectionViewModel)
        
        return cell
    }
}
