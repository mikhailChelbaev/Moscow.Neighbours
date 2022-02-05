//
//  PurchaseService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import StoreKit

// MARK: - PurchaseService

final class PurchaseService: NSObject, PurchaseProvider {
    static let shared = PurchaseService()
    
    var observers: [String : PurchaseProviderDelegate] = [:]
    
    private var productRequest: SKProductsRequest?
    private var products: [String: SKProduct]?
    
    private var isFetchingProducts: Bool = false
    private var isPurchasingProduct: Bool = false
    
    func fetchProducts(productIds: Set<String>) {
        guard !isFetchingProducts else {
            return
        }
        
        let productRequest = SKProductsRequest(productIdentifiers: productIds)
        productRequest.delegate = self
        productRequest.start()
        
        self.productRequest = productRequest
    }
    
    func purchaseProduct(productId: String) {
        guard !isPurchasingProduct else {
            sendActionForObservers({ $0.productPurchase(didReceive: .failure(PurchasesError.purchaseInProgress)) })
            return
        }
        
        guard let product = products?[productId] else {
            sendActionForObservers({ $0.productPurchase(didReceive: .failure(PurchasesError.productNotFound)) })
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        guard !isPurchasingProduct else {
            sendActionForObservers({ $0.productPurchase(didReceive: .failure(PurchasesError.purchaseInProgress)) })
            return
        }
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - protocol SKProductsRequestDelegate

extension PurchaseService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        defer {
            sendActionForObservers({ $0.productsFetch(didReceive: .success(response.products)) })
            isFetchingProducts = false
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
        
        sendActionForObservers({ $0.productsFetch(didReceive: .failure(error)) })
        isFetchingProducts = false
    }
    
    private func sendActionForObservers(_ action: (PurchaseProviderDelegate) -> Void) {
        observers.forEach({ action($0.value) })
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
                    sendActionForObservers({ $0.productPurchase(didReceive: .success(true)) })
                } else {
                    sendActionForObservers({ $0.productPurchase(didReceive: .failure(PurchasesError.unknown)) })
                }
                
            case .failed:
                sendActionForObservers({ $0.productPurchase(didReceive: .failure(transaction.error ?? PurchasesError.unknown)) })
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
        
        isPurchasingProduct = false
    }
}

extension PurchaseService {
    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        Logger.log("Product \(productId) successfully purchased")
        return true
    }
}
