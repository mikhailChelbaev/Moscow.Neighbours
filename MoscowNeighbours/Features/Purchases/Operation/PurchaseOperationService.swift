//
//  PurchaseOperationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import StoreKit

final class PurchaseOperationService: NSObject {
    
    typealias Result = PurchaseOperationProvider.Result
    
    private var productPurchaseCallback: ((Result) -> Void)?
    private let isAuthorized: Bool
    private let isVerified: Bool
    
    init(isAuthorized: Bool, isVerified: Bool) {
        self.isAuthorized = isAuthorized
        self.isVerified = isVerified
        
        super.init()
        
        becomeTransactionObserver()
    }
    
    private func becomeTransactionObserver() {
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - protocol PurchaseOperationProvider

extension PurchaseOperationService: PurchaseOperationProvider {
    
    func purchaseProduct(product: Product, completion: @escaping (Result) -> Void) {
        guard isAuthorized else {
            return completion(.failure(PurchasesError.userNotAuthorized))
        }
        
        guard isVerified else {
            return completion(.failure(PurchasesError.userNotVerified))
        }
        
        guard SKPaymentQueue.canMakePayments() else {
            return completion(.failure(PurchasesError.paymentsRestricted))
        }
        
        guard productPurchaseCallback == nil else {
            return completion(.failure(PurchasesError.purchaseInProgress))
        }
        
        productPurchaseCallback = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(completion: @escaping (Result) -> Void) {
        guard isAuthorized else {
            return completion(.failure(PurchasesError.userNotAuthorized))
        }
        
        guard isVerified else {
            return completion(.failure(PurchasesError.userNotVerified))
        }
        
        guard productPurchaseCallback == nil else {
            return completion(.failure(PurchasesError.purchaseInProgress))
        }
        
        productPurchaseCallback = completion
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}


// MARK: - protocol SKPaymentTransactionObserver

extension PurchaseOperationService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let productId = transaction.payment.productIdentifier
            
            switch transaction.transactionState {
            case .purchased, .restored:
                Logger.log("Product \(productId) successfully purchased or restored")
                SKPaymentQueue.default().finishTransaction(transaction)
                productPurchaseCallback?(.success(()))
                
            case .failed:
                Logger.log("Failed to purchase or restore product \(productId)")
                SKPaymentQueue.default().finishTransaction(transaction)
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                
            default: break
            }
        }
        
        if transactions.filter ({ $0.transactionState != .purchasing }).count > 0 {
            productPurchaseCallback = nil
        }
    }
}
