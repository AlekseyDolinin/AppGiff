import UIKit
import StoreKit

let nPricesUpdated: NSNotification.Name = NSNotification.Name(rawValue: "nPricesUpdated")

class PriceManager: NSObject {
    
    func getPricesForInApps(inAppsIDs: Set<String>) {
        print("getPricesForInApps")
        if !SKPaymentQueue.canMakePayments() {
            print("You can't make payments")
            return
        }
        let request = SKProductsRequest(productIdentifiers: inAppsIDs)
        request.delegate = self
        request.start()
    }
}

extension PriceManager: SKProductsRequestDelegate {
    ///
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            let nf = NumberFormatter()
            nf.numberStyle = NumberFormatter.Style.currency
            nf.locale = product.priceLocale
            let price: String = String(describing: product.price) + nf.currencySymbol
            print("price: \(price)")
            UserDefaults.standard.setValue(price, forKeyPath: product.productIdentifier)
            UserDefaults.standard.synchronize()
        }
        NotificationCenter.default.post(name: nPricesUpdated, object: nil)
        print("invalid ID: \(response.invalidProductIdentifiers)")
    }
}
