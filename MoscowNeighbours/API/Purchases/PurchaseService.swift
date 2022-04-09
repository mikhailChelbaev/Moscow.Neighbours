//
//  PurchaseService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import StoreKit

// MARK: - PurchaseService

final class PurchaseService: NSObject, PurchaseProvider {    
    private var productRequest: SKProductsRequest?
    private var products: [String: SKProduct]?
    
    private var productsRequestCallbacks: [RequestProductsCompletion] = []
    private var productPurchaseCallback: ((PurchaseProductResult) -> Void)?
    
    private let userState: UserState
    
    init(userState: UserState) {
        self.userState = userState
        super.init()
        
        // add self as transaction observer
        SKPaymentQueue.default().add(self)
    }
    
    func fetchProducts(productIds: Set<String>, completion: @escaping RequestProductsCompletion) {
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }
        
        productsRequestCallbacks.append(completion)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIds)
        productRequest.delegate = self
        productRequest.start()
        
        self.productRequest = productRequest
    }
    
    func purchaseProduct(productId: String, completion: @escaping PurchaseProductCompletion) {
        guard userState.isAuthorized else {
            completion(.failure(PurchasesError.userNotAuthorized))
            return
        }
        
        guard userState.currentUser?.isVerified ?? false else {
            completion(.failure(PurchasesError.userNotVerified))
            return
        }
        
        guard SKPaymentQueue.canMakePayments() else {
            completion(.failure(PurchasesError.paymentsRestricted))
            return
        }
        
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        
        guard let product = products?[productId] else {
            completion(.failure(PurchasesError.productNotFound))
            return
        }
        
        productPurchaseCallback = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(completion: @escaping PurchaseProductCompletion) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        productPurchaseCallback = completion
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - protocol SKProductsRequestDelegate

extension PurchaseService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        defer {
            productsRequestCallbacks.forEach { $0(.success(response.products)) }
            productsRequestCallbacks.removeAll()
        }
        
        guard !response.products.isEmpty else {
            Logger.log("Found 0 products")
            return
        }
        
        var products: [String: SKProduct] = [:]
        for skProduct in response.products {
            Logger.log("Found product: \(skProduct.productIdentifier)")
            products[skProduct.productIdentifier] = skProduct
        }
        
        self.products = products
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        Logger.log("Failed to load products with error:\n \(error)")
        
        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
}

// MARK: - protocol SKPaymentTransactionObserver

extension PurchaseService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                if finishTransaction(transaction) {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    productPurchaseCallback?(.success(true))
                } else {
                    productPurchaseCallback?(.failure(PurchasesError.unknown))
                }
                
            case .failed:
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
        
        if transactions.filter ({ $0.transactionState != .purchasing }).count > 0 {
            productPurchaseCallback = nil
        }
    }
}

extension PurchaseService {
    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        Logger.log("Product \(productId) successfully purchased")
        return true
    }
}
