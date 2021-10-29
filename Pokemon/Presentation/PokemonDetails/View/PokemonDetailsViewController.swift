//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

class PokemonDetailsViewController: ViewController {
    enum Sections: Int, CaseIterable {
        case types
        case details
        
        var title: String {
            switch self {
            case .types:
                return "Types"
            case .details:
                return "Details"
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var headerView: PokemonDetailsHeaderView!
    
    // MARK: - Properties
    
    private let viewModel: PokemonDetailsViewModel
    
    // MARK: - Init
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, pokemon: Pokemon) {
        self.viewModel = PokemonDetailsViewModel(pokemon)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startup()
    }
}

// MARK: - Setup

private extension PokemonDetailsViewController {
    func setup() {
        setupTableView()
    }
    
    // MARK: Setup table view
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        
        headerView = PokemonDetailsHeaderView(frame: .zero)
        headerView.frame.size.height = 300
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: "PokemonDetailsTableCell", bundle: nil), forCellReuseIdentifier: "PokemonDetailsTableCell")
    }
}

// MARK: - Startup

private extension PokemonDetailsViewController {
    func startup() {
        showLoading()
        viewModel.getDetails { [weak self] error in
            self?.hideLoading()
            guard let error = error else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.headerView.setData(self?.viewModel.details?.imageUrl,
                                             self?.viewModel.details?.name.capitalized)
                }
                return
            }
            self?.showError(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource

extension PokemonDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Sections(rawValue: section)
        switch section {
        case .types:
            return viewModel.details?.types.count ?? 0
        case .details:
            return 2
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections(rawValue: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDetailsTableCell", for: indexPath) as! PokemonDetailsTableCell
        switch section {
        case .types:
            cell.setData(viewModel.details?.types[indexPath.row].name.capitalized, nil)
        case .details:
            if indexPath.row == 0 {
                cell.setData("Weight:", viewModel.details?.formattedWeight)
            } else {
                cell.setData("Height:", viewModel.details?.formattedHeight)
            }
        case .none:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PokemonDetailsSectionHeaderView(frame: .zero)
        let section = Sections(rawValue: section)
        view.setData(section?.title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
}
