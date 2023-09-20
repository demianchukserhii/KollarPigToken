from web3 import Web3

# Ініціалізуйте підключення до Infura
infura_url = "https://mainnet.infura.io/v3/ce12e8d8fc694e1c928fb254a894aa97"
web3 = Web3(Web3.HTTPProvider(infura_url))

# Перевірка підключення
try:
    latest_block = web3.eth.block_number
    print("Connected to Ethereum, latest block:", latest_block)
except Exception as e:
    print("Not connected! Error:", e)

# Отримання даних про останній блок
try:
    block_data = web3.eth.get_block('latest')
    print("Latest block details:", block_data)
except Exception as e:
    print("Error fetching block details:", e)
