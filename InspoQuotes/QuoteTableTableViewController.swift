//
//  QuoteTableTableViewController.swift
//  InspoQuotes
//
//  Created by Mariola Hullings on 4/23/24.

import UIKit
import StoreKit

class QuoteTableTableViewController: UITableViewController,  SKPaymentTransactionObserver {
    
    let productID = "com.MH.InspoQuotes.PremiumQuotes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inspirational Quotes"
        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumQuotes()
        }
    }
    
    var quoteToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quoteToShow.count
        } else {
            return quoteToShow.count + 1
        }
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
         if indexPath.row < quoteToShow.count{
             cell.textLabel?.text = quoteToShow[indexPath.row]
             cell.textLabel?.numberOfLines = 0
             cell.textLabel?.textColor = .black
             cell.accessoryType = .none
         } else {
             //if indexPath.row is greater than that number (items in quoteToShow) or equal to 6(which it is due to return quoteToShow.count + 1) than perfom this code block.
             cell.textLabel?.text = "Get More Quotes"
             cell.textLabel?.textColor = .systemTeal
             cell.accessoryType = .disclosureIndicator
         }
     return cell
     }
    
    // MARK: - Table view delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //determines that the last row got clicked
        if indexPath.row == quoteToShow.count {
            print("Buy quotes clicked")
            //implement the buying of the in-app purchase
            buyPremiumQuotes()
        }
        //this line of code - when cell is selected it will de-select the cell automatically with a quick animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - In-App Purchases Method
    
    //In this function that we are going to trigger the in app-purchase
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            //Can make payments
            //Creates an in-app purchase request
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
           
        } else {
            //Can't make payments
            print("User Can't make payments")
        }
    }
    
    //this delegate method will infrom us when the transactions have been updated in the paymentQueue
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment successfull
                print("Transaction Successful!")
                showPremiumQuotes()
                UserDefaults.standard.setValue(true, forKey: productID)
                //ends transcation so not holding onto the same transcation
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                //Payment Failed or cancelled payment
                print("Transaction Failed")
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction Failed due to error \(errorDescription)")
                }
                //ends transcation so not holding onto the same transcation
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        quoteToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        if purchaseStatus {
            print("Previously Purchased")
            return true
        } else {
         print("Never Purchased")
            return false
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
    }
}
