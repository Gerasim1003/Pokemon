//
//  PokemonsViewController.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

class PokemonsViewController: ViewController {
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let viewModel = PokemonsViewModel()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startup()
    }
}

// MARK: - Setup

private extension PokemonsViewController {
    func setup() {
        setupTableView()
        
        title = "Pokemons"
        navigationItem.title = "Pokemons"
    }
    
    // MARK: Setup table view
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
            
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "PokemonTableCell", bundle: nil), forCellReuseIdentifier: "PokemonTableCell")
    }
}

// MARK: - Startup

private extension PokemonsViewController {
    func startup() {
        showLoading()
        viewModel.getPokemons { [unowned self] error in
            self.hideLoading()
            guard let error = error else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            self.showError(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource

extension PokemonsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableCell", for: indexPath) as! PokemonTableCell
        let pokemon = viewModel.pokemons[indexPath.row]
        cell.setData(pokemon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.pokemons[indexPath.row]
        
        let viewController = PokemonDetailsViewController(nibName: "PokemonDetailsViewController", bundle: nil, pokemon: pokemon)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.pokemons.count - 1 else { return }
        viewModel.getPokemons { error in
            guard let error = error else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            self.showError(error.localizedDescription)
        }
    }
}

// MARK: - Actions

private extension PokemonsViewController {
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        viewModel.reset()
        viewModel.getPokemons { error in
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                guard let error = error else {
                    self.tableView.reloadData()
                    return
                }
                self.showError(error.localizedDescription)
            }
        }
    }
}
