# Test the createTransactionEntry function:

- Test when the transaction count is zero. This is the first transaction scenario. You should check if the transaction is added correctly to the mapping.
- Test when the transaction count is not zero. This is the scenario for all subsequent transactions. You should check if the transaction is added correctly to the mapping.
- Test when the previous transaction hash does not match the last transaction's hash. This should trigger the `TRANSACTION_ERROR_OCCURRED error`.

# Test the getAllTransactions function:

- Test when there are no transactions. The function should return an empty array.
- Test when there is one transaction. The function should return an array with one transaction.
- Test when there are multiple transactions. The function should return an array with all the transactions.
