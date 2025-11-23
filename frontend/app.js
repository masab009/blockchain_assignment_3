let web3;
let contract;

const abi = [
  {
    "inputs": [],
    "name": "BookAlreadyBorrowed",
    "type": "error"
  },
  {
    "inputs": [],
    "name": "BookDoesNotExist",
    "type": "error"
  },
  {
    "inputs": [],
    "name": "BookNotBorrowed",
    "type": "error"
  },
  {
    "inputs": [],
    "name": "NotBookOwner",
    "type": "error"
  },
  {
    "inputs": [],
    "name": "NotBorrower",
    "type": "error"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "uint256", "name": "bookId", "type": "uint256" },
      { "indexed": true, "internalType": "address", "name": "owner", "type": "address" },
      { "indexed": false, "internalType": "string", "name": "title", "type": "string" },
      { "indexed": false, "internalType": "string", "name": "contentHash", "type": "string" }
    ],
    "name": "BookAdded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "uint256", "name": "bookId", "type": "uint256" },
      { "indexed": true, "internalType": "address", "name": "borrower", "type": "address" },
      { "indexed": false, "internalType": "uint64", "name": "borrowedAt", "type": "uint64" }
    ],
    "name": "BookBorrowed",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "uint256", "name": "bookId", "type": "uint256" },
      { "indexed": true, "internalType": "address", "name": "borrower", "type": "address" },
      { "indexed": false, "internalType": "uint64", "name": "returnedAt", "type": "uint64" }
    ],
    "name": "BookReturned",
    "type": "event"
  },
  {
    "inputs": [
      { "internalType": "string", "name": "title", "type": "string" },
      { "internalType": "string", "name": "hash", "type": "string" }
    ],
    "name": "addBook",
    "outputs": [
      { "internalType": "uint256", "name": "bookId", "type": "uint256" }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "uint256", "name": "bookId", "type": "uint256" }
    ],
    "name": "borrowBook",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "uint256", "name": "bookId", "type": "uint256" }
    ],
    "name": "returnBook",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getAvailableBooks",
    "outputs": [
      { "internalType": "uint256[]", "name": "ids", "type": "uint256[]" }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "address", "name": "user", "type": "address" }
    ],
    "name": "getUserHistory",
    "outputs": [
      {
        "components": [
          { "internalType": "uint256", "name": "bookId", "type": "uint256" },
          { "internalType": "uint64", "name": "borrowedAt", "type": "uint64" },
          { "internalType": "uint64", "name": "returnedAt", "type": "uint64" }
        ],
        "internalType": "struct BookLibrary.BorrowRecord[]",
        "name": "",
        "type": "tuple[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "uint256", "name": "bookId", "type": "uint256" }
    ],
    "name": "getBook",
    "outputs": [
      { "internalType": "uint256", "name": "id", "type": "uint256" },
      { "internalType": "string", "name": "title", "type": "string" },
      { "internalType": "string", "name": "contentHash", "type": "string" },
      { "internalType": "address", "name": "owner", "type": "address" },
      { "internalType": "address", "name": "borrower", "type": "address" },
      { "internalType": "uint64", "name": "borrowedAt", "type": "uint64" },
      { "internalType": "uint32", "name": "totalBorrows", "type": "uint32" }
    ],
    "stateMutability": "view",
    "type": "function"
  }
];

window.onload = async () => {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    await ethereum.request({ method: "eth_requestAccounts" });

    const networkId = await web3.eth.net.getId();
    
    contract = new web3.eth.Contract(
      abi,
      "0x415F56Ca962cB6104e0d46AaF2DF97d7BB64C8A3"
    );
  }
};

async function addBook() {
  const accounts = await web3.eth.getAccounts();
  await contract.methods.addBook(
    document.getElementById("title").value,
    document.getElementById("hash").value
  ).send({ from: accounts[0] });
  alert("Book Added!");
}

async function borrowBook() {
  const accounts = await web3.eth.getAccounts();
  await contract.methods.borrowBook(
    document.getElementById("borrowId").value
  ).send({ from: accounts[0] });
  alert("Borrowed!");
}

async function returnBook() {
  const accounts = await web3.eth.getAccounts();
  await contract.methods.returnBook(
    document.getElementById("returnId").value
  ).send({ from: accounts[0] });
  alert("Returned!");
}

async function loadAvailable() {
  const ids = await contract.methods.getAvailableBooks().call();
  document.getElementById("available").textContent = JSON.stringify(ids, null, 2);
}
