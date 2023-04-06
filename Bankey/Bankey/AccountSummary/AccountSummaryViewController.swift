//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by 김준혁 on 2023/03/31.
//
import UIKit

class AccountSummaryViewController: UIViewController {
    
    //MARK: - Properties
    
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    
    // view Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "hehe", date: Date())
    
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero) // set where the header will be! (location)
    
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
    
    // It will be instanciated when it is actually called.
    lazy var logoutBarButtonItem : UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped) )
        btn.tintColor = .label // That's gonna make sure it is sycned light and dark mode
        return btn
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
}

extension AccountSummaryViewController {
    private func setup() {
        setupTableView()
        setupTableHeaderView()
        fetchDataAndLoadViews()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor // hmm... Under the safe area and the header line..
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Register
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        // -> height gonna be 144
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) // Needs more explanation
        size.width = UIScreen.main.bounds.width
        // let the width size fit its device's width
        
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID) as! AccountSummaryCell
        let account = accountCellViewModels[indexPath.row]
        cell.configure(with: account) // cell is the type of AccountSummaryCell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


// MARK: - Actions

extension AccountSummaryViewController {
    @objc
    func logoutTapped(sender : UIButton) {
        NotificationCenter.default.post(name: .Logout, object: nil)
    }
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchDataAndLoadViews() {
        
        fetchProfile(forUserId: "1") { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.configureTableHeaderView(with: profile)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        fetchAccounts(forUserId: "1") { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                self.configureTableCells(with: accounts)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type,
                                         accountName: $0.name,
                                         balance: $0.amount)
        }
    }
}
