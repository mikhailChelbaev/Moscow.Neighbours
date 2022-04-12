//
//  RouteDescriptionViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import XCTest
import MoscowNeighbours

final class RouteDescriptionTableViewController: LoadingStatusProvider {
    
    lazy var view: BaseTableView = {
        let view = BaseTableView()
        view.successDataSource = self
        view.statusProvider = self
        return view
    }()
    
//    private var tableModel: [RouteCellController]
    var status: LoadingStatus {
        didSet { view.reloadData() }
    }
    
    init() {
        status = .loading
    }
    
}
 
extension RouteDescriptionTableViewController: TableSuccessDataSource {
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

struct RouteViewModel {}

protocol RouteDescriptionLoadingView {
    func display(isLoading: Bool)
}

final class RouteDescriptionPresenter<RouteTransformer: ItemTransformer> where RouteTransformer.Input == Route, RouteTransformer.Output == RouteViewModel {
    private let model: Route
    private let routeTransformer: RouteTransformer
    
    init(model: Route, routeTransformer: RouteTransformer) {
        self.model = model
        self.routeTransformer = routeTransformer
    }
    
    var routeDescriptionLoadingView: RouteDescriptionLoadingView?
}

extension RouteDescriptionPresenter: RouteDescriptionInput {
    func didTransformRoute() {
        routeDescriptionLoadingView?.display(isLoading: true)
        routeTransformer.transform(model) { [weak self] _ in
            self?.routeDescriptionLoadingView?.display(isLoading: false)
        }
    }
}

protocol RouteDescriptionInput {
    func didTransformRoute()
}

final class RouteDescriptionViewController: UIViewController {
    typealias Presenter = RouteDescriptionInput
    
    let tableView: BaseTableView
//    let headerView: HeaderView
    
    private let presenter: Presenter
    private let tableViewController: RouteDescriptionTableViewController
    
    init(presenter: Presenter, tableViewController: RouteDescriptionTableViewController) {
        self.presenter = presenter
        self.tableViewController = tableViewController
        
        tableView = tableViewController.view
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didTransformRoute()
    }
}

class RouteDescriptionViewControllerTests: XCTestCase {
    
    func test_init_doesNotTransformRoute() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    func test_loadingIndicator_isVisibleWhileTransformingRoute() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator once view is loaded")
        
        loader.completeRoutesTransforming()
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once transforming completes successfully")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(route: Route = makeRoute(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = composeRouteDescription(model: route, routeTransformer: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
            
    private func makeUniqueRoute() {
        
    }
    
    private final class LoaderSpy: ItemTransformer {
        var transformationCompletions = [(RouteViewModel) -> Void]()
        
        var transfromCallCount: Int {
            return transformationCompletions.count
        }
        
        func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
            transformationCompletions.append(completion)
        }
        
        func completeRoutesTransforming(at index: Int = 0) {
            transformationCompletions[index](RouteViewModel())
        }
    }
    
}

private extension RouteDescriptionViewController {
    private var loader: LoadingCell? {
        let ds = tableView.dataSource
        
        guard ds!.tableView(tableView, numberOfRowsInSection: loaderIndexPath.section) > loaderIndexPath.row else {
            return nil
        }
        
        let cell = ds?.tableView(tableView, cellForRowAt: loaderIndexPath) as? TableCellWrapper<LoadingCell>
        return cell?.view
    }
    
    private var loaderIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    var isLoaderVisible: Bool {
        return loader != nil
    }
}

private func composeRouteDescription<Transformer: ItemTransformer>(
    model: Route,
    routeTransformer: Transformer
) -> RouteDescriptionViewController where Transformer.Input == Route, Transformer.Output == RouteViewModel {
    let presenter = RouteDescriptionPresenter(model: model, routeTransformer: routeTransformer)
    let tableViewController = RouteDescriptionTableViewController()
    let controller = RouteDescriptionViewController(presenter: presenter, tableViewController: tableViewController)
    return controller
}
