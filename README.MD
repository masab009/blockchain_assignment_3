# 📚 **Decentralized Book Library DApp**

A simple blockchain-based library management system built using **Solidity**, **Truffle**, **Ganache**, and a minimal **HTML/JS frontend**.
This DApp allows users to:

✓ Add books
✓ Borrow books
✓ Return books
✓ View available books
✓ View user borrow history (via ABI functions)

This project was developed as part of an assignment on **Smart Contract Deployment & DApp Development**.

---

# 🚀 **Project Overview**

This project demonstrates the **full Ethereum DApp workflow**:

### ✔️ Smart Contract (Solidity)

### ✔️ Local Blockchain Deployment (Ganache)

### ✔️ Contract Migration (Truffle)

### ✔️ Frontend Interaction (Web3.js + MetaMask)

Users interact with the BookLibrary smart contract using a simple web interface running on `http://localhost`.

---

# 🛠 **Technologies Used**

| Component             | Technology                |
| --------------------- | ------------------------- |
| Smart Contract        | Solidity `^0.8.20`        |
| Development Framework | Truffle v5                |
| Local Blockchain      | Ganache CLI               |
| Frontend              | HTML, JavaScript, Web3.js |
| Wallet                | MetaMask                  |
| Node Version          | Node 24.x                 |

---

# 📦 **Project Structure**

```
mytruffle/
│
├── contracts/
│   └── BookLibrary.sol
│
├── migrations/
│   └── 1_initial_migration.js
│   └── 2_deploy_booklibrary.js
│
├── build/
│   └── contracts/
│       └── BookLibrary.json   (ABI + bytecode)
│
├── frontend/
│   ├── index.html
│   └── app.js
│
└── truffle-config.js
```

---

# ⚙️ **Setup Instructions**

## 1️⃣ Install Dependencies

Install Node.js, Truffle, and Ganache:

```bash
sudo npm install -g truffle
sudo npm install -g ganache
```

---

## 2️⃣ Compile the Contract

```bash
truffle compile
```

Expected output:

```
Compiling your contracts...
Compiled successfully using solc 0.8.20
```

---

## 3️⃣ Run Ganache (local blockchain)

```bash
ganache
```

Ganache will output:

* 10 test accounts
* Private keys
* RPC running on `127.0.0.1:8545`

Keep this terminal open.

---

## 4️⃣ Deploy the Contract

```bash
truffle migrate --reset
```

You will see:

✔ Contract deployed
✔ Transaction hash
✔ New contract address

Copy the contract address into your frontend’s `app.js`.

---

# 🌐 **Running the Frontend**

You MUST run the frontend using a web server.
Browser `file://` access **WILL NOT** work.

From inside the frontend folder:

```bash
cd frontend
python3 -m http.server 8080
```

Open:

👉 **[http://localhost:8080](http://localhost:8080)**

MetaMask will ask for permission — approve it.

---

# 🎮 **How to Use the DApp**

### ➤ **Add a Book**

Enter:

* Title
* Content hash / IPFS CID

Click **Add** → Approve transaction in MetaMask.

### ➤ **Borrow a Book**

Enter a valid Book ID.
Click **Borrow** → Transaction sent.

### ➤ **Return a Book**

Enter the same Book ID.
Click **Return** → Transaction sent.

### ➤ **Load Available Books**

Click the "Load" button.
Displays all books not currently borrowed.

---

# 📸 **Required Screenshots For Submission**

Include:

1. `truffle version`
2. Ganache showing accounts
3. Project folder after `truffle init`
4. Successful `truffle compile`
5. Successful `truffle migrate`
6. Frontend page running
7. Adding a book (MetaMask transaction)
8. Borrowing a book
9. Returning a book
10. Available books shown on screen

---

# 📜 **Smart Contract Used**

📄 `BookLibrary.sol`
Implements:

* `addBook(string title, string hash)`
* `borrowBook(uint bookId)`
* `returnBook(uint bookId)`
* `getAvailableBooks()`
* `getBook(uint bookId)`
* `getUserHistory(address user)`

Includes custom errors and events for clean UI handling.

---

# 🙌 **Conclusion**

This project demonstrates a complete decentralized application workflow:

* Writing a smart contract
* Compiling & deploying it
* Connecting it with a frontend
* Interacting with it through MetaMask

You now have a fully functioning local Ethereum DApp.

